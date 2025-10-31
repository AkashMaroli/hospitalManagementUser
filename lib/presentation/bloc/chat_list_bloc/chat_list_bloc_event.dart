import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatList extends ChatListEvent {
  final String userId;
  const LoadChatList(this.userId);

  @override
  List<Object?> get props => [userId];
}
