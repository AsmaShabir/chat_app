
import 'dart:io';

import 'package:chat_app/repository/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import '../../resources/components/Custom_field.dart';
import '../../resources/components/colors.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../view_model/profileCreation_view_model.dart';
import '../../view_model/services/auth_services.dart';
import 'profile_creation.dart';

class ProfileCreationView extends StatefulWidget {
  const ProfileCreationView({super.key});

  @override
  State<ProfileCreationView> createState() => _ProfileCreationViewState();
}

class _ProfileCreationViewState extends State<ProfileCreationView> {
  TextEditingController contactController =TextEditingController();
  TextEditingController nameController =TextEditingController();
  TextEditingController aboutController =TextEditingController();
  TextEditingController passController =TextEditingController();
  TextEditingController emailController =TextEditingController();





  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final AuthRepository authRepo = AuthRepository();

    final h= MediaQuery.sizeOf(context).height;
    final w= MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h*0.1,),
        Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          return InkWell(
            onTap: () async {
             await profileViewModel.getImage();
            },
            child: Center(
              child: Stack(
                children: [
                  profileViewModel.imageUrl.toString().isNotEmpty ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      profileViewModel.imageUrl.toString(),),
                    backgroundColor: Colors.white,
                    radius: 65,
                  ) : CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 65,
                    backgroundImage: AssetImage(
                        'assets/images/profileicon.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 20,
                      child: Icon(Icons.camera_alt, color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

                SizedBox(
                  height: h*0.03,
                ),
                Text('Username',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),
                SizedBox(
                  height: h*0.02,
                ),
                Container(
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextField(

                    controller: nameController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                      prefixIcon: Icon(Icons.perm_identity_sharp,color: Colors.black54,size: 25,),
                      border: InputBorder.none,
                      labelText: "Name",
                      labelStyle: GoogleFonts.poppins(color: Colors.black54,fontSize: 12),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: h*0.02,
                ),
                Text('Email address',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),
                SizedBox(
                  height: h*0.03,
                ),
                Container(
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextField(

                    controller: emailController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                      prefixIcon: Icon(Icons.email_outlined,color: Colors.black54,size: 25,),
                      border: InputBorder.none,
                      hintText: "user@gmail.com",
                      hintStyle: GoogleFonts.poppins(color: Colors.black54,fontSize: 12),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),

                SizedBox(
                  height: h*0.02,
                ),

                SizedBox(
                  height: h*0.02,
                ),
                Text('password',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),

                SizedBox(height: h*0.03,),
                customTextFields.defaultTextField(
                    validator: (val){
                      if(val==null||val.isEmpty){
                        return "Kindly enter password";
                      }
                      return null;
                    },
                    obs: true,
                    hintText: "**********", controller: passController),
                SizedBox(
                  height: h*0.02,
                ),
                Text('phone number',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),
                SizedBox(
                  height: h*0.03,
                ),
                Container(
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: contactController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                      prefixIcon: Icon(Icons.phone,color: Colors.black54,size: 25,),
                      border: InputBorder.none,
                      labelText: "Phone ",
                      labelStyle: GoogleFonts.poppins(color: Colors.black54,fontSize: 12),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),

                SizedBox(height: h*0.04,),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: ()async{

                      final email=emailController.text.trim().toString();
                      final name=nameController.text.trim().toString();
                      final password=passController.text.trim().toString();
                      final about=aboutController.text.trim().toString();
                      final contact=contactController.text.trim().toString();

                     await profileViewModel.signup(email, password,name,about,contact,context);



                    },
                    child: Container(
                      height: 60,
                      width: w*0.9,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color:  Colors.green,borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text("Continue ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14),)),),
                  ),
                ),

                SizedBox(
                  height: h*0.02,
                ),
            Row(children: [
              Expanded(child: Divider()),
              Text("Already have an account?",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w400 )),
              SizedBox(width: 4,),
              InkWell(
                  onTap: (){
                  Navigator.pushNamed(context, routesName.loginn);
                  },
                  child: Text("Login",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w600 ))),
              Expanded(child: Divider()),
            ],),
            SizedBox(
              height: h*0.02,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
