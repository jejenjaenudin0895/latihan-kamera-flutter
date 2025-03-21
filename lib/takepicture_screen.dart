import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tugaskamera/photo_filter_carousel.dart';


// Layar yang memungkinkan pengguna mengambil gambar menggunakan kamera tertentu.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Untuk menampilkan output terkini dari Kamera,
    // buat CameraController.
    _controller = CameraController(
      // Dapatkan kamera tertentu dari daftar kamera yang tersedia.
      widget.camera,
      // Tentukan resolusi yang akan digunakan.
      ResolutionPreset.medium,
    );

    // Selanjutnya, inisialisasikan pengontrol. Ini akan mengembalikan Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Buang pengontrol saat widget dibuang.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture -  1125170031')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan indikator pemuatan saat kamera sedang diinisialisasi
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan pesan error jika ada kesalahan dalam inisialisasi
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Setelah selesai, tampilkan pratinjau kamera dan tombol untuk mengambil gambar
            return Column(
              children: [
                Expanded(child: CameraPreview(_controller)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Ambil gambar dan dapatkan path
                        final XFile picture = await _controller.takePicture();

                        // Navigasikan ke layar DisplayPictureScreen dengan path gambar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoFilterCarousel(imagePath: picture.path),
                          ),
                        );
                      } catch (e) {
                        // Tangani error jika terjadi kesalahan saat mengambil gambar
                        print('Error taking picture: $e');
                      }
                    },
                    child: const Text('Take Picture'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
