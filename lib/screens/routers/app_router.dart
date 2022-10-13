// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class AppRouter {
//   // final LoginBloc _loginBloc = LoginBloc();
//   // final RegisterBloc _registerBloc = RegisterBloc();
//
//   Route onGenerateRoute(RouteSettings settings) {
//     // final GlobalKey<ScaffoldState> key = settings.arguments;
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider.value(
//
//           ),
//         );
//       case '/login':
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider.value(
//             value: _loginBloc,
//
//           ),
//         );
//       case '/third':
//         return MaterialPageRoute(
//           builder: (_) => ThirdScreen(
//             value: _registerBloc,
//
//           ),
//         );
//       default:
//         return null;
//     }
//   }
// }
