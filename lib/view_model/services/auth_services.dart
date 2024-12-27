import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../repository/auth_repo.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class AuthService {
  final repo =AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign-in method

// signOut(context)async{
//   Utils.flushBarErrorMessage("Logging Out...",context);
//   try{
//     await FirebaseAuth.instance.signOut();
//     Navigator.popUntil(context, (route) => route.isFirst);
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginView()));
//     log("Logged out log");
//   }
//   catch(e){
//     // VxToast.show(context, msg: e.toString());
//   }
// }
}