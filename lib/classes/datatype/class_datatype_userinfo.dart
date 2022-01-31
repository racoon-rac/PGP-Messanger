import 'package:pgpmessanger/classes/firebase/class_fs_usermanager.dart';

class DataUserInfo {
  final String uid;
  final String? _pubkey;
  final String? _nickname;

  DataUserInfo({required this.uid, String? pubkey, String? nickname})
      : _pubkey = pubkey,
        _nickname = nickname;

  Future<String> get nickname async {
    String name = await FS_UserManager().getNickname(uid);
    return _nickname ?? name;
  }

  Future<String> get pubkey async {
    String pubkey = await FS_UserManager().getPubKey(uid);
    return _pubkey ?? pubkey;
  }
}
