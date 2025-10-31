import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/chat_model.dart';

class ChatServices {
  //!--------Send--A--Chat--Message-----------
  Future<void> sendMessage({
    required ChatMessageModel chatModel,
    required String receiverName,
    // required String receiverPhoto,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // ✅ 1. Generate a unique & consistent chatId
    final sortedIds = [chatModel.senderId, chatModel.receiverId]..sort();
    final chatId = '${sortedIds[0]}_${sortedIds[1]}';

    // ✅ 2. Create message document
    final msgRef =
        firestore
            .collection('chatRooms')
            .doc(chatId)
            .collection('messages')
            .doc();

    batch.set(msgRef, {
      'senderId': chatModel.senderId,
      'receiverId': chatModel.receiverId,
      'text': chatModel.message,
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    });

    // ✅ 3. Create / update chat room document
    final roomRef = firestore.collection('chatRooms').doc(chatId);
    batch.set(roomRef, {
      'chatId': chatId,
      'participants': [chatModel.senderId, chatModel.receiverId],
      'lastMessage': chatModel.message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'receiverId': chatModel.receiverId,
      'receiverName': receiverName,
      // 'receiverPhoto': receiverPhoto,
    }, SetOptions(merge: true));

    // ✅ 4. Commit both writes atomically
    await batch.commit();
  }

  //!-------Get--Messages-------
  Stream<QuerySnapshot> messagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  //!-------ChatList--Of--Already--Messaged--Individuals-------------
  Stream<List<Map<String, dynamic>>> getChatRoomsFor(String uid) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  //!-------Individual--Chat--List--Or--Individual--Previous--Chat--List--------
  Stream<List<QueryDocumentSnapshot>> getChatList(String currentUserId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: currentUserId)
        .orderBy("lastMessageTime", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}
