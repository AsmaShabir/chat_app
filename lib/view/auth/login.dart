
import 'package:chat_app/view/auth/profile_creation.dart';
import 'package:chat_app/view_model/profileCreation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../resources/components/Custom_field.dart';

import '../../resources/components/colors.dart';

import '../../utils/utils.dart';




class loginView extends StatelessWidget {
  loginView({super.key});

  TextEditingController emailController =TextEditingController();

  TextEditingController passController =TextEditingController();

  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profileCreationModel = Provider.of<ProfileViewModel>(context);

    final w= MediaQuery.sizeOf(context).width;
    final h= MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: h,
            width: w,
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Form(
              key: _formKey,
              child: Column( mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h*0.05,),
                  Center(child:Image.asset('assets/images/logo.png',height: 100,)),
                  SizedBox(height: h*0.01,),
                  Text('Login',style: GoogleFonts.roboto(color: appColors.zincgreen,fontSize:18,fontWeight: FontWeight.w600),),
                  SizedBox(height: h*0.03,),

                  Text('Email address',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),


                  SizedBox(height: h*0.01,),
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

                  SizedBox(height: h*0.02,),

                  Text('password',style: GoogleFonts.poppins(color: Colors.black54,fontSize: 12)),

                  SizedBox(height: h*0.01,),
                  customTextFields.defaultTextField(
                      validator: (val){
                        if(val==null||val.isEmpty){
                          return "Kindly enter password";
                        }
                        return null;
                      },
                      obs: true,
                      hintText: "**********", controller: passController),

                  SizedBox(height: h*0.01,),
                  InkWell(
                      onTap: (){

                      },
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Text("Forgot password?",style: TextStyle(decoration: TextDecoration.underline,decorationColor: appColors.zincgreen,color:appColors.zincgreen,fontSize: 13,fontWeight: FontWeight.w400 )))),
                  SizedBox(height: h*0.04,),

                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: ()async{
                        final email=emailController.text.trim().toString();
                        final password=passController.text.trim().toString();
                        final user= await profileCreationModel.login(email, password,context);

                        Utils.snackBar('logged in successfully', context);

                      },
                      child: Container(
                        height: 60,
                        width: w*0.9,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: appColors.zincgreen,borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Text("Log in ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14),)),),
                    ),
                  ),
                  SizedBox(
                    height: h*0.02,
                  ),
                  Row(children: [
                    Expanded(child: Divider()),
                    Text("Don't have an account?",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w400 )),
                    SizedBox(width: 4,),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileCreationView()));
                        },
                        child: Text("Sign up",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w600 ))),
                    Expanded(child: Divider()),
                  ],),


                  SizedBox(height: h*0.15,),


                  Align(
                      alignment: Alignment.center,
                      child: Text('Privacy policy',style: GoogleFonts.poppins(decoration: TextDecoration.underline,decorationColor: appColors.zincgreen,color: appColors.zincgreen,fontSize: 10),)),

                  SizedBox(height: h*0.01,),

                  Align(
                      alignment: Alignment.center,

                      child: Text('Terms of service',style: GoogleFonts.poppins(decoration: TextDecoration.underline,decorationColor: appColors.zincgreen,color: appColors.zincgreen,fontSize: 10),))





                ],),
            ),
          ),
        ),
      ),
    );
  }
}
