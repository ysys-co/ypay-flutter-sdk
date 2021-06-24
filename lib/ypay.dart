library ypay;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ypay/src/models/user.dart';
import 'package:ypay/src/token.dart';

export 'src/models.dart';
export 'src/services.dart';

class YPay {
  final Iterable<String> _scopes;
  final Uri _authorizationUrl;
  final Uri _tokenUrl;

  static String? baseUrl;
  static oauth2.Client? client;
  static const MethodChannel _channel = const MethodChannel('ypay');

  String? _clientId;
  late String _schemeUrl;

  YPay({
    String baseUrl = 'https://console.y-pay.co',
    Iterable<String> scopes = const [''],
  })  : _scopes = scopes,
        _authorizationUrl = Uri.parse('$baseUrl/oauth/authorize'),
        _tokenUrl = Uri.parse('$baseUrl/oauth/token') {
    YPay.baseUrl = baseUrl;
    _initialize();
  }

  _initialize() async {
    _clientId ??= await _channel.invokeMethod<String>('getClientId');
    _schemeUrl = 'ypay-$_clientId';

    if (await Token.isExists) {
      client = oauth2.Client(
        await Token.read(),
        identifier: _clientId,
        onCredentialsRefreshed: Token.write,
      );
    }
  }

  Future<User> authenticate() async {
    await _initialize();

    if (client != null)
      if (await Token.isExists) return user;

    // print(await Token.read().then((value) => value.accessToken));

    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
      _clientId!,
      _authorizationUrl,
      _tokenUrl,
    );

    var authorizationUrl = grant.getAuthorizationUrl(
      Uri.parse('$_schemeUrl://'),
      scopes: _scopes,
    );

    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: _schemeUrl,
    );

    client = await grant
        .handleAuthorizationResponse(Uri.parse(result).queryParameters);

    await Token.write(client!.credentials);
    return user;
  }

  Future<User> get user async => client!
      .get(Uri.parse('$baseUrl/api/user'))
      .then((response) {
        log(response.body);
        return User.fromMap(json.decode(response.body));
      });

  Future signOut() async {
    await _initialize();

    return client!
        .post(Uri.parse('$baseUrl/api/v2/me/logout'))
        .whenComplete(Token.delete)
        .then((value) => print(value.statusCode));
  }
}
