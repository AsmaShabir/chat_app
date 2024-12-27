
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/auth_repo.dart';
import '../resources/components/colors.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class ProfileViewModel with ChangeNotifier{
  final repo= AuthRepository();
  final _auth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  User? _user;
  String? name;
  String? imageUrl;

  Future<void>signup(email,password,name,about,contact,context)async{
    UserCredential? user = (await repo.signUp(email, password, name,about,contact,imageUrl.toString(),context)) as UserCredential;
    if(user==null){
      Utils.snackBar('fill the input fields', context);
    }
    else{
      Navigator.pushNamed(context, routesName.home);
    }

  }

  Future <void> login(emaill,password,context) async{
    UserCredential? user=  await repo.login(emaill, password);
    if(user==null){
      Utils.snackBar('fill the input fields', context);
    }
    else{
      Navigator.pushNamed(context, routesName.home);

    }
  }

Future<void>getImage()async{
    imageUrl=await repo.getImage(ImageSource.gallery);
    log(imageUrl.toString());
    notifyListeners();



}
  Future<void> changePassword(String currentPassword, String newPassword,context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not found');
    }

    final signInMethod = user.providerData?.first.providerId;

    if (signInMethod == 'google.com') {
      Utils.snackBar('Password change not supported for Google sign-in',context);
    } else {
      // Call the AuthRepository function to change the password
      await repo.changePassword(currentPassword, newPassword,context);
      notifyListeners();
    }
  }
  Future<void> deleteAccount(context) async {
    try {
      // Confirm with the user
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Confirm Account Deletion'),
              content: Text(
                  'Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),

                  child: Text('Cancel',style: GoogleFonts.poppins(color: appColors.zincgreen)),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser
                        ?.delete();

                    Navigator.pop(context);

                  },
                  child: Text('Delete',style: GoogleFonts.poppins(color: appColors.zincgreen),),
                ),
              ],
            ),
      );
    } catch (e) {
      print('Error deleting account: $e');
    }
    notifyListeners();
  }

  // fetchData()async{
  //   var data= await fetchDatafromFirebase();
  //   name=data['name'];
  //   imageUrl=data['imageUrl'];
  //
  //
  //
  //   notifyListeners();
  //   print(name.toString());
  // }
  //
  // fetchDatafromFirebase()async{
  //   try{
  //     var fetchedData= await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).get();
  //     print(fetchedData.toString());
  //     return fetchedData;
  //   }
  //   catch(e){
  //     log("User Not Loggedin");
  //   }
  // }



}
