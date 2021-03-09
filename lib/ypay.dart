library ypay;

import 'dart:convert';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ypay/src/constants.dart' as constants;
import 'package:ypay/src/models/user.dart';
import 'package:ypay/src/token.dart';

export 'src/models/user.dart';
export 'src/models/purchase.dart';

class YPay {
  static String baseUrl;
  final String _clientId;
  final Uri _authorizationUrl;
  final Uri _tokenUrl;
  final String _callbackUrlScheme;
  final Iterable<String> scopes;

  static oauth2.Client client;

  YPay({
    String baseUrl,
    String clientId,
    Uri tokenUrl,
    Uri authorizationUrl,
    this.scopes = const [''],
  })  : _clientId = clientId,
        _authorizationUrl =
            authorizationUrl ?? Uri.parse('$baseUrl/oauth/authorize'),
        _tokenUrl = tokenUrl ?? Uri.parse('$baseUrl/oauth/token'),
        _callbackUrlScheme = constants.redirectUrl {
    YPay.baseUrl = baseUrl ?? constants.baseUrl;
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
      scopes: scopes,
    );

    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: _callbackUrlScheme,
    );

    return grant
        .handleAuthorizationResponse(Uri.parse(result).queryParameters)
        .then((client) async {
      await Token.write(client.credentials);

      return user;
    });
  }

  Future<User> get user async => client
      .get('${YPay.baseUrl}/api/user')
      .then((response) => User.fromMap(json.decode(response.body)));
}
