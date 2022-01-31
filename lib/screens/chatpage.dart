import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:open_file/open_file.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_chatroom.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_userinfo.dart';
import 'package:pgpmessanger/classes/firebase/class_fs_chatroommanager.dart';
import 'package:pgpmessanger/classes/pgp/class_pgpcrypter.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final DataChatRoom roomData;

  const ChatPage({Key? key, required this.roomData}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final types.User _user;

  void _handleMessageTap(context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      id: const Uuid().v4(),
      text: message.text,
    );

    await FS_ChatRoomManager().addMessage(
      widget.roomData,
      textMessage.id,
      textMessage.text,
    );
  }

  Future<void> _loadMessages() async {
    final QuerySnapshot<Object?>? messageList = await FS_ChatRoomManager().getMessages(widget.roomData.roomID!);
    final String uid = _user.id;

    _messages = [...(await PGPCrypter().decryptMessages(uid, messageList))];
  }

  Future<Widget> _chatWidget(QuerySnapshot messageList) async {

    _messages = [...(await PGPCrypter().decryptMessages(_user.id, messageList))];

    return SafeArea(
      bottom: false,
      child: Chat(
        theme: const DarkChatTheme(
          backgroundColor: Colors.black26,
          inputBackgroundColor: Colors.black54,
          primaryColor: Colors.pink,
          secondaryColor: Colors.pinkAccent,
          userAvatarNameColors: [Colors.black87],
        ),
        messages: _messages,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
        showUserNames: true,
      ),
    );
  }

  Future<Widget> _streamWidget() async {
    DataUserInfo myUserInfo = await widget.roomData.myUserInfo;
    _user = types.User(
      id: myUserInfo.uid,
      firstName: await myUserInfo.nickname,
    );
    return StreamBuilder(
      stream: FS_ChatRoomManager().snapShotMessages(widget.roomData.roomID!, _user.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: _chatWidget(snapshot.data),
            builder: (BuildContext context, AsyncSnapshot<dynamic> fs) {
              if (fs.hasData) {
                return fs.data;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomData.roomID!)),
      body: FutureBuilder(
        future: _streamWidget(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
