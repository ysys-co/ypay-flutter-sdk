import 'package:example/locator.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/purchase/new_page.dart';
import 'package:flutter/material.dart';
import 'package:ypay/ypay.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 48.0,
              child: RaisedButton(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/floosak.png',
                        height: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text('Pay with Floosak'),
                  ],
                ),
                textColor: Colors.white,
                color: Color(0XFF00689C),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                disabledColor: Theme.of(context).disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                onPressed: () async {
                  final user = await locator<YPay>().authenticate();

                  print('Welcome back ${user.name}!');
                  print('Amount is  ${user.wallets.first.amount}!');
                  print('Phone Number is is  ${user.id}!');

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomePage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
