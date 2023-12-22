import 'package:flutter/material.dart';

class ZoomInTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final bool zoomIn;

  ZoomInTransitionRoute({required this.page, this.zoomIn = true})
      : super(
          transitionDuration: const Duration(milliseconds: 750),
          reverseTransitionDuration: const Duration(milliseconds: 750),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.ease;
            var slideTween = Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero).chain(CurveTween(curve: curve));
            var fadeTween = Tween(begin: 0.5, end: 1.0);

            if (zoomIn) {
              var zoomTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
              return ScaleTransition(
                scale: animation.drive(zoomTween),
                child: SlideTransition(
                  position: animation.drive(slideTween),
                  child: FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: child,
                  ),
                ),
              );
            } else {
              var zoomTween = Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: curve));
              return ScaleTransition(
                scale: animation.drive(zoomTween),
                child: SlideTransition(
                  position: animation.drive(slideTween),
                  child: FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: child,
                  ),
                ),
              );
            }
          },
        );
}


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
            var curve = Curves.ease;

            var slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: curve));

            // Check if it's the forward or reverse transition
            // bool isEntering = animation.status == AnimationStatus.forward;

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
            // bool isEntering = animation.status == AnimationStatus.forward;

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
