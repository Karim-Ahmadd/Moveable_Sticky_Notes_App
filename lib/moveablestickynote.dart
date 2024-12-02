import 'package:flutter/material.dart';
import 'stickynote.dart';

class MoveableStickyNote extends StatefulWidget {
  MoveableStickyNote(
      {super.key,
      required this.color,
      required this.child,
      required this.fRemoveNote})
      : id = count++;

  final Color color;
  final Widget child;
  final Function(int) fRemoveNote;

  static int count = 0;
  final int id;

  @override
  State<MoveableStickyNote> createState() => _MoveableStickyNoteState();
}

class _MoveableStickyNoteState extends State<MoveableStickyNote> {
  double xPosition = 0;
  double yPosition = 0;
  @override
  Widget build(BuildContext context) {
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
            child: StickyNote(
                color: widget.color,
                id: widget.id,
                fRemoveNote: widget.fRemoveNote,
                child: widget.child)));
  }
}
