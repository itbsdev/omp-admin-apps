import 'dart:async';

import 'package:admin_app/model/request_view.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/repository/rider_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/model/delivery_rider.dart';
import 'package:admin_app/model/message.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/repository/chat_room/chat_room_repository.dart';
import 'package:admin_app/repository/message/message_repository.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;
  final UserRepository userRepository;
  final ChatRoomRepository chatRoomRepository;
  final StoreRepository storeRepository;
  final RiderRepository riderRepository;
  List<RequestView> _chatRoomViews;
  List<Message> _messages;
  List<Message> _messagesReversed;
  User _me;
  ChatRooms _selectedChatRoom;

  MessageBloc(
      {@required this.chatRoomRepository,
      @required this.messageRepository,
      @required this.userRepository,
      @required this.storeRepository,
      @required this.riderRepository})
      : assert(messageRepository != null),
        assert(userRepository != null),
        assert(storeRepository != null),
        assert(chatRoomRepository != null),
        assert(riderRepository != null),
        super(MessageInitialState()) {
    _getChatRooms();
  }

  List<RequestView> get chatRoomViews =>
      _chatRoomViews == null ? [] : _chatRoomViews;

  List<Message> get messages => _messages == null ? [] : _messages;

  List<Message> get messagesReversed =>
      _messagesReversed == null ? [] : _messagesReversed;

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    yield MessageInitialState();

    try {
      if (event is ChatRoomsLoadedEvent) {
        if (_chatRoomViews == null) _chatRoomViews = List();

        _chatRoomViews.clear();
        for (ChatRooms room in event.rooms) {
          Store store;
          Rider rider;

          if (room.roomType == RoomType.REQUEST_STORE) {
            store = await storeRepository.load(id: room.customerId);
          } else if (room.roomType == RoomType.REQUEST_RIDER) {
            rider = await riderRepository.load(id: room.customerId);
          }

          _chatRoomViews
              .add(RequestView(chatRoom: room, store: store, rider: rider));
        }

        yield ChatRoomsLoadedState(rooms: event.rooms);
      } else if (event is MessagesLoadedEvent) {
        if (_messages == null) {
          _messages = List();
          _messagesReversed = List();
        }

        _messages.clear();
        _messagesReversed.clear();
        _messages.addAll(event.messages);
        _messagesReversed.addAll(_messages.reversed.toList());

        if (_selectedChatRoom != null) {
          _selectedChatRoom.read = true;
          await chatRoomRepository.update(datum: _selectedChatRoom);
        }

        yield MessagesLoadedState(messages: event.messages);
      } else if (event is MessageSendEvent) {
        await messageRepository.insert(datum: event.message);

        if (_selectedChatRoom != null) {
          _selectedChatRoom.lastMessage = event.message.message;
          _selectedChatRoom.read = false;
          await chatRoomRepository.update(datum: _selectedChatRoom);
        }

        yield MessageSuccessState();
      } else if (event is LoadMessagesFromDeliveryEvent) {
        final storeId = event.deliveryRider.delivery.riderId;
        final bookerId = event.deliveryRider.delivery.bookerId;

        User customer;

        if (event.deliveryRider.delivery.type == RiderServiceType.ORDER) {
          final store = await storeRepository.load(id: bookerId);
          customer = await userRepository.load(id: store.ownerId);
        } else {
          customer = await userRepository.load(id: bookerId);
        }

        var chatRoom = await chatRoomRepository.loadByCustomer(
            storeId: storeId, customerId: bookerId);

        if (chatRoom == null) {
          final tmpChatRoom = ChatRooms(
              storeId: storeId,
              customerId: bookerId,
              name: "Messages with ${customer.name ?? "customer $bookerId"}");

          final chatRoomId =
              await chatRoomRepository.insert(datum: tmpChatRoom);
          final tmpChatRoomJson = tmpChatRoom.toJson();
          tmpChatRoomJson["id"] = chatRoomId;
          chatRoom = ChatRooms.fromJson(tmpChatRoomJson);
        }

        yield (MessageCustomerDeliveryState(chatRoom: chatRoom));
      } else if (event is RetrieveLastMessageEvent) {
        _selectedChatRoom = event.chatRoom;
        _selectedChatRoom.read = true;
        await chatRoomRepository.update(datum: _selectedChatRoom);
        yield MessageSuccessState(message: "Successfully retrieved last");
        yield ShowLastMessageState(message: _selectedChatRoom.lastMessage);
      }
    } catch (err) {
      print("MessageBloc: err: ${err.toString()}");
      yield MessageErrorState(err: err.toString());
    }
  }

  void showLastMessage({@required ChatRooms chatRoom}) {
    _selectedChatRoom = chatRoom;
    add(RetrieveLastMessageEvent(chatRoom: chatRoom));
  }

  void loadMessages({@required DeliveryRider deliveryRider}) {
    assert(deliveryRider != null);

    add(LoadMessagesFromDeliveryEvent(deliveryRider: deliveryRider));
  }

  void sendMessage(
      {@required String chatRoomId, @required String message}) async {
    final user = await userRepository.getLoggedInUser();
    final Message msg =
        Message(message: message, ownerId: user.id, chatRoomId: chatRoomId);
    add(MessageSendEvent(message: msg));
  }

  bool isOwnerIdMe({String ownerId}) {
    assert(ownerId != null);

    if (_me == null) return false;

    return _me.id == ownerId;
  }

  void _getChatRooms() async {
    chatRoomRepository.loadByCompany(companyId: "admin").listen((event) {
      add(ChatRoomsLoadedEvent(rooms: event));
    });
  }
}
