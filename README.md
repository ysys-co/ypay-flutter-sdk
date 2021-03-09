# YPay

[YPay](http://y-pay.co) is a simple payment platform.

# Getting Started

1. Add to your dependencies:

```yaml
dependencies:
  ypay: ^x.x.x
```

2. Add to your `AndroidManifest.xml`

```xml
<application>
    <!-- ... -->

    <activity android:name="com.linusu.flutter_web_auth.CallbackActivity">
        <intent-filter android:label="flutter_web_auth">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="<YOUR_APP_NAME>" />
        </intent-filter>
    </activity>

    <!-- ... -->
</application>
```

3. Create YPay object.

```dart
final ypay = YPay(
    baseUrl: '<YPAY_BACKEND_BASE_URL>',
    clientId: '<YOUR_CLIENT_ID>',
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
