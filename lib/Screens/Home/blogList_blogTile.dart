import 'package:blog_app/Screens/Create%20Page/create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        //color: Colors.green,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 22),
          child: Column(
            children: [
              Container(
                //color: Colors.green,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("blogs")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error ${snapshot.hasError}");
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text("Loading....");
                          break;
                        default:
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return BlogsTile(
                                  authorName: snapshot.data.docs[index]
                                      ['authorName'],
                                  description: snapshot.data.docs[index]
                                      ['description'],
                                  imageUrl: snapshot.data.docs[index]
                                      ['imageUrl'],
                                  title: snapshot.data.docs[index]['title'],
                                );
                              });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imageUrl, authorName, title, description;

  BlogsTile(
      {@required this.imageUrl,
      @required this.authorName,
      @required this.title,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
      //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10),

      height: 190,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 190,
              width: MediaQuery.of(context).size.width,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  authorName,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
