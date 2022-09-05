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

- Need register your project at (Tokoin page)[https://developer.tokoin.io/guides/creating-a-project] to get `merchantID` which will be used in SDK

## Flow


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
     <data android:scheme="merchaint.${applicationId} "
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
  <string>mtwallet</string>
</array>
```

### How To Use

We have to initial `TChainPaymentSDK` before using it.
```
TChainPaymentSDK.instance.init(
      merchantID: merchantID,
      bundleID: bundleID,
      delegate: (TChainPaymentResult result) {
          // handle result (success, cancelled, failed) which has been returned after performing payment method
      },
    );
```

- To pay for your order, please use `TChainPaymentSDK.instance.purchase(...)`
```
final TChainPaymentResult result = await TChainPaymentSDK.instance.purchase(
      orderID: orderID,
      amount: product.price,
    );
    
// handle result: waiting, error
```

- Payment status of the result can be one of the values below
```
enum TChainPaymentStatus {
  // payment has been succeeded
  success,

  // be cancelled by user
  cancelled,

  // payment has been failed
  failed,

  // payment's proceeding but it takes a long time to get the final result.
  // You should use tnx to continue checking the status
  proceeding,

  // waiting for user interaction
  waiting,

  // error: Invalid parameter ...
  error,
}
```

Considering to do your next step based on the status

