import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:potok/configs/l10n/l10n.dart';
import 'package:potok/configs/theme_data.dart';
import 'package:potok/configs/theme_mode_cubit.dart';
import 'package:potok/resources/models/token.dart';
import 'package:potok/resources/repositories/token_repository.dart';
import 'package:potok/screens/authentication/views/token_screen.dart';
import 'package:potok/screens/common/interface_visibility_cubit.dart';
import 'package:potok/screens/profile/views/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPrintGestureArenaDiagnostics = true;
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    var rep = TokenRepository();
    rep.writeToken(Token(
        token:
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTc2LCJleHAiOjE2NzA0MzE0NDN9.L1ssCzEn2sBaurt2zmWiJa2s5PxEPtuckMQ6D_I_7oY",
        isAnonymous: false));

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>(
          create: (BuildContext context) => ThemeModeCubit(),
        ),
        BlocProvider<InterfaceVisibilityCubit>(
          create: (context) => InterfaceVisibilityCubit(),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            supportedLocales: L10n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: TokenScreen(
              child: BlocProvider<InterfaceVisibilityCubit>(
                create: (context) => InterfaceVisibilityCubit(),
                child: ProfileScreen(profileId: 4),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AntiGlowingOverscrollIndicator extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
