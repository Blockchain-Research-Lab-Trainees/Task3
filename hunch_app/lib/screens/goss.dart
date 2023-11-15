import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Goss extends StatefulWidget {
  const Goss({super.key});

  @override
  State<Goss> createState() => _GossState();
}

class _GossState extends State<Goss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Start A Goss',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/goss.PNG',
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Oops 😟 Looks like you have no followers yet 💔',
            textAlign: TextAlign.center,
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
              'To chat with hunchkins viaGoss, you need to first start following each other. Start engaging in the comment to gain followers.',
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
            child: Text('Home'),
          )
        ],
      ),
    );
  }
}
