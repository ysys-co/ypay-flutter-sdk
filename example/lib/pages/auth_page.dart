import 'package:example/locator.dart';
import 'package:example/pages/purchase/new_page.dart';
import 'package:flutter/material.dart';
import 'package:ypay/ypay.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        brightness: Brightness.dark,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pay by ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0XFF009FE3),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: StadiumBorder(),
                ),
                onPressed: () async {
                  final user = await locator<YPay>().authenticate();

                  print('Welcome back ${user.name}!');

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PurchaseNewPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
