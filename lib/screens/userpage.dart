import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:pgpmessanger/screens/deletecheckpage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<Widget?> userID() async {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Column(
          children: [
            Column(children: [
              Text(
                'UID: ' + await MyPGPTable().getUid(),
                style: const TextStyle(fontSize: 24, fontFamily: 'roboto'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: QrImage(
                  data: await MyPGPTable().getUid(),
                  version: QrVersions.auto,
                  backgroundColor: Colors.pinkAccent,
                  size: 200.0,
                ),
              ),
            ]),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const DeleteCheckPage(),
                  ));
                },
                child: const Text('DELETE THIS USER')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPage'),
      ),
      body: FutureBuilder(
          future: userID(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return Container();
            }
          }),
    );
  }
}
