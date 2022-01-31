import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_chatroom.dart';
import 'package:pgpmessanger/classes/datatype/class_datatype_userinfo.dart';
import 'package:pgpmessanger/classes/pgp/class_pgpcrypter.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';

class FS_ChatRoomManager {
  late CollectionReference userInfo;
  late CollectionReference chatRoom;

  FS_ChatRoomManager() {
    userInfo = FirebaseFirestore.instance.collection('user_info');
    chatRoom = FirebaseFirestore.instance.collection('chat_room');
  }

  Future<void> addMessage(
      DataChatRoom roomData, String id, String plainText) async {
    String roomId = roomData.roomID!;
    String dstUid = roomData.dstUser!.uid;
    String dstText =
        await PGPCrypter().encrypt(plainText, await roomData.dstUser!.pubkey);
    DataUserInfo myUserInfo = await roomData.myUserInfo;
    String myUid = myUserInfo.uid;
    String myNickname = await myUserInfo.nickname;
    String myText =
        await PGPCrypter().encrypt(plainText, await myUserInfo.pubkey);
    await chatRoom.doc(roomId).collection('message').add({
      'uid': myUid,
      'nickname': myNickname,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'id': id,
      'text': {dstUid: dstText, myUid: myText},
    });
  }

  Future<List<DataChatRoom?>> getRoomList() async {
    String myUid = await MyPGPTable().getUid();
    QuerySnapshot roomElements =
        await chatRoom.where('users', arrayContains: myUid).get();
    List<DataChatRoom> roomList = [];
    for (DocumentSnapshot room in roomElements.docs) {
      List uidList = await room.get('users');
      int dstId = 1 - uidList.indexOf(myUid);
      String dstUid = uidList[dstId];
      // 最新のメッセージの表示処理
      // QuerySnapshot message = await getMessages(room.id);
      roomList.add(DataChatRoom(
        dstUser: DataUserInfo(uid: dstUid),
        roomID: room.id,
        //messageList: message,
      ));
    }
    return roomList;
  }

  Future<QuerySnapshot> getMessages(String roomId, {int? limit}) async {
    if (limit != null) {
      return await chatRoom
          .doc(roomId)
          .collection('message')
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();
    } else {
      return await chatRoom
          .doc(roomId)
          .collection('message')
          .orderBy('createdAt', descending: true)
          .get();
    }
  }

  Stream snapShotMessages(String roomId, String uid) {
    return chatRoom
        .doc(roomId)
        .collection('message')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  Future<void> deleteAllRooms() async {
    List roomList = await getRoomList();
    for (DataChatRoom room in roomList) {
      var roomDoc = chatRoom
          .doc(room.roomID);
      var snapshots = await roomDoc
          .collection('message')
          .get();
      for (var doc in snapshots.docs) {
        debugPrint(doc.id.toString());
        await doc.reference.delete();
        debugPrint('deleted');
      }
      await roomDoc.delete();
    }
  }
}
