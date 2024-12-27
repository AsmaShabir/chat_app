

import 'dart:developer';

import 'package:chat_app/resources/components/colors.dart';
import 'package:chat_app/utils/routes/routes_name.dart';
import 'package:chat_app/view_model/chats_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_model/profileCreation_view_model.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime); // e.g., "23 December 2024"
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    final profileModel= Provider.of<ProfileViewModel>(context);
    final chatModel= Provider.of<ChatsViewModel>(context);


    final h= MediaQuery.sizeOf(context).height;
    final w= MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF377078),
        title: Text('Flock',style: GoogleFonts.azeretMono(color: Colors.white),),
        actions: [

          Icon(Icons.camera_alt_outlined),
          SizedBox(width:w*0.03 ,),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, routesName.searchh);
            },
              child: Icon(Icons.search)),
          SizedBox(width:w*0.04 ,),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor:Color(0xFFF377078), // Replace with your app's colors
          unselectedItemColor: Colors.grey,
          items: [
        BottomNavigationBarItem(icon:Icon(Icons.chat,size: 30,),label: 'Chats'),
        BottomNavigationBarItem(icon:Icon(Icons.update,size: 30,),label: 'Updates'),
        BottomNavigationBarItem(icon:InkWell(
          onTap: (){
            Navigator.pushNamed(context, routesName.setting);
          },
            child: Icon(Icons.settings,size: 30,)),label: 'Settings'),
        BottomNavigationBarItem(icon:Icon(Icons.call_sharp,size: 30,),label: 'Calls'),

      ]),
      body: Column(
        children: [
          SizedBox(height: h*0.02,),
      Expanded(
        child: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          stream: chatModel.fetchChats(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat, color: appColors.zincgreen, size: 100),
                    SizedBox(height: 10),
                    Text(
                      'No Messages yet?',
                      style: GoogleFonts.roboto(
                          color: appColors.zincgreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Start conversation with your loved ones!',
                      style: GoogleFonts.roboto(
                          color: appColors.zincgreen,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: appColors.zincgreen,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, routesName.searchh);
                        },
                        child: Text(
                          "Start Conversation",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final chatDocs = chatSnapshot.data!;
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: chatModel.fetchUserDetails(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError) {
                    return Center(
                      child: Text("Error fetching user details: ${userSnapshot.error}"),
                    );
                  } else if (!userSnapshot.hasData) {
                    return Center(child: Text("No user details found"));
                  } else {
                    final userDocs = userSnapshot.data!.docs;
                    final userDetails = {
                      for (var doc in userDocs) doc.id: doc.data()
                    };

                    return ListView.builder(
                      itemCount: chatDocs.length,
                      itemBuilder: (context, index) {
                        final chatDoc = chatDocs[index];
                        final userId = chatDoc['otherUserId'];
                        final userDetail = userDetails[userId];

                        return
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("chats")
                                .doc(chatDoc['ChatRoomId'])
                                .collection("messages")
                                .orderBy("time", descending: true)
                                .limit(1)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return ListTile(title: Text("Error or No Data"));
                              }

                              final lastMessageDoc = snapshot.data!.docs.first;
                              final sentBy = lastMessageDoc['sentBy'];
                              final isCurrentUserSender = sentBy == FirebaseAuth.instance.currentUser!.uid;
                              final displayUserId = isCurrentUserSender ? chatDoc['otherUserId'] : sentBy;
                              final userDetail = userDetails[displayUserId];

                              return ListTile(
                                onTap: () {
                                  if (displayUserId != null) {
                                    chatModel.storeChatData(
                                      otherUserId: displayUserId,
                                      userId: FirebaseAuth.instance.currentUser!.uid,
                                      msg: lastMessageDoc['content'],
                                    );
                                  }
                                  Navigator.pushNamed(
                                    context,
                                    routesName.chatRoom,
                                    arguments: {
                                      'username': userDetail?['name'] ?? 'Unknown User',
                                      'imageUrll': userDetail?['imageUrl'] ?? '',
                                      'uid': displayUserId,
                                      'Chatroomid': chatDoc['ChatRoomId'],
                                      'message': lastMessageDoc['content'],
                                    },
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(userDetail?['imageUrl'] ?? ''),
                                  backgroundColor: Color(0xFFF377078),
                                ),
                                title: Text(
                                  userDetail?['name'] ?? 'Unknown User',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  chatDoc['lastMessage'].toString(),
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.black),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatDate(chatDoc['lastMsgTime']),
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      formatTimestamp (chatDoc['lastMsgTime']),
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 9,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),


      ],
      ),

    );
  }
}
