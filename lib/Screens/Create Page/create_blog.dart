import 'package:blog_app/Services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, description;
  bool _isLoading = false;

  CrudMethods crudMethods = CrudMethods();
  String imageUrl;
  File _selectedImage1;
  File _selectedImage2;
  final picker = ImagePicker();

  Future getImage(bool isCamera) async {
    final pickedFile1 = await picker.getImage(source: ImageSource.gallery);
    final pickedFile2 = await picker.getImage(source: ImageSource.camera);

    // var pickedFile;
    //
    // if (isCamera) {
    //   pickedFile = await picker.getImage(source: ImageSource.camera);
    // } else {
    //   pickedFile = await picker.getImage(source: ImageSource.gallery);
    // }

    setState(() {
      if ( pickedFile1 != null) {
        _selectedImage1 = File(pickedFile1.path);

      }
      else {
        print('No image selected.');
      }
    });
  }

  void uploadBlog() async {
    if (_selectedImage1 != null) {
      setState(() {
        _isLoading = true;
      });

      // Upload Image to Firebase Storage

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(_selectedImage1);

      await task.whenComplete(() async {
        try {
          imageUrl = await firebaseStorageRef.getDownloadURL();
        } catch (e) {
          print(e);
        }
      });

      Map<String, dynamic> blogMap = {
        "imageUrl": imageUrl,
        "authorName": authorName,
        "title": title,
        "description": description,
      };

      FirebaseFirestore.instance
          .collection("blogs")
          .add(blogMap)
          .catchError((onError) {
        print("facing an issue while uploading data to firestore : $onError");
      });

      // crudMethods.addData(blogMap).then((result) {
      Navigator.pop(context);
      //});
    } else if (_selectedImage2 != null ) {
      setState(() {
        _isLoading = true;
      });

      // Upload Image to Firebase Storage

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(_selectedImage2);

      await task.whenComplete(() async {
        try {
          imageUrl = await firebaseStorageRef.getDownloadURL();
        } catch (e) {
          print(e);
        }
      });

      Map<String, dynamic> blogMap = {
        "imageUrl": imageUrl,
        "authorName": authorName,
        "title": title,
        "description": description,
      };

      FirebaseFirestore.instance
          .collection("blogs")
          .add(blogMap)
          .catchError((onError) {
        print("facing an issue while uploading data to firestore : $onError");
      });

      // crudMethods.addData(blogMap).then((result) {
      Navigator.pop(context);
      //});


    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Blog',
              style: TextStyle(fontSize: 24, color: Colors.blueAccent),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                Icons.upload_rounded,
              ),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                getImage(true);
                              },
                              child: _selectedImage1 != null
                                  ? Container(
                                      height: 140,
                                      width: 140,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedImage1,
                                            fit: BoxFit.fill,
                                          )),
                                    )
                                  : Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Icon(
                                        Icons.add_a_photo_rounded,
                                        color: Colors.black26,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                getImage(true);
                              },
                              child: _selectedImage2 != null
                                  ? Container(
                                      height: 140,
                                      width: 140,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedImage2,
                                            fit: BoxFit.fill,
                                          )),
                                    )
                                  : Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Icon(
                                        Icons.add_a_photo_rounded,
                                        color: Colors.black26,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        authorName = value;
                      },
                      decoration: InputDecoration(hintText: 'Author Name'),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: InputDecoration(hintText: 'Title'),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: InputDecoration(hintText: 'Description'),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          uploadBlog();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        //20
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Color(0xFFA95EFA),
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
