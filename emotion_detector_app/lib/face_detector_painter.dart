import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

void paintText(Canvas canvas, String name, double x, double y) {
  final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w900,
      background: Paint()
        ..strokeWidth = 20.0
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round);
  final paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  );
  final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
    ..pushStyle(textStyle)
    ..addText(name);
  const constraints = ui.ParagraphConstraints(width: 200);
  final paragraph = paragraphBuilder.build();
  paragraph.layout(constraints);
  final offset = Offset(x, y);
  canvas.drawParagraph(paragraph, offset);
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.green;

    for (final Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );
      debugPrint(face.boundingBox.toString());
      paintText(
          canvas,
          "Unknown emotion",
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize));

      void paintContour(FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(point.x.toDouble(), rotation, size, absoluteImageSize),
                  translateY(point.y.toDouble(), rotation, size, absoluteImageSize),
                ),
                1,
                paint);
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.faces != faces;
  }
}
