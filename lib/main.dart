import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'takepicture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MyApp(camera: firstCamera), // Use MyApp widget to pass the camera
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(camera: camera),
      debugShowCheckedModeBanner: false,
    );
  }
}
