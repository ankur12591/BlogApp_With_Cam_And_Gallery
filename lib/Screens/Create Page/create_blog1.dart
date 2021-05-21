import 'package:blog_app/Services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog1 extends StatefulWidget {
  @override
  _CreateBlog1State createState() => _CreateBlog1State();
}

class _CreateBlog1State extends State<CreateBlog1> {
  String authorName, title, description;
  bool _isLoading = false;

  CrudMethods crudMethods = CrudMethods();
  String imageUrl;
  File _selectedImage;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void uploadBlog() async {
    if (_selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      // Upload Image to Firebase Storage

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(_selectedImage);

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
                    GestureDetector(
                      child: _selectedImage != null
                          ? Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage,
                                    fit: BoxFit.fill,
                                  )),
                            )
                          : Container(
                              height: 190,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.black26,
                                size: 40,
                              ),
                            ),
                    ),

                    SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                //20
                                width: 90,
                                height: 60,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Color(0xFFA95EFA),
                                  onPressed: () {
                                    getImageFromCamera();
                                  },
                                  child: Text(
                                    "Camera",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                //20
                                width: 90,
                                height: 60,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Color(0xFFA95EFA),
                                  onPressed: () {
                                    getImageFromGallery();
                                  },
                                  child: Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                    SizedBox(height: 18),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      //20
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Color(0xFFA95EFA),
                        onPressed: () {
                          setState(() {
                            uploadBlog();
                          });
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
