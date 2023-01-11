import 'package:camera/camera.dart';
import 'package:emotion_detector_app/face_detector_view.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotion Detector - Group9-T1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FaceDetectorView(),
    );
  }
}
