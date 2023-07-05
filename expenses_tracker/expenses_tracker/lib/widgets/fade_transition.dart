import 'package:flutter/material.dart';

class FadeSlideTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Duration reverseDuration;

  FadeSlideTransitionRoute({required this.page, this.duration = const Duration(milliseconds: 750), this.reverseDuration = const Duration(milliseconds: 500)})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var scaleTween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
            var fadeTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}
