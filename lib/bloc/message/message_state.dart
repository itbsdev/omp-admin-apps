part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitialState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageSuccessState extends MessageState {
  final String message;

  const MessageSuccessState({this.message}): super();

  @override
  List<Object> get props => [];
}

class MessageErrorState extends MessageState {
  final String err;

  const MessageErrorState({this.err}): super();

  @override
  List<Object> get props => [this.err];
}

class MessagesLoadedState extends MessageState {
  final List<Message> messages;

  const MessagesLoadedState({@required this.messages}): assert(messages != null), super();

  @override
  List<Object> get props => [this.messages];

}

class ChatRoomsLoadedState extends MessageState {
  final List<ChatRooms> rooms;

  const ChatRoomsLoadedState({@required this.rooms}): assert(rooms != null), super();

  @override
  List<Object> get props => [this.rooms];
}

class MessageCustomerDeliveryState extends MessageState {
  final ChatRooms chatRoom;

  const MessageCustomerDeliveryState({ @required this.chatRoom }): assert(chatRoom != null), super();

  @override
  List<Object> get props => [this.chatRoom, generateId()];
}

class ShowLastMessageState extends MessageState {
  final String message;

  const ShowLastMessageState({ @required this.message }): assert(message != null), super();


  @override
  List<Object> get props => [this.message];

}
