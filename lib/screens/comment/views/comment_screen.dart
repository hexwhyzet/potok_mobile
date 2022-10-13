import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/configs/constraints.dart';
import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/repositories/comment_repository.dart';
import 'package:potok/resources/repositories/loadable_list_repository.dart';
import 'package:potok/screens/comment/comment_bloc.dart';
import 'package:potok/screens/comment/comment_state.dart';
import 'package:potok/screens/common/back_arrow_button.dart';
import 'package:potok/screens/common/interface_visibility_cubit.dart';
import 'package:potok/screens/common/snackbar.dart';
import 'package:potok/screens/loadable_list/loadable_list_bloc.dart';
import 'package:potok/screens/loadable_list/loadable_list_state.dart';

const int LOAD_MORE_THRESHOLD = 5;

class CommentPageViewWithoutPreCreatedLoadableList extends StatelessWidget {
  final LoadableListRepository<CommentBloc> repository;

  CommentPageViewWithoutPreCreatedLoadableList({
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          LoadableListBloc<CommentBloc>(repository: this.repository),
      child: CommentsPageView(),
    );
  }
}

class CommentsPageView extends StatelessWidget {
  CommentsPageView({
    this.initialPage = 0,
  });

  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadableListBloc<CommentBloc>,
        LoadableListState<CommentBloc>>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      elevation: constraintElevation,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${state.list.length} comments",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12)),
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  child: Icon(Icons.close),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      // child: listView,
                    ),
                    AddComment(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentView extends StatelessWidget {
  CommentView({
    required this.commentId,
    this.preloadedComment,
  });

  final int commentId;
  final Comment? preloadedComment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentBloc>(
      create: (BuildContext context) => CommentBloc(
        commentId: this.commentId,
        commentRepository: CommentRepository(context),
        preloadedComment: preloadedComment,
      ),
      child: CommentBlocView(),
    );
  }
}

class CommentBlocView extends StatelessWidget {
  final defaultToolbarIconSize = 32.0;
  final defaultToolbarIconColor = Colors.grey[200];
  final defaultToolbarTextColor = Colors.grey[100];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (BuildContext context, CommentState state) async {
        if (state.share != null) {
          await Clipboard.setData(ClipboardData(text: state.share!.url));
        }
        if (state.infoSnackbar != null) {
          showInfoSnackbar(context, state.infoSnackbar!);
        }
      },
      builder: (t1, t2) {
        return Container();
      },
      // builder: _buildCommentContainer,
    );
  }
}

class AddComment extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          left: false,
          right: false,
          child: Container(
            alignment: Alignment.center,
            height: ConstraintsHeights.navigationBarHeight,
            child: TextField(
              controller: textController,
              readOnly: true,
              // style: widget.dynamicCommentSectionTextStyle,
              decoration: InputDecoration(
                // hintStyle: widget.staticCommentSectionTextStyle,
                border: InputBorder.none,
                hintText: "Add comment...",
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: ConstraintsHeights.navigationBarHeight,
                      color: Colors.red,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () {
                            // BlocProvider.of<LoadableListBloc<CommentBloc>>(context).add(event);
                          },
                          controller: textController,
                          autofocus: true,
                          // style: theme.texts.yourComment,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add comment...",
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
