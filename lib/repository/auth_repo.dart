



import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../data/network/base_api_service.dart';
import '../data/network/network_api_service.dart';
import '../utils/routes/routes_name.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';
import 'exceptionsRepo.dart';
class AuthRepository{

  BaseApiService apiService =NetworkApiService();
  final _auth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  final contactController =TextEditingController();
  final nameController =TextEditingController();
  final aboutController =TextEditingController();
  final exceptions exception =exceptions();

  //var imageUrl;


  Future<UserCredential?>login(String email,String password)async{
    try{
      final credentials= await _auth.signInWithEmailAndPassword(email: email, password: password);

      return credentials;
    }
    catch(e){
      throw e;
    }
  }
  // Future<dynamic>SignUpApi(dynamic data) async{
  //   try{
  //     dynamic response =await apiService.getPostApiResponse(AppUrl.registerApiEndPoint, data);
  //     return response;
  //   }
  //   catch(e){
  //     throw e;
  //   }
  // }

  Future signUp(String email,String password,String name,String about,String contact,String imgUrl,context)async{
    try{
      final credentials=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credentials.user;

      if(user!=null){
        await _firestore.collection('users').doc(user.uid).set({
          'uid':user.uid,
          'email':user.email,
          'name':name,
          'about':about,
          'imageUrl':imgUrl,
          'contact':contact,
        });
        Navigator.pushNamed(context, routesName.welcome);
      }

    }
    catch(e){
      throw e;
    }

  }
  StoreDataInFireBase()async{
    try{
      var storeData = await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name':nameController.text.toString(),
        'contact':contactController.text.toString(),
        'about':aboutController.text.toString(),
        'imageUrl':'',
      });
    }
    catch(e){
      log('failed to store data');
    }
  }


  Future<void>signOut()async{
    await _auth.signOut();

  }

  // Future<String?> updateImageUrl(File imageFile) async {
  //   try {
  //     // Reference to Firebase Storage
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('profileImages')
  //         .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
  //
  //     // Upload the file to Firebase Storage
  //     final uploadTask = await storageRef.putFile(imageFile);
  //
  //     // Get the download URL
  //    final imageUrl = (await uploadTask.ref.getDownloadURL());
  //
  //     // Update Firestore with the new image URL
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({'imageUrl': imageUrl});
  //     return imageUrl;
  //
  //     print('Image successfully uploaded and Firestore updated.');
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  Future <String?> uploadImagetoCloudinary(File image)async{
    String? imageUrl;
    try {
      // This line creates a stream from the image file to read the image data in chunks.
      var stream = http.ByteStream(image.openRead());
      //The .cast() method ensures the stream is of the correct type
      stream.cast();
      //number of bytes in the image file. This is used to inform the server of the file's size, which helps it manage the upload process.
      var length = await image.length();
      //This line defines the URI endpoint for the Cloudinary upload API.
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/diartjx7f/image/upload");
//Multipart requests are used when you need to send files and form data to a server. They are particularly useful for uploading files because they allow you to send both files and accompanying data (such as text fields) in a single HTTP request.
      var request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = "profileImages"
        ..files.add(http.MultipartFile('file', stream, length,
            filename: image.path.split('/').last));
// request.send() performs the actual HTTP request to upload the file and returns a StreamedResponse object
      var response = await request.send();

      if (response.statusCode == 200) {
        // Optionally, you can process the response further if needed
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        imageUrl = jsonMap['url'];

      } else {
        log("Failed to upload image: ${image.path}");
      }
    } catch (e) {
      log("Error uploading image: $e");

    }
    return imageUrl;
  }


 Future<String?> getImage(ImageSource choice)async{
   File? imageFile;
    final ImagePicker picker = ImagePicker();
    var image=await picker.pickImage(source:choice,imageQuality: 40);
   if(image==null){
     print("no image");

   }
   else{
     imageFile=File(image.path);
     String? imgUrl = await uploadImagetoCloudinary(imageFile!);
     return imgUrl;
   }
  }

  Future<void> changePassword(String currentPassword, String newPassword,context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }

    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );

      await user.updatePassword(newPassword);
    } catch (e) {
      await exception.exceptionLogs(errorType: 'Failed to change password', error: e.toString(), fileName:'AuthRepository');

      Utils.snackBar('Password change failed: $e',context);
    }
  }


// Future<void> saveUserToFirestore({uid,name,email,imageUrl,Activity,goals,healthMetrics,progress,context}) async {
  //   try {
  //     // Get Firestore instance
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //     // Reference to the user's document
  //     DocumentReference userDoc =
  //     firestore.collection('users').doc(uid);
  //
  //     // Check if the user document already exists
  //     final docSnapshot = await userDoc.get();
  //
  //     // If the user document does not exist, create a new one
  //     if (!docSnapshot.exists) {
  //       await userDoc.set({
  //         'name': name,
  //         'email': email,
  //         'imageUrl': imageUrl,
  //         'uid': uid,
  //         'signInMethod': 'google',
  //         'timestamp': FieldValue.serverTimestamp(),
  //         'activity':Activity,
  //         'goals':goals,
  //         'healthMetrics':healthMetrics,
  //         'progress':progress,
  //       });
  //
  //       print('User credentials saved to Firestore');
  //     }
  //   } catch (e) {
  //     print('Error saving user to Firestore: $e');
  //   }
  // }

}