import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_userinfo.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';

class DataChatRoom {
  final DataUserInfo? dstUser;
  final String? roomID;
  final QuerySnapshot? messageList;
  final DataUserInfo? _myUserInfo;

  DataChatRoom({this.dstUser, this.roomID, this.messageList, DataUserInfo? myUserInfo}) : _myUserInfo=myUserInfo;

  Future<DataUserInfo> get myUserInfo async {
    return _myUserInfo ?? await MyPGPTable().getMyUserInfo();
  }

}
