import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/models/response.dart';
import 'package:potok/requests/logging.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:potok/widgets/common/navigator_push.dart';

void showAuthenticationScreen(context) {
  Navigator.push(
    context,
    createRoute(
      AuthenticationScreen(),
    ),
  );
}

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLoginScreen = true;

  void goToLoginScreen() {
    setState(() {
      isLoginScreen = true;
    });
  }

  void goToRegistrationScreen() {
    setState(() {
      isLoginScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoginScreen) {
      return LoginScreen(goToRegistrationScreen: goToRegistrationScreen);
    } else {
      return RegistrationScreen(goToLoginScreen: goToLoginScreen);
    }
  }
}

class LoginScreen extends StatefulWidget {
  Function goToRegistrationScreen;

  LoginScreen({this.goToRegistrationScreen});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorText = "";

  bool isSent = false;

  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  String getErrorText() {
    if (isSent) {
      if (emailInput.text == "" || passwordInput.text == "") {
        return "All field should be filled";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      appBar: AppBar(
        leading: BackArrowButton(),
        actions: [
          GestureDetector(
            onTap: () async {
              if (getErrorText() != "") {
                setState(() {
                  errorText = getErrorText();
                });
                return;
              }
              print(emailInput.text);
              Response response = await postRequest(
                url: config.loginUrl,
                body: {
                  "email": emailInput.text,
                  "password": passwordInput.text
                },
                auth: false,
              );
              if (response.status == 200) {
                await writeToken(response.jsonContent["token"]);
                globals.isLogged = true;
                await successFlushbar("Logged in").show(context);
                restartApp(context);
              } else {
                errorFlushbar("Failed to log in").show(context);
                print("Error" +
                    response.jsonContent.toString() +
                    response.detail.toString());
              }
            },
            child: Container(
              child: Icon(
                Icons.check_rounded,
                color: Colors.black,
                size: 30,
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
        ],
        elevation: constraintElevation,
        backgroundColor: theme.colors.appBarColor,
        centerTitle: true,
        title: Text(
          "login",
          style: theme.texts.profileScreenName,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.potok,
              size: 50,
              color: Colors.black,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 11),
              child: TextField(
                controller: emailInput,
                autocorrect: false,
                enableSuggestions: false,
                style: theme.texts.registrationScreen,
                decoration: theme.input.input.copyWith(labelText: "email"),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: TextField(
                controller: passwordInput,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                style: theme.texts.registrationScreen,
                decoration: theme.input.input.copyWith(labelText: "password"),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: Text(
                errorText,
                style: theme.texts.errorRegistration,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: GestureDetector(
                onTap: () {
                  widget.goToRegistrationScreen();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Go to sing up page",
                    style: TextStyle(
                      fontFamily: 'Sofia',
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  Function goToLoginScreen;

  RegistrationScreen({this.goToLoginScreen});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String errorText = "";

  bool isSent = false;

  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController repeatPasswordInput = TextEditingController();

  String getErrorText() {
    if (isSent) {
      if (emailInput.text == "" ||
          passwordInput.text == "" ||
          repeatPasswordInput.text == "") {
        return "All field should be filled";
      }
    }
    if (repeatPasswordInput.text != "" &&
        passwordInput.text != repeatPasswordInput.text) {
      return "Entered passwords are not identical";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      appBar: AppBar(
        leading: BackArrowButton(),
        actions: [
          GestureDetector(
            onTap: () async {
              if (getErrorText() != "") {
                setState(() {
                  errorText = getErrorText();
                });
                return;
              }
              print(emailInput.text);
              Response response = await postRequest(
                url: config.registrationUrl,
                body: {
                  "email": emailInput.text,
                  "password": passwordInput.text
                },
                auth: false,
              );
              if (response.status == 201) {
                await writeToken(response.jsonContent["token"]);
                globals.isLogged = true;
                await successFlushbar("Account created").show(context);
                restartApp(context);
              } else {
                errorFlushbar("Failed to create account").show(context);
                print("Error" +
                    response.jsonContent.toString() +
                    response.detail.toString());
              }
            },
            child: Container(
              child: Icon(
                Icons.check_rounded,
                color: Colors.black,
                size: 30,
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
        ],
        elevation: constraintElevation,
        backgroundColor: theme.colors.appBarColor,
        centerTitle: true,
        title: Text(
          "registration",
          style: theme.texts.profileScreenName,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.potok,
              size: 50,
              color: Colors.black,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 11),
              child: TextField(
                controller: emailInput,
                autocorrect: false,
                enableSuggestions: false,
                style: theme.texts.registrationScreen,
                decoration: theme.input.input.copyWith(labelText: "email"),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: TextField(
                controller: passwordInput,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                style: theme.texts.registrationScreen,
                decoration: theme.input.input.copyWith(labelText: "password"),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: TextFormField(
                controller: repeatPasswordInput,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                style: theme.texts.registrationScreen,
                decoration: theme.input.input.copyWith(
                  labelText: "repeat password",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: Text(
                errorText,
                style: theme.texts.errorRegistration,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
              child: GestureDetector(
                onTap: () {
                  widget.goToLoginScreen();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "Go to login page",
                    style: TextStyle(
                      fontFamily: 'Sofia',
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
