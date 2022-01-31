class DataMyPGPTable {
  String? uid;
  String? nickname;
  String? email;
  String? passphrase;
  String? prvkey;
  String? pubkey;

  DataMyPGPTable(
      {this.uid,
      this.nickname,
      this.email,
      this.passphrase,
      this.prvkey,
      this.pubkey});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'uid': uid,
      'nickname': nickname,
      'email': email,
      'passphrase': passphrase,
      'prvkey': prvkey,
      'pubkey': pubkey,
    };
    return map;
  }

  DataMyPGPTable.fromMap(Map<String, Object?> map) {
    uid = map['uid'] as String?;
    nickname = map['nickname'] as String?;
    email = map['email'] as String?;
    passphrase = map['passphrase'] as String?;
    prvkey = map['prvkey'] as String?;
    pubkey = map['pubkey'] as String?;
  }
}
