import 'dart:convert';
import 'dart:developer';

import 'package:ypay/src/models/send.dart';
import 'package:ypay/ypay.dart';

extension SendService on Send {
  Future<Send> save() async => YPay.client!
          .post(
        Uri.parse('${YPay.baseUrl}/api/v1/wallets/${this.wallet!.id}/sends'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(this.toMap()),
      )
          .then((response) {
            print("response.statusCode.toString()"+response.statusCode.toString());

        assert(response.statusCode == 201, 'Oops, something went wrong');

        return Send.fromMap(json.decode(response.body));
      });

  Future<Send> confirm() async {
    assert(
      this.id != null,
      'Please save ${this.runtimeType.toString().toLowerCase()} first!',
    );

    return YPay.client!.post(
      Uri.parse('${YPay.baseUrl}/api/v1/wallets/${this.wallet!.id}/sends/${this.id}/confirm'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).then((response) {
      assert(response.statusCode == 200, 'Oops, something went wrong');


      return Send.fromMap(json.decode(response.body));
    });
  }

  Future<Send> cancel() async {
    assert(
      this.id != null,
      'Please save ${this.runtimeType.toString().toLowerCase()} first!',
    );

    return YPay.client!.post(
      Uri.parse('${YPay.baseUrl}/api/v1/wallets/${this.wallet!.id}/sends/${this.id}/cancel'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).then((response) {
      assert(response.statusCode == 200, 'Oops, something went wrong');

      return Send.fromMap(json.decode(response.body));
    });
  }
}
