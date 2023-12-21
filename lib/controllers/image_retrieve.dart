import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/photo.dart';

class ImageRetrieve extends StatefulWidget {
  final String? userId;

  const ImageRetrieve({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageRetrieve> createState() => _ImageRetrieveState();

  Future<List<Photo>> retrieveImages() async {
    // Fetch images from Firestore or any other data source
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("images")
          .get();

      List<Photo> photos = querySnapshot.docs
          .map((doc) => Photo(
        imageUrl: doc['downloadURL'],
        title: 'Image Title', // You may need to retrieve title from Firestore as well
      ))
          .toList();

      return photos;
    } catch (e) {
      print("Error retrieving images: $e");
      return [];
    }
  }
}

class _ImageRetrieveState extends State<ImageRetrieve> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Images")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection("images")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String url = snapshot.data!.docs[index]['downloadURL'];
                  return Image.network(
                    url,
                    height: 300,
                    fit: BoxFit.fitWidth,
                  );
                },
              );
            } else {
              return Center(
                child: Text("No images found"),
              );
            }
          } else {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}

