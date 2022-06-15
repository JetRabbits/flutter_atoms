import 'package:flutter/material.dart';

class CarouselIndicator extends StatefulWidget {
  final ScrollController scrollController;
  final int itemsCount;
  final double scrollSize;

  CarouselIndicator(
      {Key? key,
      required this.scrollController,
      required this.itemsCount,
      required this.scrollSize})
      : super(key: key);

  @override
  _CarouselIndicatorState createState() => _CarouselIndicatorState();
}

class _CarouselIndicatorState extends State<CarouselIndicator> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      var _newIndex =
          (widget.scrollController.position.pixels / widget.scrollSize).round();
      if (_newIndex != currentIndex && _newIndex < widget.itemsCount) {
        setState(() {
          currentIndex = _newIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemsCount, (index) {
        return Container(
          width: 6.0,
          height: 6.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).disabledColor,
          ),
        );
      }),
    );
  }
}
