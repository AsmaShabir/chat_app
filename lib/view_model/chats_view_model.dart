


import 'package:chat_app/repository/chatRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatsViewModel with ChangeNotifier{
  final repo= chatRepository();

  final _auth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chatList = [];


  fetchAllChats(){
    return _firestore.collection('chats').where('users',arrayContains: _auth.currentUser!.uid).snapshots().asyncMap((querySnapshot){

    });
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserDetails(){
    final chat = repo.fetchUserDetails();
    return chat;
  }

  Future<void> searchUserByPhoneNum(String contact) async {
    final result = await repo.searchUserByPhoneNum(contact);
    if (result != null) {
      chatList = [result];
    } else {
      chatList = [];
    }
    notifyListeners();
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchChats(){
    final chat = repo.fetchChats();
    return chat;
  }

  fetchAndStoreMessage(String userId,String otherUserId){

    final messages =repo.fetchAndStoreMessage(userId,otherUserId);
    return messages;
  }

  // fetchMessage(String chatRoomId){
  //   return FirebaseFirestore.instance.collection("chats").doc(chatRoomId).collection("messages").orderBy("time",descending: true).snapshots();
  // }

 storeChatData({required otherUserId,required userId,required msg}){
    return repo.storeChatData(otherUserId: otherUserId, userId: userId,newMsg: msg);
 }
 // storeMessages(String chatroomId,String otherUserId,{newMsg= ''}){
 //    return repo.storeMessages(chatroomId, otherUserId,newMsg: '');
 //
 // }

    // storeMessages(String chatroomId,String otherUserId, {newMsg=""})async{
  //
  //   // we are creating subcollection because it is difficult for us to fetch large amount of messages from list
  //   // and more important every msg has an id so it would be easy for us if user report about a msg
  //   //** Major thing is we would implement stream builder easily to see changes i.e new msg, msg edit or delete
  //
  //   Future.wait([FirebaseFirestore.instance.collection("chats").doc(chatroomId).collection("messages").doc().set({
  //     "content": newMsg,
  //     "seen":false,
  //     "time":FieldValue.serverTimestamp(),
  //     "sentBy":FirebaseAuth.instance.currentUser!.uid,
  //     'sentTo': otherUserId,
  //
  //   }),
  //
  //
  //     FirebaseFirestore.instance.collection("chats").doc(chatroomId).update({
  //       "lastMessage":newMsg,
  //       "lastMsgTime":FieldValue.serverTimestamp(),
  //     }),
  //   ]);
  // }
  //
  // storeChatData(String otherUserId){
  //   _firestore.collection('chats').doc().set({
  //
  //     "createdOn": DateTime.now(),
  //     "lastMessage": "Tap here to chat",
  //     "otherUserId": otherUserId, // Other participant
  //     "uid": _auth.currentUser!.uid,              // Current user
  //     'users': [_auth.currentUser!.uid, otherUserId], // Array for queries
  //     "lastMsgTime": FieldValue.serverTimestamp(),
  //   });
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>>? messagesStream;

  // Fetch messages and update the stream
  void fetchMessages( String currentUserId, String otherUserId) {
    messagesStream = repo.fetchMessages( currentUserId, otherUserId);
    notifyListeners();
  }
}