import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlitePgpMsgDB {
  bool debugMode;
  late Database handler;
  static const String dbFilename = 'pgpmsg.db';

  SqlitePgpMsgDB({this.debugMode = false});

  Future<void> open() async {
    Sqflite.devSetDebugModeOn(debugMode);
    handler = await openDatabase(join(await getDatabasesPath(), dbFilename),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("""
create table mypgp (
  `uid`,
  `nickname`,
  `email`,
  `passphrase`,
  `pubkey`,
  `prvkey`
);""");
    });
  }

  Future<void> close() async => handler.close();

  Future<void> drop() async {
    Sqflite.devSetDebugModeOn(debugMode);
    await deleteDatabase(join(await getDatabasesPath(), dbFilename));
  }
}
