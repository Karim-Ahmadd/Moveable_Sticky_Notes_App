import 'package:flutter/material.dart';
import 'stickynote.dart';

class MoveableStickyNote extends StatefulWidget {
  const MoveableStickyNote(
      {super.key,
      required this.color,
      required this.child,
      required this.fRemoveNote,
      required this.updateStickyNotePos,
      required this.id,
      required this.xRatio,
      required this.yRatio});

  final int id;
  final Color color;
  final Widget child;
  final double xRatio;
  final double yRatio;
  final Function(int) fRemoveNote;
  final Function(int, double, double) updateStickyNotePos;

  @override
  State<MoveableStickyNote> createState() => _MoveableStickyNoteState();
}

class _MoveableStickyNoteState extends State<MoveableStickyNote> {
  late double xPosition;
  late double yPosition;

  bool _firstBuild = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (_firstBuild) {
      xPosition = widget.xRatio * width;
      yPosition = widget.yRatio * height;
      _firstBuild = false;
    }
    return Positioned(
        left: xPosition,
        top: yPosition,
        child: GestureDetector(
            onPanUpdate: (tapInfo) {
              setState(() {
                xPosition += tapInfo.delta.dx;
                yPosition += tapInfo.delta.dy;
              });
            },
            onPanEnd: (tapInfo) {
              widget.updateStickyNotePos(
                  widget.id, xPosition / width, yPosition / height);
            },
            child: StickyNote(
                color: widget.color,
                id: widget.id,
                fRemoveNote: widget.fRemoveNote,
                child: widget.child)));
  }
}
