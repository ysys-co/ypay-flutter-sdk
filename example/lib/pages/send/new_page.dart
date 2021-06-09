import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ypay/ypay.dart';

class SendNewPage extends StatefulWidget {
  @override
  _SendNewPageState createState() => _SendNewPageState();
}

class _SendNewPageState extends State<SendNewPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _send = Send();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Send'),
        titleSpacing: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'To',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onSaved: (value) => _send.to = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                onSaved: (value) => _send.amount = int.parse(value),
              ),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) => _send.description = value,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Icons.done),
      ),
    );
  }

  _submit() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final user = await locator<YPay>().authenticate();

      _send.wallet = user.wallets.first;
      await _send.save().then((send) async {
        send.wallet = user.wallets.first;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Alert'),
            content: Text('Are you sure to send ${send.amount} to ${send.to}'),
            actions: [
              ElevatedButton(
                onPressed: () async => await send.cancel().whenComplete(Navigator.of(context).pop),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async => await send.confirm().then((confirmedSend){
                  print("confirmedSend.transaction.id"+confirmedSend.transaction.id.toString());
                  Navigator.of(context).pop();
                }),
                child: Text('Confirm'),
              ),
            ],
          ),
          barrierDismissible: false,
        ).whenComplete(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Done')));
        });
      });
    }
  }
}
