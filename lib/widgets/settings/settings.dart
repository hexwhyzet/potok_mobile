import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/models/objects.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/actions_bottom_sheet.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:potok/widgets/common/navigator_push.dart';

Widget header(String text) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
    child: Text(
      text,
      style: theme.texts.settingsHeader,
    ),
  );
}

Widget tile(String text, Function function) {
  return GestureDetector(
    onTap: function,
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              text,
              style: theme.texts.settingsTile,
            ),
          ),
          Container(
            child: IconTheme(
              data: theme.icons.settingsArrow,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Icon(AppIcons.back),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class AppSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Container(
          child: Text(
            "activity",
            style: theme.texts.profileScreenNameYours,
          ),
        ),
      ),
      body: ListView(
        children: [
          header("Privacy"),
          tile("Change profile publicity", () {}),
          tile("Change liked pictures publicity", () {}),
        ],
      ),
    );
  }
}

class ProfileSettingsPage extends StatefulWidget {
  Profile profile;

  ProfileSettingsPage({this.profile});

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final textController = TextEditingController();
  final cropKey = GlobalKey<CropState>();

  File picture;

  FilePickerResult result;

  void reloadProfile() async {
    getRequest(url: widget.profile.reloadUrl).then((response) {
      widget.profile = objectFromJson(response.jsonContent);
      setState(() {});
    });
  }

