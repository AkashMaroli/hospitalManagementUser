import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/services/chat_services.dart';
import 'package:hospitalmanagementuser/presentation/pages/chat/chating/chating_screen.dart';
import 'package:intl/intl.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final ChatServices chatServices = ChatServices();
  final currentuserid = FirebaseAuth.instance.currentUser?.uid;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatServices.getChatRoomsFor(
                currentuserid!,
              ), // patient123
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }

                final chatRooms = snapshot.data!;
                if (chatRooms.isEmpty)
                  return Center(child: Text("No chats yet"));

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    // vertical: 6,
                  ),
                  child: ListView.separated(
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      final room = chatRooms[index];

                      // find the "other" user (doctor in this case)
                      String otherUserId = (room["participants"] as List)
                          .firstWhere((id) => id != currentuserid);

                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            FirebaseFirestore.instance
                                .collection("doctors") // or "doctors"
                                .doc(otherUserId)
                                .get(),
                        builder: (context, userSnap) {
                          if (!userSnap.hasData) {
                            return ListTile(title: Text("Loading..."));
                          }
                          final user =
                              userSnap.data!.data() as Map<String, dynamic>;
                          final String iconName = user["full_name"];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: themeColor,
                              maxRadius: 30,
                              child: Text(
                                iconName[0],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: backgroudColor,
                                ),
                              ),
                            ),
                            title: Text(
                              user["full_name"] ?? "Unknown",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              room["lastMessage"] ?? "No message yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(room["lastMessageTime"] != null
                                      ? DateFormat("hh:mm a").format(
                                          (room["lastMessageTime"] as Timestamp)
                                              .toDate(),
                                        )
                                      : "No time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(room["lastMessageTime"] != null
                                      ? DateFormat("MMM d").format(
                                          (room["lastMessageTime"] as Timestamp)
                                              .toDate(),
                                        )
                                      : "No time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ChatScreen(
                                        chatId: room["chatId"],
                                        receiverId: otherUserId,
                                        receiverName: '${user['full_name']}',
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: .5);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
