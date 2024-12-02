import 'package:flutter/material.dart';
import 'stickynotepainter.dart';

class StickyNote extends StatelessWidget {
  const StickyNote(
      {super.key,
      required this.color,
      required this.child,
      required this.id,
      required this.fRemoveNote});

  final Color color;
  final Widget child;
  final int id;
  final Function(int) fRemoveNote;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180,
        height: 170,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: CustomPaint(
                      painter: StickyNotePainter(color: color),
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Center(child: child))))),
          Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                  child: ElevatedButton(
                      onPressed: () {
                        fRemoveNote(id);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(Icons.clear, color: Colors.white))))
        ]));
  }
}
