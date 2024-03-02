import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  // final String imageUrl;
  final dynamic data;

  ImageScreen({super.key, required this.data});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: widget.data['urls']['full'],
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        // setState(() {
                        //   isLoaded = true;
                        // });
                        return Hero(
                          tag: widget.data['id'],
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      progressIndicatorBuilder:
                          (context, child, loadingProgress) {
                        // set isLoaded to true when image is loaded
                        return const Text(
                          'Loading high quality image...',
                          style: TextStyle(fontSize: 22),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            widget.data['description'] ?? 'No description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
