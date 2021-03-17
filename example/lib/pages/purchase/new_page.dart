import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ypay/ypay.dart';

class PurchaseNewPage extends StatefulWidget {
  @override
  _PurchaseNewPageState createState() => _PurchaseNewPageState();
}

class _PurchaseNewPageState extends State<PurchaseNewPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _purchase = Purchase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Purchase'),
        titleSpacing: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Code',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onSaved: (value) => _purchase.code = int.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) => _purchase.amount = int.parse(value),
              ),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) => _purchase.description = value,
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

      await _purchase.save().then((purchase) async {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Alert'),
            content: Text('Are you sure to pay ${purchase.amount}'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () async => await purchase
                    .cancel()
                    .whenComplete(Navigator.of(context).pop),
                child: Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () async => await purchase
                    .confirm()
                    .whenComplete(Navigator.of(context).pop),
                child: Text('Confirm'),
              ),
            ],
          ),
          barrierDismissible: false,
        ).whenComplete(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Done')));
        });
      });
    }
  }
}
