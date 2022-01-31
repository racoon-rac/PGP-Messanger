import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openpgp/openpgp.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class PGPCrypter {
  Future<String> encrypt(String plainText, String dstPubKey) async {
    String publicKey = dstPubKey;
    String encryptedText = await OpenPGP.encrypt(plainText, publicKey);
    return encryptedText;
  }

  Future<String> decrypt(String encryptedText, {Map? decUnit}) async {
    decUnit ??= await MyPGPTable().getDecUnit();
    String plainText = await OpenPGP.decrypt(
        encryptedText, decUnit['prvkey'], decUnit['passphrase']);
    return plainText;
  }

  Future<List> decryptMessages(
      String uid, QuerySnapshot<Object?>? messageList) async {
    Map decUnit = await MyPGPTable().getDecUnit();

    List messages = [];
    for (var msg in messageList!.docs) {
      String encText = (await msg.get('text'))[uid];
      String text = await decrypt(encText, decUnit: decUnit);
      var textMessage = types.TextMessage(
        author: types.User(
          id: await msg.get('uid'),
          firstName: await msg.get('nickname'),
        ),
        createdAt: await msg.get('createdAt'),
        id: await msg.get('id'),
        text: text,
      );
      messages.add(textMessage);
    }

    return messages;
  }
}
