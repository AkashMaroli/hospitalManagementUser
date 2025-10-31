import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/chat_list_bloc/chat_list_bloc_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/chat_list_bloc/chat_list_bloc_state.dart';

import 'package:hospitalmanagementuser/data/services/chat_services.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatServices chatServices;
  StreamSubscription? _chatSubscription;

  ChatListBloc({required this.chatServices}) : super(ChatListLoading()) {
    on<LoadChatList>(_onLoadChatList);
  }

  void _onLoadChatList(LoadChatList event, Emitter<ChatListState> emit) {
    emit(ChatListLoading());
    _chatSubscription?.cancel();
    _chatSubscription = chatServices.getChatRoomsFor(event.userId).listen(
      (chatRooms) {
        emit(ChatListLoaded(chatRooms));
      },
      onError: (error) {
        emit(ChatListError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
