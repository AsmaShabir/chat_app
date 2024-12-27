
import 'dart:developer';

import 'package:chat_app/repository/chatRepo.dart';
import 'package:chat_app/resources/components/colors.dart';
import 'package:chat_app/view_model/chats_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
   ChatRoom({required this.username,required this.imageUrll,required this.uid,required this.chatRoomid,required this.message});
   String username;
   String imageUrll;
   String uid;
   String chatRoomid;
   String message;


  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController msgController=TextEditingController();
  String currentUserId= FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final chatViewModel = Provider.of<ChatsViewModel>(context, listen: false);
    chatViewModel.storeChatData(otherUserId: widget.uid, userId: currentUserId, msg:widget.message );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatViewModel.fetchMessages(currentUserId, widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h= MediaQuery.sizeOf(context).height;
    final w= MediaQuery.sizeOf(context).width;

    final chatViewModel = Provider.of<ChatsViewModel>(context);
    final chatRepository chatRepo = chatRepository();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF377078),
        title: Row(
          children: [
            CircleAvatar(radius: 25,backgroundImage: NetworkImage(widget.imageUrll),),
            SizedBox(width: 20,),
            Text(widget.username,style: GoogleFonts.azeretMono(fontWeight: FontWeight.w400,fontSize: 13,color: Colors.white),),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.call,color: Colors.white,size: 30,),
          ),
          SizedBox(width: 7,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.video_call,color: Colors.white,size: 30,),
          ),
        ],
      ),
      body: Column(
         children: [

           Expanded(
             child: Consumer<ChatsViewModel>(
             builder: (context, chatModel, child) {
               final messagesStream = chatViewModel.messagesStream;

               if (messagesStream == null) {
                 return Center(child: CircularProgressIndicator());
               }
               return StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
                   stream: chatViewModel.messagesStream,
                   builder: (context, snapshot) {
                     if (!snapshot.hasData) {
                       return Center(child: Text(
                           'Start Chat with Asma...', style: GoogleFonts
                           .azeretMono(fontWeight: FontWeight.w300,
                           fontSize: 12,
                           color: Color(0xFFF377078)))
                       );
                     }
                     else
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return Center(child: CircularProgressIndicator(),);
                     }
                     else {
                       var data = snapshot.data!.docs;
                       log(data.length.toString());

                       return ListView.builder(reverse: true,
                           itemCount: data.length,
                           itemBuilder: (context, index) {
                             return Column(
                               children: [
                                 Align(
                                   alignment: data[index]['sentBy'] ==
                                       currentUserId
                                       ? Alignment.topRight
                                       : Alignment.topLeft,
                                   child: Container(
                                       margin: EdgeInsets.all(5),
                                       padding: EdgeInsets.all(12),
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.only(
                                             bottomRight: Radius.circular(12),
                                             topLeft: Radius.circular(12)),
                                         color: data[index]['sentBy'] ==
                                             currentUserId
                                             ? appColors.zincgreen
                                             : Colors.green,

                                       ),
                                       child: Text(data[index]['content'].toString(),
                                         style: GoogleFonts.roboto(
                                             color: Colors.white),)),
                                 ),
                               ],
                             );
                           });
                     }
                   });

             }
             ),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
             child: Row(children: [
               InkWell(onTap: ()async{
                 // await controller.storeMessages(widget.otherUserId,widget.chatRoomId,newMsg: controller.msgController.value.text.toString());
                 //controller.msgController.value.clear();
               },child: Icon(Icons.image,color: Color(0xFFF377078) ,size: 35,)
               ),
               SizedBox(width: 5,),

               Expanded(
                 child:  Container(
                     height: 50,
                     decoration: BoxDecoration(
                       border: Border.all(color: Color(0xFFF377078)),
                       borderRadius: BorderRadius.circular(9),
                     ),

                     padding: EdgeInsets.all(5),
                     child: TextField(
                       controller:msgController,
                       //controller.msgController.value,
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: 'Type a message...',
                         hintStyle: GoogleFonts.azeretMono(color: Color(0xFFF377078),fontSize: 12),

                       ),

                     ),
                   ),
                 ),

               SizedBox(width: 7,),
               InkWell(onTap: ()async{
                 // await controller.storeMessages(widget.otherUserId,widget.chatRoomId,newMsg: controller.msgController.value.text.toString());
                 //controller.msgController.value.clear();
               },child: Icon(Icons.mic,color: Color(0xFFF377078) ,size: 30,)
               ),
               SizedBox(width: 5,),
               InkWell(onTap: ()async{
                 log(widget.uid);
                 await chatRepo.storeMessages(widget.chatRoomid,widget.uid,newMsg: msgController.text.toString());
                 msgController.clear();
               },child: Icon(Icons.send,color: Color(0xFFF377078) ,size: 35,)
               ),
             ],),
           )
         ],
      ),
    );
  }
}
