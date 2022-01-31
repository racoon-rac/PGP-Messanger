import 'package:pgpmessanger/classes/datatype/class_datatype_mypgp.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_userinfo.dart';
import 'package:pgpmessanger/classes/exceptions.dart';
import 'package:pgpmessanger/classes/sqlite/class_sqlitepgpmsg.dart';
import 'package:sqflite/sqflite.dart';

class MyPGPTable {
  final db = SqlitePgpMsgDB();
  bool debugMode;

  MyPGPTable({this.debugMode = false});

  Future<String> getUid() async {
    Sqflite.devSetDebugModeOn(true);
    try {
      await db.open();
      List<Map<String, Object?>> maps =
          await db.handler.query('mypgp', columns: ['uid']);
      await db.close();
      return maps.first['uid'] as String;
    } catch (e) {
      print(e);
      throw DBColumnNotFoundException(columnName: 'uid');
    }
  }

  Future<String> getNickname() async {
    Sqflite.devSetDebugModeOn(debugMode);
    try {
      await db.open();
      List<Map<String, Object?>> maps =
          await db.handler.query('mypgp', columns: ['nickname']);
      await db.close();
      return maps.first['nickname'] as String;
    } catch (e) {
      throw DBColumnNotFoundException(columnName: 'nickname');
    }
  }

  Future<String> getPubKey() async {
    Sqflite.devSetDebugModeOn(debugMode);
    try {
      await db.open();
      List<Map<String, Object?>> mapList =
          await db.handler.query('mypgp', columns: ['pubkey']);
      await db.close();
      return mapList.first['pubkey'] as String;
    } catch (e) {
      throw DBColumnNotFoundException(columnName: 'pubkey');
    }
  }

  Future<DataUserInfo> getMyUserInfo() async {
    Sqflite.devSetDebugModeOn(debugMode);
    try {
      await db.open();
      List<Map<String, Object?>> mapList = await db.handler
          .query('mypgp', columns: ['uid', 'nickname', 'pubkey']);
      await db.close();
      var myInfo = mapList.first;
      return DataUserInfo(
        uid: myInfo['uid'] as String,
        nickname: myInfo['nickname'] as String,
        pubkey: myInfo['pubkey'] as String
      );
    } catch (e) {
      throw DBColumnNotFoundException(columnName: 'uid or nickname or pubkey');
    }
  }

  Future<Map> getDecUnit() async {
    Sqflite.devSetDebugModeOn(debugMode);
    try {
      await db.open();
      List<Map<String, Object?>> mapList =
          await db.handler.query('mypgp', columns: ['passphrase', 'prvkey']);
      await db.close();
      var mypgp = mapList.first;
      return {
        'passphrase': mypgp['passphrase'] as String,
        'prvkey': mypgp['prvkey'] as String
      };
    } catch (e) {
      throw DBColumnNotFoundException(columnName: 'prvkey and passphrase');
    }
  }

  Future<void> updatePGPKey(String pubkey, String prvkey) async {
    db.handler.update('mypgp', {'pubkey': pubkey, 'prvkey': prvkey});
  }

  Future<void> updateNickname(String nickname) async {
    db.handler.update('mypgp', {'nickname': nickname});
  }

  Future<void> updateEmail(String email) async {
    db.handler.update('mypgp', {'email': email});
  }

  Future<void> saveMyKey(DataMyPGPTable dataMyPGP) async {
    Sqflite.devSetDebugModeOn(debugMode);
    await db.open();
    await db.handler.insert('mypgp', dataMyPGP.toMap());
    await db.close();
  }

  Future<void> delete() async {
    Sqflite.devSetDebugModeOn(debugMode);
    await db.open();
    await db.handler.delete('mypgp');
    await db.close();
  }
}
