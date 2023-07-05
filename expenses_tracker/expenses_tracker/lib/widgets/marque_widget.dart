import 'package:flutter/material.dart';

class MarqueWidget extends StatefulWidget {
  final String message;
  final Duration scrollDuration;
  const MarqueWidget({super.key,required this.message,required this.scrollDuration});

  @override
  State<MarqueWidget> createState() => _MarqueWidgetState();
}

class _MarqueWidgetState extends State<MarqueWidget> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _startScrolling();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    Future.delayed(Duration.zero, () async {
      while (true) {
        await Future.delayed(widget.scrollDuration);
        _scrollOffset += 1.0;
        if (_scrollOffset >= _scrollController.position.maxScrollExtent) {
          _scrollOffset = 0.0;
          _scrollController.jumpTo(_scrollOffset);
        } else {
          _scrollController.animateTo(
            _scrollOffset,
            duration: widget.scrollDuration,
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            widget.message,
            style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.015),
          ),
        ),
      ],
    );
  }
}