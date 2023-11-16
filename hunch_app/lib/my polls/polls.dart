//Gaurav Singh/euclid
import 'package:flutter/material.dart';
import 'package:hunch_app/my%20polls/createpoll.dart';

class MyPoll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(207, 255, 255, 255),

         //backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        //shadowColor: Colors.black,
        title: const Text('ᴘᴏʟʟꜱ' , style: TextStyle(
          color: const Color.fromARGB(255, 169, 146, 233),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),),
        
      ),
      body: PollList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 169, 146, 233),
        
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePollPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
