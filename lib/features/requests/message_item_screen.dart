import 'dart:async';
import 'dart:convert';

import 'package:admin_app/bloc/common/input_multiline_limiter_cubit.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/bloc/message/message_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/model/message.dart';

class MessageItemScreen extends StatelessWidget {
  final ChatRooms chatRoom;

  MessageItemScreen(
      {Key key, @required this.chatRoom})
      : assert(chatRoom != null),
        super(key: key);

  final _messageController = TextEditingController();
  final _messageListViewController = ScrollController();

  static navigate(final BuildContext context, final MessageBloc messageBloc,
      final ChatRooms chatRoom) {
    assert(chatRoom != null);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (routeContext) => MessageItemScreen(
                  chatRoom: chatRoom,
                ),
            settings: RouteSettings(name: "messageItem")));
  }

  @override
  Widget build(BuildContext rootContext) {
    final MessageBloc messageBloc = BlocProvider.of<MessageBloc>(rootContext);
    final LineSplitter splitter = LineSplitter();

    return BlocProvider(
      create: (context) => InputMultilineLimiterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${this.chatRoom.name}"),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: BlocBuilder<MessageBloc, MessageState>(
                cubit: messageBloc,
                builder: (context, state) {
                  Timer(
                    Duration(milliseconds: 1),
                    () => _messageListViewController.jumpTo(
                        _messageListViewController.position
                            .minScrollExtent), // was using min because of the reverse
                  );

                  return ListView.builder(
                    reverse: true,
                    controller: _messageListViewController,
                    itemBuilder: (context, index) {
                      final Message message =
                          messageBloc.messagesReversed[index];
                      return _messageContainer(
                          message,
                          index,
                          messageBloc.isOwnerIdMe(ownerId: message.ownerId),
                          index == messageBloc.messages.length - 1);
                    },
                    itemCount: messageBloc.messages.length,
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  );
                },
              )),
              Padding(
                padding: DEFAULT_SPACING,
                child: BlocBuilder<InputMultilineLimiterCubit,
                    InputMultilineLimiterState>(
                  builder: (context, state) {
                    final lines = splitter.convert(state.recordedText);
                    print("lines: $lines");
                    return TextFormField(
                      controller: _messageController,
                      maxLines: lines.length < 3 ? null : 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (text) => context
                          .bloc<InputMultilineLimiterCubit>()
                          .record(text),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              messageBloc.sendMessage(
                                  chatRoomId: chatRoom.id,
                                  message: _messageController.text);
                              _messageController.text = "";
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          labelText: "Reply",
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageContainer(
      Message message, int index, bool owner, bool isMessageEnd) {
    var alignment = TextAlign.left;
    var bottomPadding = 0.0;

    if (owner) {
      alignment = TextAlign.right;
    }

    if (isMessageEnd) {
      bottomPadding = DEFAULT_SPACE_MARGIN;
    }

    return Container(
      padding:
          EdgeInsets.only(top: DEFAULT_SPACE_MARGIN, bottom: bottomPadding),
      child: Row(
        children: [
          if (!owner) ...[
            Icon(
              Icons.account_circle,
              size: 48,
            ),
            Expanded(
              child: Card(
                elevation: 0,
                color: AppColors.orangeLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: DEFAULT_SPACING_TOP_BOTTOM_HALF,
                  child: Text(
                    message.message,
                    textAlign: alignment,
                    style: TextStyle(fontSize: 14.5),
                  ),
                ),
              ),
              flex: 1,
            )
          ] else ...[
            Expanded(
              child: Card(
                elevation: 0,
                color: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: DEFAULT_SPACING_TOP_BOTTOM_HALF,
                  child: Text(
                    message.message,
                    textAlign: alignment,
                    style: TextStyle(fontSize: 14.5),
                  ),
                ),
              ),
              flex: 1,
            ),
            Icon(
              Icons.account_circle,
              size: 48,
            ),
          ],
        ],
      ),
    );
  }
}
