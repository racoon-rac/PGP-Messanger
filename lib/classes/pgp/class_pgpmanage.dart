import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openpgp/openpgp.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_mypgp.dart';
import 'package:pgpmessanger/classes/firebase/class_fs_usermanager.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:pgpmessanger/classes/sqlite/class_sqlitepgpmsg.dart';

class PGPManager {
  String? uid;
  String? nickname;
  String? email;
  String? passphrase;
  KeyPair? keyPair;

  CollectionReference users =
      FirebaseFirestore.instance.collection('user_info');

  PGPManager({
    this.uid,
    this.nickname,
    this.email,
    this.passphrase,
    this.keyPair,
  });

  Future<void> generate({
    String? nickname,
    String? email,
    String? passphrase,
  }) async {
    nickname ??= this.nickname;
    email ??= this.email;
    passphrase ??= this.passphrase;
    KeyOptions keyOptions = KeyOptions()..rsaBits = 1024;
    keyPair = await OpenPGP.generate(
        options: Options()
          ..name = nickname!
          ..email = email!
          ..passphrase = passphrase!
          ..keyOptions = keyOptions);
  }

  Future<void> deleteAll() async => MyPGPTable().delete();

  Future<void> save2SQLite({
    String? nickname,
    String? email,
    String? passphrase,
    KeyPair? keyPair,
  }) async {
    nickname ??= this.nickname;
    email ??= this.email;
    passphrase ??= this.passphrase;
    keyPair ??= this.keyPair;
    uid = await FS_UserManager().getUid(keyPair!.publicKey);
    print(uid);
    await MyPGPTable().saveMyKey(DataMyPGPTable(
      uid: uid,
      nickname: nickname!,
      email: email!,
      passphrase: passphrase!,
      pubkey: keyPair.publicKey,
      prvkey: keyPair.privateKey,
    ));
  }

  Future<void> save2Firestore({
    String? nickname,
    String? pubkey,
  }) async {
    nickname ??= this.nickname;
    pubkey ??= (keyPair!.publicKey);
    await users.add({
      'nickname': nickname!,
      'pubkey': pubkey,
    });
  }

  Future<void> save() async {
    await save2Firestore();
    await save2SQLite();
  }
}
