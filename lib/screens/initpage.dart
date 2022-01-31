import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/pgp/class_pgpmanage.dart';
import 'package:pgpmessanger/classes/sqlite/class_sqlitepgpmsg.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _isObscure = true;
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passphraseCtr = TextEditingController();
  TextEditingController nicknameCtr = TextEditingController();

  void alert(String text) async {
    await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  void registration(email, passphrase, nickname) async {
    PGPManager pgpManager =
        PGPManager(nickname: nickname, passphrase: passphrase, email: email);
    await pgpManager.generate();
    try {
      await SqlitePgpMsgDB().drop();
      await pgpManager.save();
      Navigator.pop(context);
    } catch (e) {
      print(e);
      alert('Something wrong.');
      // await pgpManager.deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Column(
        children: [
          TextField(
            controller: nicknameCtr,
            decoration: const InputDecoration(labelText: 'Nickname'),
          ),
          TextField(
            controller: emailCtr,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            obscureText: _isObscure,
            controller: passphraseCtr,
            decoration: InputDecoration(
              labelText: 'Passphrase',
              /* ここからアイコンの設定 */
              suffixIcon: IconButton(
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              /* ここまで */
            ),
          ),
          ElevatedButton(
            child: const Text('Register'),
            onPressed: () {
              registration(emailCtr.text, passphraseCtr.text, nicknameCtr.text);
            },
          ),
        ],
      ),
    );
  }
}
