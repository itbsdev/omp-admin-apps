import 'package:admin_app/bloc/message/message_bloc.dart';
import 'package:admin_app/features/reports/rider_screen.dart';
import 'package:admin_app/features/reports/store_screen.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/model/request_view.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final MessageBloc messageBloc = BlocProvider.of<MessageBloc>(rootContext);

    return BlocListener<MessageBloc, MessageState>(
      listener: (listenerContext, state) {
        if (state is ShowLastMessageState) {
          print("last message is: ${state.message}");
        }
      },
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (blocContext, state) {
          return Container(
            child: ListView.separated(
                itemBuilder: (itemContext, index) {
                  final RequestView model = messageBloc.chatRoomViews[index];
                  final ChatRooms room = model.chatRoom;

                  return OpenContainer(
                      tappable: false,
                      closedElevation: 0.0,
                      closedColor: Colors.transparent,
                      closedBuilder: (containerContext, action) {
                        return ListTile(
                          onTap: () {
                            messageBloc.showLastMessage(chatRoom: room);
                            action();
                          },
                          title: Text(room.name),
                          subtitle: Text(room.lastMessage),
                        );
                      },
                      openBuilder: (containerContext, action) {
                        if (room.roomType == RoomType.REQUEST_STORE &&
                            model.store != null)
                          return StoreScreen(store: model.store);
                        else if (room.roomType == RoomType.REQUEST_RIDER &&
                            model.rider != null)
                          return RiderScreen(rider: model.rider);

                        return Container();
                      });
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: messageBloc.chatRoomViews.length),
          );
        },
      ),
    );
  }
}
