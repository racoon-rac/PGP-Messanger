import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openpgp/model/bridge_model_generated.dart';
import 'package:pgpmessanger/classes/exceptions.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:pgpmessanger/classes/sqlite/class_sqlitepgpmsg.dart';

class FS_UserManager {
  late CollectionReference userInfo;

  FS_UserManager() {
    userInfo = FirebaseFirestore.instance.collection('user_info');
  }

  Future<bool> isThereUser(String uid) async {
    DocumentSnapshot element = await userInfo.doc(uid).get();
    return element.exists;
  }

  Future<String> getNickname(String uid) async {
    DocumentSnapshot element = await userInfo.doc(uid).get();
    if (!element.exists) {
      throw FSDocNotFoundException(docName: 'nickname');
    }
    return element.get('nickname');
  }

  Future<String> getPubKey(String uid) async {
    DocumentSnapshot element = await userInfo.doc(uid).get();
    if (!element.exists) {
      throw FSDocNotFoundException(docName: 'pubkey');
    }
    return element.get('pubkey');
  }

  Future<String> getUid(String pubkey) async {
    QuerySnapshot element =
        await userInfo.where('pubkey', isEqualTo: pubkey).get();
    if (element.docs.isNotEmpty) {
      return element.docs.first.id;
    } else {
      throw FSUserNotFoundException(user: pubkey.substring(0, 80));
    }
  }

  Future<void> deleteUser() async {
    String uid = await MyPGPTable().getUid();
    await userInfo.doc(uid).delete();
  }
}
