import 'package:chat_app/resources/components/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../view_model/profileCreation_view_model.dart';
import 'auth/changePassword.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool checkLoginMethod() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the list of providers linked to the user
      for (var userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          return true;
        } else if (userInfo.providerId == 'password') {
          return false;
        }
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(

        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),

        title: Text("Settings",
            style: GoogleFonts.roboto(
              textStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        backgroundColor: appColors.zincgreen,
        elevation: 0,
      ),
      body: Column(
          children: [

            SizedBox(height: 15,),
            InkWell(
              onTap: (){

              },
              child: ListTile(
                onTap: () {
                  profileViewModel.deleteAccount(context);
                },
                leading:
                CircleAvatar(
                    backgroundColor: appColors.zincgreen,
                    child: Icon(Icons.delete, color: Colors.white,)),

                title: Text("Delete Account",style: GoogleFonts.roboto(color:Colors.black,fontSize:15,fontWeight:FontWeight.w500),),
                subtitle: Text("Take action on your account",style: GoogleFonts.roboto(color:Colors.grey.shade600,fontSize:12),),
                trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 25,),

              ),
            ),
            Divider(thickness: 1,),
            SizedBox(height: 15,),


            checkLoginMethod()?Container(): ListTile(
              onTap: (){
                Navigator.pushNamed(context, routesName.changePass);
              },
              leading:CircleAvatar(
                  backgroundColor:appColors.zincgreen ,
                  child: Icon(Icons.lock,color: Colors.white,)),
              title: Text("Change Password",style: GoogleFonts.roboto(color:Colors.black,fontSize:15,fontWeight:FontWeight.w500),),
              subtitle: Text("change password here",style: GoogleFonts.roboto(color:Colors.grey.shade600,fontSize:12),),
              trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 25,),
            ),

          ]
      ),
    );
  }
}
