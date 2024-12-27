//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// import '../../utils/routes/routes_name.dart';
// import '../../utils/utils.dart';
// import '../../view_model/profileCreation_view_model.dart';
//
// class signUpView extends StatefulWidget {
//   const signUpView({super.key});
//
//   @override
//   State<signUpView> createState() => _signUpViewState();
// }
//
// class _signUpViewState extends State<signUpView> {
//   TextEditingController emailController =TextEditingController();
//   TextEditingController nameController =TextEditingController();
//   TextEditingController passController =TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final authViewModel = Provider.of<AuthViewModel>(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//                 height: 500,
//                 width:double.infinity ,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(70, 100))
//                 ),
//                 child:     Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/images/logo.png',height: 90,),
//                           //Text('FitTrack',style: GoogleFonts.azeretMono(color: Color(0xFFF1f305c),fontWeight: FontWeight.bold),),
//
//                           SizedBox(height: 15,),
//                           Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Color(0xFFF377078)),
//                                 borderRadius: BorderRadius.circular(30)
//                             ),
//                             child: TextField(
//                               controller: nameController,
//                               decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.person,color:Color(0xFFF377078) ,),
//                                   labelText: 'Username',
//                                   labelStyle: GoogleFonts.azeretMono(color:Color(0xFFF377078),fontSize: 12 ),
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   )
//
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 15,),
//                           Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Color(0xFFF377078)),
//                                 borderRadius: BorderRadius.circular(30)
//                             ),
//                             child: TextField(
//                               controller: emailController,
//                               decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.email,color:Color(0xFFF377078) ,),
//                                   labelText: 'Email',
//                                   labelStyle: GoogleFonts.azeretMono(color:Color(0xFFF377078),fontSize: 12 ),
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   )
//
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10,),
//                           Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Color(0xFFF377078)),
//                                 borderRadius: BorderRadius.circular(30)
//                             ),
//                             child: TextField(
//                               controller: passController,
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.lock,color:Color(0xFFF377078) ,),
//                                   labelText: 'Password',
//                                   labelStyle: GoogleFonts.azeretMono(color:Color(0xFFF377078),fontSize: 12 ),
//
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   )
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 15,),
//                           Container(
//                             height: 40,
//                             child: MaterialButton(
//                                 color: Color(0xFFF377078),
//
//                                 onPressed: ()async{
//                                   final email=emailController.text.trim().toString();
//                                   final name=nameController.text.trim().toString();
//                                   final password=passController.text.trim().toString();
//                                   final user= await authViewModel.signup(email, password,name,context);
//
//                                   Navigator.pushNamed(context, routesName.welcome);
//                                   Utils.flushBarErrorMessage('Account created successfully!', context);
//
//
//
//
//
//                                 },
//                                 child: Text('Sign up',style: GoogleFonts.azeretMono(color: Colors.white),),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//
//                                 )
//                             ),
//                           ),
//
//                         ]
//                     )
//                 )
//             ),
//
//             Container(height: 356.7,
//               color: Colors.white ,
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Color(0xFFF377078),
//                     borderRadius: BorderRadius.only(topRight: Radius.circular(100),topLeft: Radius.circular(100))),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment:  CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 15,),
//                     TextButton(
//                       onPressed: (){
//                         Navigator.pushNamed(context, routesName.signup);
//
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // CircleAvatar(
//                           //     backgroundColor:Colors.white,
//                           //     child: Image.asset('assets/images/google.png',height: 20,)),
//                           SizedBox(width: 4,),
//                           Text('Signup with GOOGLE',style: GoogleFonts.azeretMono(decoration: TextDecoration.underline,decorationColor:Colors.white ,color: Colors.white,fontSize: 12,),),
//                         ],
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: (){
//                         Navigator.pushNamed(context, routesName.login);
//
//                       },
//                       child: Text("Already have an account? Login",style: GoogleFonts.azeretMono(decoration: TextDecoration.underline,decorationColor:Colors.white ,color: Colors.white,fontSize: 12,),),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             //   TextField(
//             //     controller: nameController,
//             //     decoration: InputDecoration(
//             //       labelText: 'User Name',
//             //     ),
//             //   ),
//             // SizedBox(height: 10,),
//             // TextField(
//             //   controller: emailController,
//             //   decoration: InputDecoration(
//             //     labelText: 'Email',
//             //   ),
//             // ),
//             // SizedBox(height: 10,),
//             // TextField(
//             //   controller: passController,
//             //   obscureText: true,
//             //   decoration: InputDecoration(
//             //     labelText: 'Password',
//             //   ),
//             // ),
//             // SizedBox(height: 10,),
//             // MaterialButton(
//             //     onPressed: ()async{
//             //       final email=emailController.text.trim().toString();
//             //       final name=nameController.text.trim().toString();
//             //       final password=passController.text.trim().toString();
//             //       // if(isLogin){
//             //       //   final user= await authViewModel.login(email, password);
//             //       //   if(user!=null){
//             //       //     print('Sign up successful');
//             //       //     routesName.home;
//             //       //   }
//             //       //   else{
//             //       //
//             //       //     Utils.flushBarErrorMessage('invalid Input', context);
//             //       //   }
//             //       // }
//             //         final user= await authViewModel.signUp(email, password,name);
//             //         if(user!=null){
//             //           Navigator.pushNamed(context, routesName.home);
//             //           Utils.flushBarErrorMessage('Logged in Successfully', context);
//             //
//             //         }
//             //         else{
//             //           Utils.flushBarErrorMessage('fill all the fields', context);
//             //         }
//             //
//             //     },
//             //   child: Text('Sign Up'),
//             // ),
//             // SizedBox(height: 15,),
//             // TextButton(
//             //     onPressed: (){
//             //       Navigator.pushNamed(context, routesName.login);
//             //
//             //     },
//             //     child: Text("Don't have an account? Sign up"),
//             // )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
