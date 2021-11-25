<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Tokoin Payment Gateway 

## Features

Add this to your flutter app to: 
- Buy crypto: it will redirect to OTC screen on My-T Wallet.
- Pay order: Send token screen on My-T Wallet (with the recipient address being merchant address.)

## Usage

```dart
PaymentButton(
 type: Type.sendToko,
 amount: _amount,
 address: _recipientAddress
)

PaymentButton(
 type: Type.buyToko,
 amount: _amount
)
```
