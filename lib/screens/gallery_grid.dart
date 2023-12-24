import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/image_retrieve.dart';
import '../controllers/image_upload.dart';
import '../models/photo.dart';
import '../models/user_model.dart';
import 'details_screen.dart';

class GalleryGrid extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      // appBar: AppBar(
      //   title: Text('Photo Gallery'),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              'Gallery',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageUpload(
                                  userId: loggedInUser.uid,
                                )));
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder<List<Photo>>(
                  future: ImageRetrieve(userId: loggedInUser.uid).retrieveImages(),
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
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
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
                          child: Hero(
                            tag: 'photoHero${photo.imageUrl}',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(photo.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: photos.length,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
