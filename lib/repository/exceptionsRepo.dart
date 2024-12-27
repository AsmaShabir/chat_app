
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/app_exceptions.dart';


class exceptions{
  final _firebase =FirebaseFirestore.instance.collection('exceptions');

  exceptionLogs({required String errorType,required String error,required fileName})async{
    Map<String,dynamic> data={
      'errorType':errorType,
      'fileName':fileName,
      'error':error,
      'uid':FirebaseAuth.instance.currentUser?.uid??'User not registered',
      'time':DateTime.now(),
    };

    try{
      await _firebase.add(data);
    }
    catch(e){
      throw storeDataException('Failed to save data');
    }
  }
}