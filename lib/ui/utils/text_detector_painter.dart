import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class TextDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  final List<TextElement> elements;

  TextDetectorPainter(this.absoluteImageSize, this.elements);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
          container.boundingBox.left * scaleX,
          container.boundingBox.top * scaleY,
          container.boundingBox.right * scaleX,
          container.boundingBox.bottom * scaleY);
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
