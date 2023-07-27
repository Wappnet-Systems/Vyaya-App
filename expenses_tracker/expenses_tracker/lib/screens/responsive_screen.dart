import 'package:flutter/material.dart';


class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Screen Example'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine the screen width and height
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // Calculate screen aspect ratio
          double aspectRatio = screenWidth / screenHeight;

          // Define breakpoints
          const double mobileBreakpoint = 600;
          const double tabletBreakpoint = 900;
          const double desktopBreakpoint = 1200;

          // Mobile view
          if (screenWidth < mobileBreakpoint) {
            return const MobileScreen();
          }
          // Tablet view
          else if (screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint) {
            return const TabletScreen();
          }
          // Desktop view
          else if (screenWidth >= tabletBreakpoint && screenWidth < desktopBreakpoint) {
            return const DesktopScreen();
          }
          // Large screen view
          else {
            return const LargeScreen();
          }
        },
      ),
    );
  }
}

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Mobile Screen',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class TabletScreen extends StatelessWidget {
  const TabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tablet Screen',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Desktop Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class LargeScreen extends StatelessWidget {
  const LargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Large Screen',
        style: TextStyle(fontSize: 28),
      ),
    );
  }
}