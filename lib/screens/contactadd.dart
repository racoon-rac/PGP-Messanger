import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:pgpmessanger/screens/qrscanpage.dart';

class ContactAddPage extends StatefulWidget {
  const ContactAddPage({Key? key}) : super(key: key);

  @override
  _ContactAddPageState createState() => _ContactAddPageState();
}

class _ContactAddPageState extends State<ContactAddPage> {
  late var dstUidCtr = TextEditingController();

  void _alert(String alertText) async {
    await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: Text(alertText),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: dstUidCtr,
              decoration:
                  const InputDecoration(labelText: 'Destination UserID'),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    debugPrint(dstUidCtr.text);
                    await FirebaseFirestore.instance
                        .collection('chat_room')
                        .add({
                      'users': [
                        await MyPGPTable().getUid(),
                        dstUidCtr.text,
                      ],
                    });
                    _alert('Added');
                  } catch (e) {
                    debugPrint(e.toString());
                    _alert('Error');
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontFamily: 'roboto'),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
        final scanCode = Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                const QrScanPage()));
        scanCode.then((value) => setState(() {dstUidCtr.text = value;}));
      },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
