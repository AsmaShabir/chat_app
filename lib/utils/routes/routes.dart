

import 'package:chat_app/utils/routes/routes_name.dart';
import 'package:chat_app/view/auth/changePassword.dart';
import 'package:chat_app/view/auth/login.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/settings.dart';
import 'package:chat_app/view/welcome_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/auth/profile_creation.dart';
import '../../view/chat_room.dart';
import '../../view/search.dart';
import '../../view/splash_view.dart';


class routes{
  static Route<dynamic>generateRoute(RouteSettings settings){
        final args = settings.arguments as Map<String, dynamic>?;
    switch(settings.name){
      case routesName.splash:
        return MaterialPageRoute(builder: (BuildContext context)=>SplashView());
      case routesName.profile:
        return MaterialPageRoute(builder: (BuildContext context)=>ProfileCreationView());

      case routesName.home:
        return MaterialPageRoute(builder: (BuildContext context)=>homeScreen());
      case routesName.welcome:
        return MaterialPageRoute(builder: (BuildContext context)=>welcomeView());
      case routesName.chatRoom:
        return MaterialPageRoute(builder: (BuildContext context)=>ChatRoom(username: args?['username']??'', imageUrll: args?['imageUrll']??'', uid: args?['uid']??'', chatRoomid: args?['chatRoomid']??'',message: args?['lastMessage']??'',));
      case routesName.changePass:
        return MaterialPageRoute(builder: (BuildContext context)=>ChangePasswordScreen());
      case routesName.loginn:
        return MaterialPageRoute(builder: (BuildContext context)=>loginView());
      case routesName.searchh:
        return MaterialPageRoute(builder: (BuildContext context)=>SearchView(message: args?['lastMessage']??'',));
      case routesName.setting:
        return MaterialPageRoute(builder: (BuildContext context)=>SettingsScreen());
      // case routesName.goals:
      // //  return MaterialPageRoute(builder: (BuildContext context)=>GoalsCard());
      // case routesName.progress:
      //  // return MaterialPageRoute(builder: (BuildContext context)=>ProgressVisualization());
      // case routesName.details:
      //  // return MaterialPageRoute(builder: (BuildContext context)=>Details());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }


  }
}