import 'package:flutter/material.dart';

class FadeSlideTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Duration reverseDuration;

  FadeSlideTransitionRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 750),
    this.reverseDuration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation configuration
            var curve = Curves.ease;

            // Define slide tween
            var slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: curve));

            // Check if it's the forward or reverse transition
            bool isEntering = animation.status == AnimationStatus.forward;

            // Apply slide transition
            return FadeTransition(
              opacity: animation.drive(CurveTween(curve: curve)),
              child: SlideTransition(
                position: slideTween.animate(animation),
                child: child,
              ),
            );
          },
        );
}

class FadeSlideTransitionRouteForList extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Duration reverseDuration;

  FadeSlideTransitionRouteForList({
    required this.page,
    this.duration = const Duration(milliseconds: 750),
    this.reverseDuration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation configuration
            var curve = Curves.ease;

            // Define slide tween
            var slideTween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .chain(CurveTween(curve: curve));

            // Check if it's the forward or reverse transition
            bool isEntering = animation.status == AnimationStatus.forward;

            // Apply slide transition
            return FadeTransition(
              opacity: animation.drive(CurveTween(curve: curve)),
              child: SlideTransition(
                position: slideTween.animate(animation),
                child: child,
              ),
            );
          },
        );
}
