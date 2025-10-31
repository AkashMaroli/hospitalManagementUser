import 'package:equatable/equatable.dart';

class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<Map<String, dynamic>> chatRooms;
  const ChatListLoaded(this.chatRooms);
  @override
  List<Object?> get props => [chatRooms];
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);
  @override
  List<Object?> get props => [message];
}
