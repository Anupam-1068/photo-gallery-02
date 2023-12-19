import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/photo.dart';

class PhotoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Photo>> fetchPhotos() async {
    try {
      final querySnapshot = await _firestore.collection('images').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Photo(
          imageUrl: data['imageUrl'] ?? '',
          title: data['title'] ?? 'No Title',
        );
      }).toList();
    } catch (e) {
      print('Error fetching photos: $e');
      return [];
    }
  }

  Future<void> uploadPhoto(File imageFile) async {
    try {
      // Get the file extension
      String fileExtension = imageFile.path.split('.').last;

      // Upload photo to Firebase Storage
      Reference storageReference = _storage.ref().child('photos/${DateTime.now()}.$fileExtension');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL once the upload is complete
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // Add the photo URL to Firestore
      await _firestore.collection('images').add({'imageUrl': downloadUrl, 'title': 'Uploaded Title'});
    } catch (e) {
      print('Error uploading photo: $e');
    }
  }
}

