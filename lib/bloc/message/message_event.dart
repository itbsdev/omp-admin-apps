part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class MessageSendEvent extends MessageEvent {
  final Message message;

  const MessageSendEvent({@required this.message})
      : assert(message != null),
        super();

  @override
  List<Object> get props => [this.message];
}

class MessagesLoadedEvent extends MessageEvent {
  final List<Message> messages;

  const MessagesLoadedEvent({@required this.messages})
      : assert(messages != null),
        super();

  @override
  List<Object> get props => [this.messages];
}

class ChatRoomsLoadedEvent extends MessageEvent {
  final List<ChatRooms> rooms;

  const ChatRoomsLoadedEvent({@required this.rooms})
      : assert(rooms != null),
        super();

  @override
  List<Object> get props => [this.rooms];
}

class LoadMessagesFromDeliveryEvent extends MessageEvent {
  final DeliveryRider deliveryRider;

  const LoadMessagesFromDeliveryEvent({@required this.deliveryRider})
      : assert(deliveryRider != null),
        super();

  @override
  List<Object> get props => [this.deliveryRider];
}

class RetrieveLastMessageEvent extends MessageEvent {
  final ChatRooms chatRoom;

  const RetrieveLastMessageEvent({ @required this.chatRoom }): assert(chatRoom != null), super();

  @override
  List<Object> get props => [this.chatRoom];

}
