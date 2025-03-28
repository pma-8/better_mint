import 'dart:io';
import 'package:bettermint/business_logic/providers/add_card_provider.dart';
import 'package:bettermint/ui/utils/text_detector_painter.dart';
import 'package:flutter/material.dart';

class PicturePreview extends StatelessWidget {
  final String imagePath;
  final AddCardProvider provider;

  PicturePreview({
    @required this.imagePath,
    @required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        color: Colors.black,
        child: CustomPaint(
          foregroundPainter: TextDetectorPainter(
            provider.imageSize,
            provider.elements,
          ),
          child: AspectRatio(
            aspectRatio: provider.imageSize.aspectRatio,
            child: Image.file(
              File(imagePath),
            ),
          ),
        ),
      ),
    );
  }
}
