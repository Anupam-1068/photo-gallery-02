import 'package:flutter/material.dart';
import '../controllers/photo_controller.dart';
import '../models/photo.dart';
import 'details_screen.dart';

class GalleryGrid extends StatelessWidget {
  final PhotoController _photoController = PhotoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
      ),
      body: FutureBuilder<List<Photo>>(
        future: _photoController.fetchPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Photo> photos = snapshot.data ?? [];

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: photos.length,
            itemBuilder: (BuildContext context, int index) {
              final photo = photos[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(photo: photo),
                    ),
                  );
                },
                child: Image.network(
                  photo.imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

