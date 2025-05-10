import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppTransitions {
  static PageRoute sharedAxisTransition(
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
    Duration duration = const Duration(milliseconds: 700),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }
}
