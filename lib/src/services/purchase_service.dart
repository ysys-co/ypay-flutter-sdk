import 'dart:convert';

import 'package:ypay/src/models/purchase.dart';
import 'package:ypay/ypay.dart';

extension PurchaseService on Purchase {
  Future<Purchase> save() async => YPay.client
          .post(
        Uri.parse('${YPay.baseUrl}/api/v1/wallets/${this.wallet.id}/purchases'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(this.toMap()),
      )
          .then((response) {
            print(response.body.toString());
        assert(response.statusCode == 201, 'Oops, something went wrong');

        return Purchase.fromMap(json.decode(response.body));
      });

  Future<Purchase> confirm() async {
    assert(
      this.id != null,
      'Please save ${this.runtimeType.toString().toLowerCase()} first!',
    );

    return YPay.client.post(
      Uri.parse(
          '${YPay.baseUrl}/api/v1/wallets/${this.wallet.id}/purchases/${this.id}/confirm'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).then((response) {
      assert(response.statusCode == 200, 'Oops, something went wrong');

      return Purchase.fromMap(json.decode(response.body));
    });
  }

  Future<Purchase> cancel() async {
    assert(
      this.id != null,
      'Please save ${this.runtimeType.toString().toLowerCase()} first!',
    );

    return YPay.client.post(
      Uri.parse(
          '${YPay.baseUrl}/api/v1/wallets/${this.wallet.id}/purchases/${this.id}/cancel'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).then((response) {
      assert(response.statusCode == 200, 'Oops, something went wrong');

      return Purchase.fromMap(json.decode(response.body));
    });
  }
}
