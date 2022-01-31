class DBColumnNotFoundException implements Exception {
  final String columnName;
  DBColumnNotFoundException({required this.columnName});
  @override
  String toString() =>
      'DBKeyNotFoundException: In SQLite Database, Specific Column "$columnName" Not Found.';
}

class FSUserNotFoundException implements Exception {
  final String user;
  FSUserNotFoundException({required this.user});
  @override
  String toString() =>
      'FSUserNotFoundException: In FireStore, Specific user (pubkey: "$user") not found.';
}

class FSDocNotFoundException implements Exception {
  final String docName;
  FSDocNotFoundException({required this.docName});
  @override
  String toString() =>
      'FSDocNotFoundException: In FireStore, Specific document "$docName" not found.';
}
