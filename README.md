# YPay

[YPay](http://y-pay.co) is a simple payment platform.

# Getting Started

1. Add to your dependencies:

```yaml
dependencies:
  ypay:
    git:
      url: git://github.com/ysys-co/ypay-flutter-sdk.git
      ref: 0.0.3-beta
```

1. Add to your `strings.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- ... -->

    <string name="ypay_client_id">YPAY_CLIENT_ID</string>
    <string name="ypay_auth_scheme">ypay-YPAY_CLIENT_ID</string>

    <!-- ... -->
</resources>
```

1. Add to your `AndroidManifest.xml`

```xml
<application>
    <!-- ... -->

    <meta-data
        android:name="co.ysys.ypay.clientId"
        android:value="@string/ypay_client_id" />

    <activity android:name="com.linusu.flutter_web_auth.CallbackActivity">
        <intent-filter android:label="flutter_web_auth">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="@string/ypay_auth_scheme" />
        </intent-filter>
    </activity>

    <!-- ... -->
</application>
```

1. Create YPay object.

```dart
final ypay = YPay(
    baseUrl: '<YPAY_PRODUCT_BASE_URL>', // For exmaple https://staging.qc.ysys.co
);
```

# Authentication

```dart
final user = await ypay.authenticate();

print('Welcome back ${user.name}!');
```

# Wallets

Fetch user wallets with amounts

```dart
final wallets = user.wallets;

print('You have ${wallets.first.amount} in your first wallet');
```

# Transactions

## Send

To send money between two entities, all you need to fill the data and pass the user your want to send to

```dart
final send = Send(
    amount: 100,
    to: '967773769681', // Mobile number
    type: TransactionType.p2p,
    description: 'Hello World',
    wallet: user.wallets.first,
);

send.save() // Save send
.then((send) => send.confirm()) // Confrim send
.then((send) {
    assert(send.isCompleted);

    // Have fun
});

```

## Purchase

To create purchase all you need to fill the data and pass merchant code

```dart
final purchase = Purchase(
    amount: 100,
    code: 203301,
    description: 'Hello World',
    wallet: user.wallets.first,
);

purchase.save() // Save purchase
.then((purchase) => purchase.confirm()) // Confrim purchase
.then((purchase) {
    assert(purchase.isCompleted);

    // Have fun
});
```
