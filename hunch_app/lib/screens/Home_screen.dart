import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/blog/add_post.dart';
import 'package:hunch_app/blog/new_blog.dart';
import 'package:hunch_app/chat/Chatpage.dart';
import 'package:hunch_app/my%20polls/polls.dart';
import 'package:hunch_app/screens/LoginPage.dart';
import 'package:hunch_app/auth/auth_service.dart';
import 'package:hunch_app/chat/chat_page.dart';
import 'package:hunch_app/users.dart/userPage.dart';
import 'package:hunch_app/users.dart/user_service.dart';
import 'package:hunch_app/screens/goss.dart';
import 'package:hunch_app/screens/notification.dart';

// Define the MenuAction enum here
enum MenuAction {
  signUserOut,
  // Add more menu actions if needed
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.inindex}) : super(key: key);
  final int? inindex;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void initState() {
    super.initState();
    _currentIndex = widget.inindex ?? 0;
    _fetchUserData = _fetch();
  }

  final List<Widget> _screens = [
    Goss(),
    MyPoll(),
    Message(),
    Chatpage(),
    UserPage(),
  ];

  late String myEmail;
  late String username;
  late String imageUrl;
  late Future<void> _fetchUserData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Build the widget tree with the fetched data
          return _buildWidgetTree();
        } else {
          // Show a loading indicator while waiting for data
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildWidgetTree() {
    return WillPopScope(
      onWillPop: () async {
        return await showExitConfirmationDialog(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.7],
            colors: <Color>[
              Colors.white,
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: [
              PopupMenuButton<MenuAction>(
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.signUserOut:
                      final shouldLogout = await showSignOutDialog(context);

                      if (shouldLogout) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<MenuAction>>[
                    PopupMenuItem<MenuAction>(
                      child: Text('Sign Out'),
                      value: MenuAction.signUserOut,
                    ),
                  ];
                },
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Notif()));
                  },
                  icon: Icon(Icons.notifications)),
            ],
            title: RichText(
              text: TextSpan(
                text: "H",
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 224, 2, 2),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "unch App",
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: UserAccountsDrawerHeader(
                    accountName: Text(username),
                    accountEmail: Text(' $myEmail'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('$imageUrl'),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account"),
                  subtitle: Text("Personal"),
                  trailing: Icon(Icons.edit),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account"),
                  subtitle: Text("Personal"),
                  trailing: Icon(Icons.share),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account"),
                  subtitle: Text("Personal"),
                  trailing: Icon(Icons.shape_line_rounded),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Signout"),
                  subtitle: Text("Signout from here"),
                  trailing: Icon(Icons.edit),
                ),
              ],
            ),
          ),
          body: _screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 169, 146, 233),
            animationDuration: const Duration(milliseconds: 400),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              Icon(
                Icons.home,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Icon(
                Icons.search,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Icon(
                Icons.message,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              Icon(
                Icons.person,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists) {
        myEmail = userDoc.data()?['email'] ?? '';
        username = userDoc.data()?['username'] ?? "";
        imageUrl =
            userDoc.data()?['image'] ?? ''; // Get the image URL from Firestore
        print(myEmail);
        final usernameFromFirestore = userDoc.data()?['username'];
        print(
            'Username stored in Firestore: $usernameFromFirestore'); // Print the username
      }
    }
  }
}

Future<bool> showSignOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> showExitConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}


// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hunch_app/blog/add_post.dart';
// import 'package:hunch_app/blog/new_blog.dart';
// import 'package:hunch_app/chat/Chatpage.dart';
// import 'package:hunch_app/my%20polls/polls.dart';
// import 'package:hunch_app/screens/LoginPage.dart';
// import 'package:hunch_app/auth/auth_service.dart';
// import 'package:hunch_app/chat/chat_page.dart';
// import 'package:hunch_app/users.dart/userPage.dart';
// import 'package:hunch_app/users.dart/user_service.dart';
// import 'package:provider/provider.dart';
// import 'package:hunch_app/screens/notification.dart';
// import 'package:hunch_app/screens/goss.dart';

