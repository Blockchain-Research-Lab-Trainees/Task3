//Gaurav Singh, Ananya Singhal
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/chat/Chatpage.dart';
import 'package:hunch_app/chat/chat_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hunch_app/services/dbhelper.dart';
import 'package:hunch_app/model/message.dart';

class ChatService extends ChangeNotifier {
  //notify listner when state change
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  void sendMessage(String Remail, String message) async {
    final currentuserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email.toString();
    final time = Timestamp.now();
    Message newMessage = Message(
        receiverId: Remail,
        message: message,
        senderEmail: currentUserEmail,
        senderId: currentuserId,
        timestamp: DateTime.timestamp(),
        date: '',
        imgUrl: '',
        image: '');

    List<String> ids = [currentuserId, Remail];
    ids.sort();
    String room = ids.join("-");
    await _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String uid2, String uid1) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    String room = ids.join("-");
    return _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        // .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

class Chatscreen extends StatefulWidget {
  const Chatscreen(
      {super.key,
      required this.Remail,
      required this.Rid,
      required this.imgUrl,
      this.senderUrl});
  final Remail;
  final imgUrl;
  final Rid;
  final senderUrl;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  String imageUrl = '';
  String? senderUrl;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  @override
  _loadMessages() async {
    List<Message> messages = await DatabaseHelper.instance.getMessages();
    setState(() {
      _messages = messages;
    });
  }

  _sendMessage() async {
    String text = _messageController.text.trim();
    String email = _emailController.text;
    if (text.isNotEmpty) {
      Message message = Message(
        senderId: ' ',
        senderEmail: email,
        receiverId: ' ',
        message: text,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insertMessage(message);
      _loadMessages();
      _messageController.clear();
      _emailController.clear();
    }

    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.Rid, _messageController.text.toString());
    }
    _messageController.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // Fetch the sender's image URL when the widget is initialized
    getImageUrlForUser().then((url) {
      if (url != null) {
        setState(() {
          senderUrl = url;
        });
      } else {
        // Handle the case when the sender's image URL is null
      }
    });
  }

  Future<String?> getImageUrlForUser() async {
    // we use future bcoz it allow us to work with asynchronous
    final em = FirebaseAuth.instance.currentUser!.email
        .toString(); //retrieve email of currenty user use

    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['image'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      // Handle the case when the user's document is not found
      return null;
    }
  }

  final chatService = ChatService();
  final auth = FirebaseAuth.instance;

  // void send() {

  // }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    // Format dateTime as needed, e.g., using DateFormat from intl package
    return DateFormat.Hm().format(dateTime);
    // Example format: 12:34 PM
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.imgUrl),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.Remail.toString().split('@')[0], //user name
                      style: GoogleFonts.ubuntu(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: builderMessage(),
          )),
          input(),
        ],
      ),
    );
  }

  Widget builderMessage() {
    //display message  in chat like format and create ui
    return StreamBuilder(
      stream: chatService.getMessages(widget.Rid, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        print('tolist');

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading messages'),
          );
        }
        return ListView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((e) => messages(e, context)).toList());
      },
    );
  }

  Widget messages(DocumentSnapshot docsss, context) {
    final w = MediaQuery.sizeOf(context).width;
    Map<String, dynamic> data = docsss.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'] as Timestamp;
    print(data['senderId']);
    var align = (data['senderId'] == auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final kk = (data['senderId'] == auth.currentUser!.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: Column(
          children: [
            data['senderId'] == auth.currentUser!.uid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: w * 0.5,
                            decoration: BoxDecoration(
                                // borderRadius: kk
                                //     ? BorderRadius.only(
                                //         bottomLeft: Radius.circular(23),
                                //         topLeft: Radius.circular(23))
                                //     : BorderRadius.only(
                                //         bottomRight: Radius.circular(23),
                                //         topRight: Radius.circular(23)),
                                // color: Color.fromARGB(255, 240, 208, 160),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 244, 209, 163)),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                ),
                                color: Color.fromARGB(255, 244, 219, 186)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 1),
                              child: Column(
                                children: [
                                  Text(
                                    data['message'],
                                    style: GoogleFonts.ubuntu(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                width: w * 0.6,
                                child: Text(formatTimestamp(timestamp),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, left: 5),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(senderUrl.toString()),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 40, right: 5),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(widget.imgUrl),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: w * 0.5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 214, 212, 212)),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  color: align == Alignment.centerLeft
                                      ? Color.fromARGB(255, 201, 237, 219)
                                      : Color.fromARGB(255, 221, 187, 134)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data['message'],
                                  style: GoogleFonts.roboto(fontSize: 20),
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Container(
                              //   alignment: Alignment.centerLeft,

                              //   width: w * 0.7,
                              //   // color: Colors.amber,
                              //   child: Text(
                              //     data['date']
                              //         .toString()
                              //         .split(' ')[1]
                              //         .replaceFirst('-', ':')
                              //         .toString(),
                              //     style: GoogleFonts.poppins(
                              //         fontSize: 10,
                              //         color: Colors.grey.shade600),
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: w * 0.6,
                                child: Text(formatTimestamp(timestamp),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       alignment: Alignment.bottomRight,
            //       width: w*0.6,
            //       child: Text(
            //         formatTimestamp(timestamp),
            //       style: GoogleFonts.poppins(
            //         fontSize: 10,
            //         color: Colors.grey.shade600,

            //       )
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
          suffixIconColor: Colors.black,
          hintText: 'Send Message',
          focusColor: Colors.black,
          hoverColor: Colors.black,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
          suffixIcon: IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send_rounded),
          ),
        ),
      ),
    );
  }
}
