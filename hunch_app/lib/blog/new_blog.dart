// Gaurav

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/blog/add_post.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Add Post', style: TextStyle(color: Colors.black),),
      //   centerTitle: true,
      //   actions: [
      //     InkWell(
      //       onTap: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => AddPostScreen()));
      //       },
      //       child: Icon(Icons.add_rounded, color: Colors.black,),
      //     ),
      //     SizedBox(
      //       width: 20,
      //     )
      //   ],

      //    flexibleSpace: Container(
      //           decoration: const BoxDecoration(
      //               gradient: LinearGradient(
      //                   begin: Alignment.centerLeft,
      //                   end: Alignment.bottomCenter,
      //                   colors: <Color>[

      //               ])),
      //         ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 184, 102, 236),
                        Color.fromARGB(255, 140, 233, 244)
                      ])),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Add Posts',
                      style: TextStyle(fontSize: 24),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPostScreen()));
                        },
                        child: Image.asset(
                          "assets/images/icon.png",
                          height: 60,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Search with blog title',
                labelText: " Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.black54,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onChanged: (String value) {
                setState(() {
                  search = value;
                });
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String tempTitle =
                      (snapshot.value as Map<dynamic, dynamic>?)?['pTitle']
                              ?.toString() ??
                          'No Title';

                  if (searchController.text.isEmpty ||
                      tempTitle
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 226, 226, 226),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                placeholder: 'assets/images/login.jpeg',
                                image: (snapshot.value
                                        as Map<dynamic, dynamic>?)?['pImage'] ??
                                    'default_placeholder_image_url',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                (snapshot.value as Map<dynamic, dynamic>?)?[
                                            'pTitle']
                                        ?.toString() ??
                                    'No Title',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                (snapshot.value as Map<dynamic, dynamic>?)?[
                                            'pDescription']
                                        ?.toString() ??
                                    'No Description',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
