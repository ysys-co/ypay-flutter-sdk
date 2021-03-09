library ypay;

import 'dart:convert';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ypay/src/models/user.dart';
import 'package:ypay/src/token.dart';

export 'src/models/user.dart';
export 'src/models/purchase.dart';

class YPay {
  final String _clientId;
  final Iterable<String> _scopes;
  final Uri _authorizationUrl;
  final Uri _tokenUrl;
  final String _callbackUrlScheme;

  static String baseUrl;
  static oauth2.Client client;

  YPay({
    String name = 'ypay',
    String baseUrl,
    String clientId,
    Iterable<String> scopes = const [''],
  })  : _clientId = clientId,
        _scopes = scopes,
        _authorizationUrl = Uri.parse('$baseUrl/oauth/authorize'),
        _tokenUrl = Uri.parse('$baseUrl/oauth/token'),
        _callbackUrlScheme = '$name-$clientId' {
    YPay.baseUrl = baseUrl;
    _initialize();
  }

  _initialize() async {
    if (await Token.isExists) {
      client = oauth2.Client(
        await Token.read(),
        identifier: _clientId,
        onCredentialsRefreshed: Token.write,
      );
    }
  }

  Future<User> authenticate() async {
    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
      _clientId,
      _authorizationUrl,
      _tokenUrl,
    );

    var authorizationUrl = grant.getAuthorizationUrl(
      Uri.parse('$_callbackUrlScheme://'),
      scopes: _scopes,
    );

    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: _callbackUrlScheme,
    );

    client = await grant
        .handleAuthorizationResponse(Uri.parse(result).queryParameters);

    await Token.write(client.credentials);

    return user;
  }

  Future<User> get user async => client
      .get('$baseUrl/api/user')
      .then((response) => User.fromMap(json.decode(response.body)));
}
