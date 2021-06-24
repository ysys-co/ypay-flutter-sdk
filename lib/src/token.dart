import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class Token {
  static final _storage = FlutterSecureStorage();
  static final _key = 'oauth';

  static Future<bool> get isExists async =>
      await _storage.containsKey(key: _key);

  static Future<oauth2.Credentials> read() async =>
      oauth2.Credentials.fromJson(await (_storage.read(key: _key) as FutureOr<String>));
  static Future delete() async => await _storage.deleteAll();

  static Future write(oauth2.Credentials credentials) async =>
      _storage.write(key: _key, value: credentials.toJson());
}
