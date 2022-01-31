import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_chatroom.dart';
import 'package:pgpmessanger/classes/firebase/class_fs_chatroommanager.dart';
import 'package:pgpmessanger/classes/widget/class_widget_contactwidget.dart';

class ContactList extends StatelessWidget {
  const ContactList({Key? key}) : super(key: key);

  Future<Widget>? _getContactColumn() async {
    List roomList = await FS_ChatRoomManager().getRoomList();
    List<Widget> contactList = [];
    for (DataChatRoom dataChatRoom in roomList) {
      contactList.add(ContactWidget(
        roomData: dataChatRoom,
      ));
    }
    return Column(children: contactList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getContactColumn(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
