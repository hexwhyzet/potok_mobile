import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/resources/repositories/authentication_repository.dart';
import 'package:potok/screens/authentication/token_bloc.dart';
import 'package:potok/screens/authentication/token_state.dart';
import 'package:potok/screens/common/splash_screen.dart';

class TokenScreen extends StatelessWidget {
  final Widget child;

  TokenScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TokenBloc(
        authenticationRepository: AuthenticationRepository(context),
      ),
      child: BlocBuilder<TokenBloc, TokenState>(
        builder: (context, state) {
          if (state is TokenNotReceived) {
            return SplashScreen(color: Colors.white);
          } else {
            return child;
          }
        },
      ),
    );
  }
}
