import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../resources/components/Custom_field.dart';
import '../../resources/components/colors.dart';
import '../../utils/utils.dart';
import '../../view_model/profileCreation_view_model.dart';

class ChangePasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    final w= MediaQuery.sizeOf(context).width;
    final h= MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: appColors.zincgreen,

      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
        width: w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... other form fields
                SizedBox(height: h*0.02,),

                Text(" Current password",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w600 )),
                SizedBox(height: h*0.02,),
                customTextFields.defaultTextField(obs: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                    hintText: "Current password:", controller: _currentPasswordController),
                SizedBox(height: h*0.02,),

                Text(" New Password",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w600 )),
                SizedBox(height: h*0.02,),
                customTextFields.defaultTextField(obs: true,
                    validator: (val){
                      if(val==null||val.isEmpty){
                        return ' fill this field';
                      }
                      if( !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(val)){
                        return 'password should contain atleast 1 letter,1special character';
                      }
                      return null;
                    },
                    hintText: "New password:", controller: _newPasswordController),
                SizedBox(height: h*0.02,),

                Text(" Confirm Password",style: TextStyle(color:appColors.zincgreen,fontSize: 15,fontWeight: FontWeight.w600 )),

                SizedBox(height: h*0.02,),
                customTextFields.defaultTextField(obs: true,
                    validator: (val){
                      if(val==null||val.isEmpty){
                        return 'Please confirm your new password';
                      }
                      if( !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(val)){
                        return 'password should contain atleast 1 letter,1special character';
                      }
                      if(_confirmPasswordController.text!=_newPasswordController.text){
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    hintText: "Confirm password:", controller: _confirmPasswordController),
                SizedBox(height: h*0.04,),

                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    color: appColors.zincgreen,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        profileViewModel.changePassword(
                            _currentPasswordController.text,
                            _newPasswordController.text,
                            context
                        );
                        Utils.snackBar('Password changed successfully!',context);
                      }
                    },
                    child: Text('Change Password',style: GoogleFonts.poppins(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}