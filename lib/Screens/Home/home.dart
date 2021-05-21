import 'package:blog_app/Screens/Create%20Page/create_blog1.dart';
import 'package:blog_app/Screens/Home/blogList_blogTile.dart';
import 'package:blog_app/Screens/Create%20Page/create_blog.dart';
import 'package:blog_app/Services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/crud.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CrudMethods crudMethods = CrudMethods();
  QuerySnapshot blogsSnapshot;

  // ignore: non_constant_identifier_names

  @override
  void initState() {
    // TODO: implement initState
    crudMethods.getData().then((result) {
      blogsSnapshot = result;
    });
    super.initState();
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
      ),
      body: SingleChildScrollView(
        child: BlogList(),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateBlog1()),
              );
            },
            child: Icon(Icons.add),
          )),
    );
  }
}
