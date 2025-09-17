import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/chat_model.dart';

class ChatServices {
 // get a instence of firebase
 



 //chat stream




 // send a message 
   
 Future<void> sendMessage({
  required ChatMessageModel chatModel
  // required String senderId,
  // required String receiverId,
  // required String text,
  }) async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final msgRef = firestore.collection('chatRooms').doc(chatModel.chatId).collection('messages').doc();
  batch.set(msgRef, {
    'senderId': chatModel.senderId,
    'receiverId': chatModel.receiverId,
    'text': chatModel.message,
    'timestamp': FieldValue.serverTimestamp(),
    'seen': false,
  });

  final roomRef = firestore.collection('chatRooms').doc(chatModel. chatId);
  batch.set(roomRef, {
    'chatId':chatModel. chatId,
    'participants': [chatModel. senderId,chatModel. receiverId],
    'lastMessage':chatModel.message,
    'lastMessageTime': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  await batch.commit();
 }
 
    //get a message
  Stream<QuerySnapshot> messagesStream(String chatId) {
  return FirebaseFirestore.instance
    .collection('chatRooms').doc(chatId)
    .collection('messages')
    .orderBy('timestamp', descending: true)
    .snapshots();
  }


  // get chat list of matching with current patient and with last message,time,
  Stream<List<Map<String, dynamic>>> getChatRoomsFor(String uid) {
  return FirebaseFirestore.instance
    .collection('chatRooms')
    .where('participants', arrayContains: uid)
    .orderBy('lastMessageTime', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // get patient side chat list
  // Stream<List<Map<String, dynamic>>> getPatientChats(String patientId) {
  // return FirebaseFirestore.instance
  //     .collection("chatRooms")
  //     .where("participants", arrayContains: patientId)
  //     .orderBy("lastMessageTime", descending: true)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  //  }

 
}