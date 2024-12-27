

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatRepository{


Future<void>createChat(String otheruserId)async{
  final currentUid=FirebaseAuth.instance.currentUser!.uid;
  if(currentUid==''){
    throw('User not logged in');
  }
  //combine the current user or otheruser id to create a chat id
  final chatId = [currentUid,otheruserId].join('_');
  final chatDoc= FirebaseFirestore.instance.collection('chats').doc(chatId);
  // check if chat exists
  final chatExists = await chatDoc.get().then((doc)=>doc.exists);

  if(!chatExists){
   await chatDoc.set({
     'chatId':chatId,
     'participants':[currentUid,otheruserId],
     'lastMessage':'',
      'timeStamp':FieldValue.serverTimestamp(),
   });
  }
}

Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchChats(){
  final currentUid=FirebaseAuth.instance.currentUser!.uid;
  final chats = FirebaseFirestore.instance.collection('chats').where('participants',arrayContains:currentUid).snapshots().map((snapshot)=>snapshot.docs);
  return chats;

}
Future<QueryDocumentSnapshot<Map<String, dynamic>>?> searchUserByPhoneNum(String contact)async{
  final chat= await FirebaseFirestore.instance.collection('users').where('contact',isEqualTo:contact ).limit(1).get();

  if(chat.docs.isNotEmpty){
    return chat.docs.first;
  }
  else{
    return null;
  }
}
Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserDetails(){
  final currentUid=FirebaseAuth.instance.currentUser!.uid;
  final users =  FirebaseFirestore.instance.collection('users').snapshots();
  return users;

}
String generateChatRoomId(String userId1, String userId2) {
  List<String> sortedIds = [userId1, userId2]..sort();
  String chatRoomId = "${sortedIds[0]}_${sortedIds[1]}";
  print("Generated chat room ID: $chatRoomId");  // Debug log
  return chatRoomId;
}

Future<QuerySnapshot<Map<String, dynamic>>?> fetchAndStoreMessage(String userId, String otherUserId) async {
  String chatRoomId = generateChatRoomId(userId, otherUserId);

  // Get a reference to the messages collection
  final messagesCollection = FirebaseFirestore.instance
      .collection("chats")
      .doc(chatRoomId)
      .collection("messages");

  // Fetch messages ordered by time
  final messagesSnapshot = await messagesCollection.orderBy("time", descending: true).get();

  if (messagesSnapshot.docs.isNotEmpty) {
    // If messages exist, return the fetched data

    return messagesSnapshot;
  } else {
    // If no messages exist, create a new message
   // storeMessages(chatRoomId, otherUserId,newMsg: messagesCollection.doc('lastMessage'));

  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages( String currentUserId, String otherUserId) {
  String? chatRoomId;
  if (chatRoomId == null || chatRoomId.isEmpty) {
    chatRoomId = generateChatRoomId(currentUserId, otherUserId);
  }

  return FirebaseFirestore.instance
      .collection("chats")
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("time", descending: true)
      .snapshots();
}


Future<void> storeMessages(String chatRoomId, String otherUserId, {String newMsg = ""}) async {
  if (newMsg.trim().isEmpty) {
    return; // Avoid storing empty messages
  }

  // Ensure chatRoomId consistency
  chatRoomId = chatRoomId.isEmpty
      ? generateChatRoomId(FirebaseAuth.instance.currentUser!.uid, otherUserId)
      : chatRoomId;

  final chatDocRef = FirebaseFirestore.instance.collection("chats").doc(chatRoomId);
  final chatDocSnapshot = await chatDocRef.get();

  if (!chatDocSnapshot.exists) {
    await chatDocRef.set({
      "participants": [FirebaseAuth.instance.currentUser!.uid, otherUserId],
      "lastMessage": "",
      "lastMsgTime": FieldValue.serverTimestamp(),
    });
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final messageRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .doc(); // Auto-generated ID

    transaction.set(
      messageRef,
      {
        "content": newMsg.trim(),
        "seen": false,
        "time": FieldValue.serverTimestamp(),
        "sentBy": FirebaseAuth.instance.currentUser!.uid,
        'sentTo': otherUserId,
      },
    );

    transaction.update(chatDocRef, {
      "lastMessage": newMsg.trim(),
      "lastMsgTime": FieldValue.serverTimestamp(),
    });
  });
}


storeChatData({
  required String otherUserId,
  required String userId,
   required newMsg
}) async {
  // Generate consistent chatroom ID
  String chatRoomId = generateChatRoomId(userId, otherUserId);

  // Check if chatroom already exists
  DocumentSnapshot chatSnapshot = await FirebaseFirestore.instance
      .collection("chats")
      .doc(chatRoomId)
      .get();

  print("Chatroom exists: ${chatSnapshot.exists}"); // Debug log

  if (!chatSnapshot.exists) {
    // If chatroom doesn't exist, create it
    await FirebaseFirestore.instance.collection("chats").doc(chatRoomId).set({
      "createdOn": DateTime.now(),
      "lastMessage": newMsg,
      'ChatRoomId': chatRoomId,
      "otherUserId": otherUserId,
      "uid": userId,
      'participants': [userId, otherUserId],
      "lastMsgTime": FieldValue.serverTimestamp(),
    });
    FirebaseFirestore.instance.collection("chats").doc(chatRoomId).update({
      "lastMessage":newMsg,
      "lastMsgTime":FieldValue.serverTimestamp(),
    });
    print("Chatroom created: $chatRoomId");
  }
}

}