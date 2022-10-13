import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/screens/common/animated_visibility.dart';

class InterfaceVisibilityCubit extends Cubit<bool> {
  InterfaceVisibilityCubit() : super(true);
}

class InterfaceVisibilityContent extends StatelessWidget {
  InterfaceVisibilityContent({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      visible: BlocProvider.of<InterfaceVisibilityCubit>(context).state,
      child: child,
    );

    // return BlocBuilder(
    //   builder: (context, state) {
    //     return AnimatedVisibility(
    //       visible: BlocProvider.of<InterfaceVisibilityCubit>(context).state,
    //       child: child,
    //     );
    //   },
    // );
  }
}