// // Define the MenuAction enum here
// enum MenuAction {
//   signUserOut,
//   // Add more menu actions if needed
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key, this.inindex}) : super(key: key);
//   final int? inindex;
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;

//   void initState() {
//     super.initState();
//     _currentIndex = widget.inindex ?? 0;
//   }

//   final List<Widget> _screens = [
//     Goss(),
//     MyPoll(),
//     Message(),
//     Chatpage(),
//     UserPage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           return await showExitConfirmationDialog(context);
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: [
//                 0.4,
//                 0.7
//               ],
//                   colors: <Color>[
//                 Colors.white,
//                 Color.fromARGB(255, 255, 255, 255),
//               ])),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               actions: [
//                 PopupMenuButton<MenuAction>(
//                   onSelected: (value) async {
//                     switch (value) {
//                       case MenuAction.signUserOut:
//                         final shouldLogout = await showSignOutDialog(context);

//                         if (shouldLogout) {
//                           await FirebaseAuth.instance.signOut();
//                           Navigator.pushReplacement(context,
//                               MaterialPageRoute(builder: (context) => Login()));
//                         }
//                     }
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return <PopupMenuEntry<MenuAction>>[
//                       PopupMenuItem<MenuAction>(
//                           child: Text('signout'),
//                           value: MenuAction.signUserOut),
//                     ];
//                   },
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Notif()));
//                     },
//                     icon: Icon(Icons.notifications)),
//               ],
//               title: RichText(
//                   text: TextSpan(
//                       text: "H",
//                       style: GoogleFonts.ubuntu(
//                         textStyle: const TextStyle(
//                           color: Color.fromARGB(255, 224, 2, 2),
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       children: <TextSpan>[
//                     TextSpan(
//                       text: "unch App",
//                       style: GoogleFonts.ubuntu(
//                         textStyle: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black),
//                       ),
//                     ),
//                   ])),
//             ),
//             drawer: Drawer(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: const <Widget>[
//                   DrawerHeader(
//                       decoration: BoxDecoration(color: Colors.blue),
//                       child: UserAccountsDrawerHeader(
//                         accountName: Text("Gaurav"),
//                         accountEmail: Text("gaurav2211028@akgec.ac.in"),
//                         currentAccountPicture: CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/home.jpg'),
//                         ),
//                       )),
//                   ListTile(
//                     leading: Icon(Icons.person),
//                     title: Text("Account"),
//                     subtitle: Text("Personal"),
//                     trailing: Icon(Icons.edit),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.person),
//                     title: Text("Account"),
//                     subtitle: Text("Personal"),
//                     trailing: Icon(Icons.poll_outlined),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.person),
//                     title: Text("Account"),
//                     subtitle: Text("Personal"),
//                     trailing: Icon(Icons.shape_line_rounded),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.person),
//                     title: Text("Signout"),
//                     subtitle: Text("Signout from here"),
//                     trailing: Icon(Icons.edit),
//                   ),
//                 ],
//               ),
//             ),
//             body: _screens[_currentIndex],
//             bottomNavigationBar: CurvedNavigationBar(
//                 backgroundColor: Colors.transparent,
//                 color: const Color.fromARGB(255, 169, 146, 233),
//                 animationDuration: const Duration(milliseconds: 400),
//                 onTap: (index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 items: const [
//                   Icon(
//                     Icons.home,
//                     color: Color.fromARGB(255, 255, 255, 255),
//                   ),
//                   Icon(
//                     Icons.poll_outlined,
//                     color: Color.fromARGB(255, 255, 255, 255),
//                   ),
//                   Icon(
//                     Icons.add,
//                     color: Color.fromARGB(255, 255, 255, 255),
//                   ),
//                   Icon(
//                     Icons.message,
//                     color: Color.fromRGBO(255, 255, 255, 1),
//                   ),
//                   Icon(
//                     Icons.person,
//                     color: Color.fromARGB(255, 255, 255, 255),
//                   ),
//                 ]),
//           ),
//         ));
//   }
// }

// Future<bool> showSignOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign out'),
//         content: const Text('Are you you you want to Signout?'),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel')),
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Signout'))
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }

// Future<bool> showExitConfirmationDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Exit App'),
//         content: const Text('Do you want to exit the app?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
