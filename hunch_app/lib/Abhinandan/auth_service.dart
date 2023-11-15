// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hunch_app/consts/firebase_consts.dart';
// import 'package:hunch_app/model/user_model.dart';

// class AuthService extends ChangeNotifier{
//   // inastance of auth
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;



//   CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);



//   //sign user in
//   Future<UserCredential> signInWithEmailAndPassword(
//     String email, String password)
//     async {
//     try{
//       // sign in 
//       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, 
//         password: password,
//         );

//       //set which was being used earleir below, is now being used on the 56th line


//         // add a new document for the user in users collection if it doesn't exist
//         // _firestore.collection('users').doc(userCredential.user!.uid).set({
//         //      'uid': userCredential.user!.uid,
//         //      'email': email,
//         //    }, SetOptions(merge: true));

//       //yaha set directly use krne ki jagah, in line number 56, usermodel(which
//       // contains all the data model btw) has been set to map

//         //For reusability and updation of number of hunches and polls, and
//       // other features, instead of directly setting the uid email,
//       // usermodel se connect krke, map banakr it is being used

//       //using a constant dart file will make it easier for displaying other user's profile
//       //the above mentioned dart file is in the consts directory in lib folder


//       if(userCredential.additionalUserInfo!.isNewUser) {
//         //if user is new, then only set the hunches and polls to 0
//         //else if an existing user is logging in, let it be as it was
//         UserModel userModel = await UserModel(
//             username: userCredential.user!.displayName ?? 'Anonymous',
//             profilePic: userCredential.user!.photoURL ?? '',
//             uid: userCredential.user!.uid,
//             hunches: 0,
//             polls: 0
//         );
//         await _users.doc(userCredential.user!.uid).set(userModel.toMap());
//       }


//       return userCredential;
//     }
//     //catch errors
//     on FirebaseAuthException catch (e){
//       throw Exception(e.code);
//     }
//   }



//    //create new user



//   Future<UserCredential> signUpEmailandPassword(
//     String email, password) async{
//       try{
//         UserCredential userCredential =
//         await _firebaseAuth.createUserWithEmailAndPassword(
//           email: email, 
//           password: password,
//           );

//           // after creating the user , create a new document for the users collection
//            _firestore.collection(FirebaseConstants.usersCollection).doc(userCredential.user!.uid).set({
//              'uid': userCredential.user!.uid,
//              'email': email,
//            });



//           return userCredential;
//       } on FirebaseAuthException catch (e){
//         throw Exception(e.code);
//       }
//       }
//       //sign user out 
//       Future<void> signOut() async{
//         return await FirebaseAuth.instance.signOut();
//       }
//     }
  