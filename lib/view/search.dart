
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../resources/components/colors.dart';
import '../utils/routes/routes_name.dart';
import '../view_model/chats_view_model.dart';
import 'auth/login.dart';

class SearchView extends StatefulWidget {
   SearchView({required this.message});
   String message;

  @override
  State<SearchView> createState() => _SearchViewState();
}
class _SearchViewState extends State<SearchView> {
  TextEditingController searchController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatModel= Provider.of<ChatsViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new,size: 20,color: appColors.zincgreen,)),
                  SizedBox(width: 20,),

                  Text('Search',style: GoogleFonts.roboto(
                      color: appColors.zincgreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 20)),
                  SizedBox(height: 10,),


                ],
              ),


              SizedBox(height: 30,),
              Row(
                children: [
                  Flexible(
                    child: Container(
                        height: 48,  // Set height to match TextField
                        decoration: BoxDecoration(

                          border: Border.all(color:appColors.zincgreen),
                          borderRadius: BorderRadius.circular(35),),
                        child: InkWell(
                          onTap: () {

                          },
                            child: TextField(
                          controller: searchController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                            prefixIcon: Icon(Icons.search,color: appColors.zincgreen,size: 25,),
                            border: InputBorder.none,
                            hintText: "Search Chat",
                            hintStyle: GoogleFonts.poppins(color: appColors.zincgreen,fontSize: 12),
                          ),
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        ),),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MaterialButton(onPressed: (){

                      chatModel.searchUserByPhoneNum(searchController.text);
                    },
                      height: 40,
                      minWidth: 20,
                      color: appColors.zincgreen,
                      child: Icon(Icons.search,color: Colors.white,),

                    ),
                  )
                ],
              ),

              SizedBox(height: 20,),

              Expanded(
                child: Consumer<ChatsViewModel>(
                  builder: (context, chatModel, child) {
                    if (chatModel.chatList.isEmpty) {
                      return Center(
                        child: Text(
                          'No chats Available!',
                          style: GoogleFonts.roboto(
                            color: appColors.zincgreen,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: chatModel.chatList.length,
                      itemBuilder: (context, index) {
                        final userData = chatModel.chatList[index].data();

                        return ListTile(
                          onTap: () {
                            FirebaseAuth.instance.authStateChanges().listen((user) {
                              if (user == null && mounted) {
                                Navigator.pushNamed(context, routesName.loginn);
                              } else {
                                if (userData['uid'] != null  ) {
                                  log(userData['uid']);
                                  chatModel.storeChatData(
                                    otherUserId: userData['uid'],
                                    userId: FirebaseAuth.instance.currentUser!.uid, msg:widget.message ,
                                  );
                                  Navigator.pushNamed(context, routesName.chatRoom, arguments: {
                                    'username': userData['name'],
                                    'imageUrll': userData['imageUrl'],
                                    'uid':userData['uid'],
                                    'chatRoomid':userData['chatRoomId']
                                  });
                                }

                              }
                            });
                          },
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(userData['imageUrl']),
                            backgroundColor: const Color(0xFFF377078),
                          ),
                          title: Text(
                            userData['name'] ?? 'Unknown User',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            userData['contact'] ?? 'No contact info',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            '12:30 am',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),


            ]
    ),
      )
      )
    );
  }
}
