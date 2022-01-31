import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_chatroom.dart';
import 'package:pgpmessanger/classes/firebase/class_fs_chatroommanager.dart';
import 'package:pgpmessanger/classes/firebase/class_fs_usermanager.dart';
import 'package:pgpmessanger/classes/pgp/class_pgpmanage.dart';
import 'package:pgpmessanger/classes/sqlite/class_sqlitepgpmsg.dart';

class DeleteCheckPage extends StatefulWidget {
  const DeleteCheckPage({Key? key}) : super(key: key);

  @override
  _DeleteCheckPageState createState() => _DeleteCheckPageState();
}

class _DeleteCheckPageState extends State<DeleteCheckPage> {
  Future<void> deleteUser() async {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    await FS_ChatRoomManager().deleteAllRooms();
    await FS_UserManager().deleteUser();
    await SqlitePgpMsgDB().drop();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Check'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Are you sure want to delete ?',
                style: TextStyle(fontSize: 24, fontFamily: 'roboto'),
              ),
              const Text(
                "We'll try to delete all of your information including messaging data. "
                "And once you delete a private key, No one can't take back your information.",
                style: TextStyle(fontSize: 16, fontFamily: 'roboto'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await deleteUser();
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 24, fontFamily: 'roboto'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
