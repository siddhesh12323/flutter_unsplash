import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  // final String imageUrl;
  final dynamic data;

  const ImageScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: Center(
        child: Image.network(
          data['urls']['full'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return Hero(tag: data['id'], child: child);
            } else {
              return const Text(
                'Loading high quality image...',
                style: TextStyle(fontSize: 22),
              );
            }
          },
        ),
      ),
    );
  }
}