  Widget changeName(context) {
    textController.text = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Container(
          child: Text(
            "change name",
            style: theme.texts.appBarSettings,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: TextField(
          textInputAction: TextInputAction.send,
          onEditingComplete: () {
            getRequest(url: "${config.changeName}/${textController.text}")
                .then((response) {
              if (response.status == 200) {
                Navigator.pop(context);
                successFlushbar("Name is changed")..show(context);
              } else {
                errorFlushbar(response.detail)..show(context);
              }
            });
          },
          autocorrect: false,
          style: theme.texts.settingsInput,
          cursorColor: theme.colors.secondaryColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            hintText: "Write new name...",
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          ),
          autofocus: true,
          controller: textController,
        ),
      ),
    );
  }

  Widget changeUsername(context) {
    textController.text = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Container(
          child: Text(
            "change username",
            style: theme.texts.appBarSettings,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: TextField(
          textInputAction: TextInputAction.send,
          onEditingComplete: () {
            getRequest(url: "${config.changeUsername}/${textController.text}")
                .then((response) {
              if (response.status == 200) {
                Navigator.pop(context);
                successFlushbar("Username is changed")..show(context);
              } else {
                errorFlushbar(response.detail)..show(context);
              }
            });
          },
          autocorrect: false,
          style: theme.texts.settingsInput,
          cursorColor: theme.colors.secondaryColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colors.profileAvatarOutline,
                width: 1.5,
              ),
            ),
            hintText: "Write new username...",
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          ),
          autofocus: true,
          controller: textController,
        ),
      ),
    );
  }

  Future picFromCamera() async {
    final picker = ImagePicker();
    final picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        this.picture = File(picture.path);
      }
    });
  }

  Future picFromGallery() async {
    this.result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );
    setState(() {
      if (result != null) {
        picture = File(result.files.single.path);
      }
    });
  }

  Future<void> cropImage() async {
    print(cropKey.currentState);
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: picture,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    debugPrint('$file');
  }

  Future<Response> sendPicture() async {
    String base64Picture = base64Encode(picture.readAsBytesSync());
    final Response response = await postRequest(
      url: config.uploadAvatarUrl,
      body: {
        "avatar": base64Picture,
        "extension": picture.path.split(".").last,
      },
    );
    return response;
  }

  void cropPicture() {
    if (picture == null) {
      return;
    }
    Navigator.push(
      context,
      createRoute(
        CropPage(
          file: picture,
        ),
      ),
    ).then((result) {
      if (result != null) {
        picture = result;
        sendPicture().then((value) {
          successFlushbar("Avatar uploaded")..show(context);
          reloadProfile();
        });
      }
    });
  }

  void askPicture() {
    var isLoading = false;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return BottomActionsSheet(
          bottomActionsListTiles: [
            constructListTile(
              'Gallery',
              Icon(Icons.photo_library, color: theme.colors.secondaryColor),
              () {
                if (isLoading) return;
                isLoading = true;
                picFromGallery().then((value) {
                  cropPicture();
                });
                Navigator.of(context).pop();
              },
            ),
            constructListTile(
              'Camera',
              Icon(Icons.camera, color: theme.colors.secondaryColor),
              () {
                if (isLoading) return;
                isLoading = true;
                picFromCamera().then((value) {
                  cropPicture();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Container(
          child: Text(
            "edit profile",
            style: theme.texts.appBarSettings,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colors.profileAvatarOutline,
                borderRadius: BorderRadius.circular(70),
              ),
              padding: EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colors.backgroundColor,
                  borderRadius: BorderRadius.circular(68),
                ),
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(67),
                  child: Container(
                    width: 134,
                    height: 134,
                    child: StyledFadeInImageNetwork(
                      image: widget.profile.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              askPicture();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Text(
                "Change photo",
                style: theme.texts.settingsTile,
              ),
            ),
          ),
          header("Account details"),
          tile("Change name", () {
            Navigator.push(
              context,
              createRoute(
                changeName(context),
              ),
            );
          }),
          tile("Change username", () {
            Navigator.push(
              context,
              createRoute(
                changeUsername(context),
              ),
            );
          }),
          header("Privacy settings"),
          tile("Change profile publicity", () {
            Navigator.push(
              context,
              createRoute(
                ChangeProfilePublicity(
                    profile: widget.profile, reloadProfile: reloadProfile),
              ),
            );
          }),
          tile("Change liked pictures publicity", () {
            Navigator.push(
              context,
              createRoute(
                ChangeProfilePublicity(
                    profile: widget.profile,
                    reloadProfile: reloadProfile,
                    likedPictures: true),
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget get emptyCheckBox {
  return Container(
    height: 16,
    width: 16,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget get filledCheckBox {
  return Container(
    height: 16,
    width: 16,
    decoration: BoxDecoration(
      color: theme.colors.secondaryColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
      Icons.check_rounded,
      color: Colors.white,
      size: 11,
    ),
  );
}

class ChangeProfilePublicity extends StatefulWidget {
  final profile;
  Function reloadProfile;
  bool likedPictures;

  ChangeProfilePublicity(
      {this.profile, this.reloadProfile, this.likedPictures = false});

  @override
  _ChangeProfilePublicityState createState() => _ChangeProfilePublicityState();
}

class _ChangeProfilePublicityState extends State<ChangeProfilePublicity> {
  bool isPublic;

  @override
  void initState() {
    isPublic = widget.likedPictures
        ? widget.profile.areLikedPicturesPublic
        : widget.profile.isPublic;
  }

  bool doesHaveChanges() {
    if (widget.likedPictures) {
      return isPublic == widget.profile.areLikedPicturesPublic;
    } else {
      return isPublic == widget.profile.isPublic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Container(
          child: Text(
            widget.likedPictures
                ? "liked pictures publicity"
                : "profile publicity",
            style: theme.texts.appBarSettings,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: true,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  isPublic = true;
                  setState(() {});
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          widget.likedPictures
                              ? "Public liked pictures"
                              : "Public profile",
                          style: theme.texts.settingsTile,
                        ),
                      ),
                      isPublic ? filledCheckBox : emptyCheckBox,
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  isPublic = false;
                  setState(() {});
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          widget.likedPictures
                              ? "Private liked pictures"
                              : "Private profile",
                          style: theme.texts.settingsTile,
                        ),
                      ),
                      isPublic ? emptyCheckBox : filledCheckBox,
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      if (doesHaveChanges()) {
                        return;
                      }
                      getRequest(
                              url: (widget.likedPictures
                                      ? config
                                          .settingChangeAreLikedPicturesPublic
                                      : config.settingChangeIsPublic) +
                                  "/" +
                                  (isPublic ? "1" : "0"))
                          .then((response) {
                        if (response.status == 200) {
                          widget.reloadProfile();
                          Navigator.of(context).pop();
                          successFlushbar("Publicity is changed")
                            ..show(context);
                        } else {
                          errorFlushbar(response.detail)..show(context);
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: (doesHaveChanges())
                          ? Colors.grey.shade300
                          : theme.colors.secondaryColor,
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropPage extends StatefulWidget {
  File file;

  CropPage({this.file});

  @override
  _CropPageState createState() => new _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final cropKey = GlobalKey<CropState>();

  @override
  void dispose() {
    super.dispose();
    // widget.file?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: PictureViewerBackArrowButton(),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(
            widget.file,
            key: cropKey,
            aspectRatio: 1,
            alwaysShowGrid: true,
            maximumScale: 10,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Crop picture and upload',
                  style: theme.texts.cropPictureButton,
                ),
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      return;
    }

    final sample = await ImageCrop.sampleImage(
      file: widget.file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    Navigator.pop(context, file);
  }
}
