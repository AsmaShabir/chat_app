

import 'package:flutter/cupertino.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_model.dart';

class UserViewModel with ChangeNotifier{

  Future<bool>saveUser(AuthModel user)async{
    final SharedPreferences sp =await SharedPreferences.getInstance();
    sp.setString('uid', user.uid.toString());
    notifyListeners();
    return true;
  }

  Future<AuthModel>getUser()async{
    final SharedPreferences sp =await SharedPreferences.getInstance();
    final String? uid =sp.getString('uid');
    final String? email =sp.getString('email');


    return AuthModel(uid:uid.toString(), email:email.toString() );
  }
  Future<bool>remove()async{
    final SharedPreferences sp =await SharedPreferences.getInstance();
    sp.remove('uid');
    return true;

  }
}