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

# TChain Payment SDK.

## Getting Started

- Need register your project at [Tokoin dev page](https://developer.tokoin.io/guides/creating-a-project) to get `merchantId` and `x-api-key` which will be used in SDK

## Flow

<p align="center">
  <img src="https://raw.githubusercontent.com/tokoinofficial/t-chain-payment-sdk/master/resource/app_to_app_flow.png" alt="T-Chain App to App Flow" />
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/tokoinofficial/t-chain-payment-sdk/master/resource/pos_qr_code_flow.png" alt="T-Chain POS QR Code Flow" />
</p>


## Integration


### Android setup:

* Set up your ```AndroidManifest.xml``` as below:

```xml
 <activity
      ...
     android:launchMode="singleTask"
     ...>
   <intent-filter>
     <action android:name="android.intent.action.VIEW" />
     <category android:name="android.intent.category.DEFAULT" />
     <category android:name="android.intent.category.BROWSABLE" />
     <data android:scheme="merchaint.${applicationId}"
                    android:host="app" />
   </intent-filter>
</activity>
           
```

### iOS setup:

* Set up your ```Info.plist``` as below

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>Payment Scheme Callback</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>merchant.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>$(WALLET_SCHEME)</string>
</array>
```
* WALLET_SCHEME: please define your query scheme , we will use it to create deeplink

### How To Use

#### Merchant App
Step 1: Initialize `TChainPaymentSDK`
```
    TChainPaymentSDK.shared.configMerchantApp(
      apiKey: Constants.apiKey,
      bundleId: Constants.bundleId,
      env: TChainPaymentEnv.dev, // TChainPaymentEnv.prod as default value
      delegate: (TChainPaymentResult result) {
          // handle result (success, cancelled, failed) which has been returned after performing payment method
      },
    );
```

Step 2: To pay for an order:
```
final TChainPaymentResult result = await TChainPaymentSDK.shared.deposit(
      walletScheme: WALLET_SCHEME,
      notes: notes,
      amount: product.price,
      currency: TChainPaymentCurrency.idr,
    );
    
// handle result: waiting, error
```

- Payment status of the result can be one of the values below
```
enum TChainPaymentStatus {
  /// Payment has been succeeded
  success,

  /// Be cancelled by user
  cancelled,

  /// Payment has been failed
  failed,

  /// Payment's proceeding but it takes a long time to get the final result.
  /// You should use tnx to continue checking the status
  proceeding,

  /// Waiting for user interaction
  waiting,

  /// Error: Invalid parameter ...
  error,
}
```

- If you only want create a Qr Code, you can use `generateQrCode` below
```
  final result = await TChainPaymentSDK.shared.generateQrCode(
      walletScheme: 'walletExample',
      notes: notes,
      amount: amount,
      currency: currency,
      imageSize: imageSize,
    );
```

Step 3: Depend on the status, show results to users based on the application design.

#### Wallet App

```
    TChainPaymentSDK.shared.configWallet(
      apiKey: Constants.apiKey,
      env: TChainPaymentEnv.dev,
      onDeeplinkReceived: (uri) {
        // handle qr code 

        if (deepLink.scheme == 'walletexample' && deepLink.host == 'app') {
          final qrCode = deepLink.queryParameters['qr_code'] ?? '';
          final bundleId = deepLink.queryParameters['bundle_id'] ?? '';

          switch (deepLink.path) {
            case '/payment_deposit':
              TChainPaymentSDK.shared.startPaymentWithQrCode(
                context,
                account: Account.fromPrivateKeyHex(hex: Constants.privateKeyHex),
                qrCode: qrCode,
                bundleId: bundleId,
              );

            break;
          }
        }
      },
    );
```

- In case you want to implement QR Payment scanning use case, we also provide some utility function to do it easier
```
    // get merchant info
    final merchantInfo = await TChainPaymentSDK.shared
                      .getMerchantInfo(qrCode: qrCode);

    // open payment UI
    TChainPaymentSDK.shared.startPaymentWithMerchantInfo(
      context,
      account: Account.fromPrivateKeyHex(hex: Constants.privateKeyHex),
      merchantInfo: merchantInfo,
    );
```