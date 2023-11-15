import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  // int _currentIndex = 0;
  // final List<Widget> _screens = [
  //   Container(
  //     child: CircularProgressIndicator(),
  //   ),
  //   Container(
  //     color: Colors.amber,
  //   ),
  //   Container(),
  //   Chatpage(),
  //   Container(),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/not.PNG', alignment: Alignment.center),
          SizedBox(
            height: 20,
          ),
          Text(
            'Quiet as a graveyard in here',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
            child: Text(
              'Bring your notifications to life by joining the comment section of our top creators. Follow, vibe and get huncin\' !',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
              primary: Colors.orange[200],
              onPrimary: Colors.black,
              shadowColor: Colors.black,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.black)),
            ),
            child: Text('Show Top Creators'),
          )
        ],
      ),

      // body: _screens[_currentIndex],
      // bottomNavigationBar: CurvedNavigationBar(
      //     backgroundColor: Colors.transparent,
      //     color: const Color.fromARGB(255, 169, 146, 233),
      //     animationDuration: const Duration(milliseconds: 400),
      //     onTap: (index) {
      //       setState(() {
      //         _currentIndex = index;
      //       });
      //     },
      //     items: const [
      //       Icon(
      //         Icons.home,
      //         color: Color.fromARGB(255, 255, 255, 255),
      //       ),
      //       Icon(
      //         Icons.search,
      //         color: Color.fromARGB(255, 255, 255, 255),
      //       ),
      //       Icon(
      //         Icons.add,
      //         color: Color.fromARGB(255, 255, 255, 255),
      //       ),
      //       Icon(
      //         Icons.message,
      //         color: Color.fromRGBO(255, 255, 255, 1),
      //       ),
      //       Icon(
      //         Icons.person,
      //         color: Color.fromARGB(255, 255, 255, 255),
      //       ),
      //     ]),
    );
  }
}
