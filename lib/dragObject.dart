import 'package:flutter/material.dart';

class DragObject extends StatefulWidget {
  final String image;
  final String dataName;

  DragObject({this.image, this.dataName});

  @override
  _DragObjectState createState() => _DragObjectState();
}

class _DragObjectState extends State<DragObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Draggable(
        child: Image.asset(
          widget.image,
          width: 100,
          height: 100,
        ),
        data: widget.dataName,
        feedback: Opacity(
          opacity: 0.8,
          child: Image.asset(
            widget.image,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
