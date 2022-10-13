import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potok/old/config.dart' as config;
import 'package:potok/globals.dart';
import 'package:potok/models/response.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/actions_bottom_sheet.dart';
import 'package:potok/widgets/common/background_card.dart';
import 'package:potok/widgets/common/button.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPictureScreen extends StatefulWidget {
  @override
  _UploadPictureScreenState createState() => _UploadPictureScreenState();
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  PreloadPageController controller = PreloadPageController(initialPage: 0);

  late File? _picture;

  late FilePickerResult? result;

  TextEditingController linkController = TextEditingController();

  bool isEULAgreementChecked = false;

  Future picFromCamera() async {
    final picker = ImagePicker();
    final picture = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    setState(() {
      if (picture != null) {
        this._picture = File(picture.path);
      }
    });
  }

  Future picFromGallery() async {
    this.result = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    ))!;
    setState(() {
      if (result != null) {
        _picture = File(result!.files.single.path!);
      }
    });
  }

  Future<Response> sendPicture() async {
    String base64Picture = base64Encode(_picture!.readAsBytesSync());
    final Response response =
        await postRequest(url: config.uploadPictureUrl, body: {
      "picture": base64Picture,
      "extension": _picture!.path.split(".").last,
      "link": linkController.text.trim(),
    });
    return response;
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
                picFromGallery();
                Navigator.of(context).pop();
              },
            ),
            constructListTile(
              'Camera',
              Icon(Icons.camera, color: theme.colors.secondaryColor),
              () {
                if (isLoading) return;
                isLoading = true;
                picFromCamera();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget get selectButton {
    return BlueButton(
      label: Text('Select picture', style: theme.texts.uploadButton),
      onPressed: () {
        askPicture();
      },
    );
  }

  Widget get nextButton {
    return BlueButton(
      label: Icon(Icons.arrow_forward, color: Colors.white),
      onPressed: () {
        controller.nextPage(
            duration: Duration(milliseconds: 400), curve: Curves.ease);
      },
      isArrow: true,
    );
  }

  Widget get backButton {
    return BlueButton(
      label: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        controller.previousPage(
            duration: Duration(milliseconds: 400), curve: Curves.ease);
      },
      isArrow: true,
    );
  }

  Widget get uploadButton {
    var isLoading = false;
    return BlueButton(
      label: Text('Upload picture', style: theme.texts.uploadButton),
      onPressed: () {
        if (!isEULAgreementChecked) {
          errorFlushbar("You have to agree with EULA terms").show(context);
          return;
        }
        if (isLoading) return;
        isLoading = true;
        if (_picture == null) {
          errorFlushbar("Select picture")..show(context);
          controller.animateToPage(0,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        } else {
          sendPicture().then((response) {
            if (response.status == 200) {
              successFlushbar("Picture uploaded")..show(context);
              setState(() {
                this._picture = null;
              });
            } else {
              errorFlushbar(response.jsonContent)..show(context);
              setState(() {
                this._picture = null;
              });
            }
            linkController.clear();
            controller.animateToPage(0,
                duration: Duration(milliseconds: 400), curve: Curves.ease);
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colors.backgroundColor,
      appBar: AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white, systemNavigationBarColor: Colors.black),
        centerTitle: true,
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        title: Container(
          child: Text(
            "upload",
            style: theme.texts.profileScreenNameYours,
          ),
        ),
      ),
      body: PreloadPageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Center(
            child: _picture == null
                ? selectButton
                : SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: backgroundCardDecoration,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:
                                      Image.file(_picture!, fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: selectButton,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: nextButton,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
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
                                    text:
                                        "You can add link to your picture.\nFor example if you want to post ads.\n",
                                    style: theme.texts.header,
                                  ),
                                  TextSpan(
                                    text:
                                        "Note that picture with link cannot be displayed on 'for you' tab.",
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
                              controller: linkController,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                border: OutlineInputBorder(),
                                labelText: 'Link to attach',
                                labelStyle: theme.texts.inputHint,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Checkbox(
                                    activeColor: theme.colors.secondaryColor,
                                    value: isEULAgreementChecked,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isEULAgreementChecked = !isEULAgreementChecked;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEULAgreementChecked = !isEULAgreementChecked;
                                      });
                                    },
                                    child: Text(
                                      "I agree with EULA terms according content I am uploading.",
                                      style: theme.texts.body,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://www.apple.com/legal/internet-services/itunes/dev/stdeula";
                                if (await canLaunch(url)) {
                                  await launch(url,
                                      forceSafariVC: false,
                                      forceWebView: false);
                                } else {
                                  throw 'Could not launch ${url}';
                                }
                              },
                              child: Text(
                                "Learn more about EULA agreement",
                                style: theme.texts.uploadEULALink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: uploadButton,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: backButton,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
