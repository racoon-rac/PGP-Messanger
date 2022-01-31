import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_chatroom.dart';
import 'package:pgpmessanger/classes/pgp/class_pgpcrypter.dart';
import 'package:pgpmessanger/screens/chatpage.dart';

class ContactWidget extends StatelessWidget {
  final DataChatRoom roomData;

  const ContactWidget({Key? key, required this.roomData}) : super(key: key);

  Future<Widget?> getRoomInfo() async {
    // Something wrong with that showing last message.
    // In this line. Doesn't work.
    // String? encText = await roomData.messageList!.docs.first.get('text')[roomData.myUserInfo!.uid];
    // String? message = await PGPCrypter().decrypt(encText!);
    // print(message);
    return
          Text(await roomData.dstUser!.nickname,
            style: const TextStyle(fontSize: 18, fontFamily: 'Roboto'));
          // Text(message,
          //   style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'))
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  child: const Icon(Icons.account_circle),
                  width: 60,
                  alignment: Alignment.center,
                ),
                FutureBuilder(
                  future: getRoomInfo(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data;
                    } else {
                      return const Text('Loading',
                          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'));
                    }
                  },
                ),
              ]),
              const Icon(Icons.comment),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChatPage(
                        roomData: roomData,
                      )));
        },
      ),
    );
  }
}
