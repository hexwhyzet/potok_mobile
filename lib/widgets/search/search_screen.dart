import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potok/config.dart';
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/models/functions.dart';
import 'package:potok/models/objects.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/background_card.dart';
import 'package:potok/widgets/common/button.dart';
import 'package:potok/widgets/common/circle_avatar.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/profile/profile_screen.dart';
import 'package:potok/config.dart' as config;


const int SUGGESTIONS_NUMBER = 10;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        centerTitle: true,
        title: Text("search", style: theme.texts.profileScreenNameYours),
        actions: <Widget>[
          IconButton(
            icon: Icon(AppIcons.search, color: Colors.black, size: 33),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(), query: '');
            },
          )
        ],
      ),
      body: TrendingProfiles(),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final Profile profile;

  ProfileTile({this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 0),
      onTap: () {
        Navigator.push(
          context,
          createRoute(
            ProfileScreen(
              profile: profile,
            ),
          ),
        );
      },
      title: Row(
        children: [
          CustomCircleAvatar(profile: profile, radius: 30),
          Container(height: 0, width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(profile.screenName,
                    style: theme.texts.searchProfileScreenName),
                Text(profile.name, style: theme.texts.searchProfileName),
                Text(
                    "${shortenNum(profile.followersNum)} followers ${shortenNum(profile.likesNum)} likes",
                    style: theme.texts.searchProfileStats),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> recent = [];

  DataSearch({
    String hintText = "start typing...",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  Future<Response> requestSuggestionList(query) async {
    Response response =
        await getRequest("$autoFill/$query/$SUGGESTIONS_NUMBER/0");
    return response;
  }

  Future<Response> requestResultList(query) async {
    Response response =
        await getRequest("$search/$query/$SUGGESTIONS_NUMBER/0");
    return response;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: theme.colors.secondaryColor,
      ),
      textTheme: TextTheme(
        headline6: theme.texts.searchText,
      ),
      appBarTheme: AppBarTheme(
        elevation: constraintElevation,
        color: theme.colors.appBarColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.texts.searchHint,
        border: InputBorder.none,
      ),
    );
  }

  @override
  buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear_rounded),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  buildLeading(BuildContext context) {
    return BackArrowButton();
  }

  @override
  buildResults(BuildContext context) {
    if (query == "") {
      return SafeArea(
        bottom: true,
        child: Center(
          child: Text(
            "Enter some query",
            style: theme.texts.searchEmptyQuery,
          ),
        ),
      );
    }

    return FutureBuilder<Response>(
      future: requestResultList(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> content = objectsFromJson(snapshot.data.jsonContent);
          return ListView.builder(
            itemBuilder: (context, index) {
              Profile profile = content[index];
              return ProfileTile(profile: profile);
            },
            itemCount: content.length,
          );
        } else {
          return Center(
            child: StyledLoadingIndicator(color: theme.colors.secondaryColor),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Response>(
      future: requestSuggestionList(query),
      builder: (context, snapshot) {
        List<String> content;
        if (query.length == 0) {
          content = recent;
        } else {
          if (snapshot.hasData) {
            content = objectsFromJson(snapshot.data.jsonContent)
                .map((element) => element.screenName.toString())
                .toList();
          } else {
            return Center(
              child: StyledLoadingIndicator(
                color: theme.colors.secondaryColor,
              ),
            );
          }
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                query = content[index];
                recent.add(query);
                showResults(context);
              },
              title: RichText(
                text: TextSpan(
                  text: content[index].substring(0, query.length),
                  style: theme.texts.searchProfileSuggestion,
                  children: [
                    TextSpan(
                      text: content[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: content.length,
        );
      },
    );
  }
}

class TrendingProfiles extends StatefulWidget {
  @override
  _TrendingProfilesState createState() => _TrendingProfilesState();
}

class _TrendingProfilesState extends State<TrendingProfiles> {
  Storage storage;

  ScrollController scrollController;

  @override
  void initState() {
    storage = Storage(
      sourceUrl: config.trendingProfiles,
      loadMoreNumber: 15,
      deltaToReload: 5,
      offset: true,
    );
    storage.addObjects().then((value) {
      setState(() {});
    });
    this.scrollController = ScrollController();
    this.scrollController.addListener(() {
      if (storage.hasMore && !storage.isLoading && scrollController.position.extentAfter < 100) {
        storage.addObjects().then((value) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (storage.size() == 0 && storage.isLoading == true) {
      return Center(
        child: StyledLoadingIndicator(
          color: theme.colors.secondaryColor,
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: storage.size(),
      itemBuilder: (context, position) {
        Profile profile = storage.getObject(position);
        return ProfileTile(
          profile: profile,
        );
      },

    );
  }
}

class SuggestionWidget extends StatefulWidget {
  @override
  _SuggestionWidgetState createState() => _SuggestionWidgetState();
}

class _SuggestionWidgetState extends State<SuggestionWidget> {
  bool isLoading = false;
  final textController = TextEditingController();

  Widget getButton() {
    if (isLoading) {
      return StyledLoadingIndicator(color: theme.colors.secondaryColor);
    } else {
      return BlueButton(
        label: Text('Send', style: theme.texts.uploadButton),
        onPressed: () {
          if (textController.text.trim().length == 0) {
            errorFlushbar("Please, write something")..show(context);
            return;
          }
          ;
          setState(() {
            this.isLoading = true;
          });
          postRequest(suggestProfile, {"content": textController.text})
              .then((data) {
            if (data.status == "ok") {
              successFlushbar("Suggestion sent")..show(context);
              setState(() {
                this.isLoading = false;
                textController.clear();
              });
              FocusScope.of(context).unfocus();
            } else {
              errorFlushbar("Failed to send")..show(context);
              setState(() {
                this.isLoading = false;
                textController.clear();
              });
              FocusScope.of(context).unfocus();
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colors.backgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Container(
                decoration: backgroundCardDecoration,
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "You can suggest a source of memes.\n",
                            style: theme.texts.header,
                          ),
                          TextSpan(
                            text:
                            "Just paste url of profile you would like to see in the app. Team of moderators will review your suggestion.",
                            style: theme.texts.body,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(
                        fontFamily: "Sofia",
                        fontSize: 18,
                      ),
                      controller: textController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                        border: OutlineInputBorder(),
                        labelText: 'Url to profile',
                        labelStyle: theme.texts.inputHint,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(110, 110, 110, 1),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(170, 170, 170, 1),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: getButton(),
            ),
          ),
        ],
      ),
    );
  }
}
