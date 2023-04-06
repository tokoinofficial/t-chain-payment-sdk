import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'tchain_payment_localizations_en.dart';
import 'tchain_payment_localizations_id.dart';

/// Callers can lookup localized strings with an instance of TChainPaymentLocalizations
/// returned by `TChainPaymentLocalizations.of(context)`.
///
/// Applications need to include `TChainPaymentLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/tchain_payment_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TChainPaymentLocalizations.localizationsDelegates,
///   supportedLocales: TChainPaymentLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TChainPaymentLocalizations.supportedLocales
/// property.
abstract class TChainPaymentLocalizations {
  TChainPaymentLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TChainPaymentLocalizations? of(BuildContext context) {
    return Localizations.of<TChainPaymentLocalizations>(context, TChainPaymentLocalizations);
  }

  static const LocalizationsDelegate<TChainPaymentLocalizations> delegate = _TChainPaymentLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @invalid_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalid_code;

  /// No description provided for @something_went_wrong_please_try_later.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try later'**
  String get something_went_wrong_please_try_later;

  /// No description provided for @you_are_not_enough_bnb.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough BNB to perform this transaction'**
  String get you_are_not_enough_bnb;

  /// No description provided for @the_selected_wallet_supports_eth_network_please_select_another_one.
  ///
  /// In en, this message translates to:
  /// **'The selected wallet supports ETH network only, please select a wallet supporting BNB Smart Chain network to use the feature.'**
  String get the_selected_wallet_supports_eth_network_please_select_another_one;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'SLOW'**
  String get slow;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'FAST'**
  String get fast;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE'**
  String get average;

  /// No description provided for @our_policy.
  ///
  /// In en, this message translates to:
  /// **' our policy'**
  String get our_policy;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @btn_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btn_continue;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @blocks.
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get blocks;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @you_will_pay.
  ///
  /// In en, this message translates to:
  /// **'You Will Pay'**
  String get you_will_pay;

  /// No description provided for @payment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmation'**
  String get payment_confirmation;

  /// No description provided for @select_coin_type_to_pay.
  ///
  /// In en, this message translates to:
  /// **'Select a coin type that you\'d like to pay'**
  String get select_coin_type_to_pay;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get payment_amount;

  /// No description provided for @deposit_amount.
  ///
  /// In en, this message translates to:
  /// **'Deposit Amount'**
  String get deposit_amount;

  /// No description provided for @deposit_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Deposit Confirmation'**
  String get deposit_confirmation;

  /// No description provided for @select_coin_type_to_deposit.
  ///
  /// In en, this message translates to:
  /// **'Select a coin type that you\'d like to deposit'**
  String get select_coin_type_to_deposit;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @coin_type.
  ///
  /// In en, this message translates to:
  /// **'Coin Type'**
  String get coin_type;

  /// No description provided for @select_coin_type.
  ///
  /// In en, this message translates to:
  /// **'Select Coin Type'**
  String get select_coin_type;

  /// No description provided for @your_balance_is_not_enough.
  ///
  /// In en, this message translates to:
  /// **'Your balance is not enough {x} to make the payment'**
  String your_balance_is_not_enough(Object x);

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @transaction_fee.
  ///
  /// In en, this message translates to:
  /// **'Transaction Fee'**
  String get transaction_fee;

  /// No description provided for @pay_toko_amount.
  ///
  /// In en, this message translates to:
  /// **'Pay TOKO Amount'**
  String get pay_toko_amount;

  /// No description provided for @service_fee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get service_fee;

  /// No description provided for @x_discount_applied.
  ///
  /// In en, this message translates to:
  /// **'({x}% discount applied)'**
  String x_discount_applied(Object x);

  /// No description provided for @use_toko_pay.
  ///
  /// In en, this message translates to:
  /// **'Pay '**
  String get use_toko_pay;

  /// No description provided for @use_toko_to_get.
  ///
  /// In en, this message translates to:
  /// **' to get '**
  String get use_toko_to_get;

  /// No description provided for @use_toko_of_service_fee.
  ///
  /// In en, this message translates to:
  /// **' of the service fee (Balance: '**
  String get use_toko_of_service_fee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'discount'**
  String get discount;

  /// No description provided for @unable_to_apply_discount.
  ///
  /// In en, this message translates to:
  /// **'Unable to Apply Discount'**
  String get unable_to_apply_discount;

  /// No description provided for @unable_to_apply_discount_desc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough TOKO (available TOKO: {x}) to get {y}% discount of the service fee. Please deposit more TOKO to your balance first and proceed the payment again.'**
  String unable_to_apply_discount_desc(Object x, Object y);

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @deposit_payment_status.
  ///
  /// In en, this message translates to:
  /// **'Deposit Payment Status'**
  String get deposit_payment_status;

  /// No description provided for @payment_proceeding.
  ///
  /// In en, this message translates to:
  /// **'Payment Proceeding'**
  String get payment_proceeding;

  /// No description provided for @payment_proceeding_brought_back_3rdapp.
  ///
  /// In en, this message translates to:
  /// **'Your payment is proceeding, you will be brought back to [3rd party app name] in {x} seconds'**
  String payment_proceeding_brought_back_3rdapp(Object x);

  /// No description provided for @payment_proceeding_can_take_up.
  ///
  /// In en, this message translates to:
  /// **'Your payment is proceeding, it can take up to {x} seconds. Please wait.'**
  String payment_proceeding_can_take_up(Object x);

  /// No description provided for @payment_proceeding_can_take_longer.
  ///
  /// In en, this message translates to:
  /// **'Your payment is proceeding, it can take longer than usual due to busy traffic network. Please wait.'**
  String get payment_proceeding_can_take_longer;

  /// No description provided for @payment_completed.
  ///
  /// In en, this message translates to:
  /// **'Payment Completed'**
  String get payment_completed;

  /// No description provided for @payment_completed_brought_back_3rdapp.
  ///
  /// In en, this message translates to:
  /// **'Your payment completed successfully, you will be brought back to [3rd party app name] in {x} seconds'**
  String payment_completed_brought_back_3rdapp(Object x);

  /// No description provided for @payment_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Your payment completed successfully.'**
  String get payment_completed_successfully;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payment_failed;

  /// No description provided for @payment_failed_brought_back_3rdapp.
  ///
  /// In en, this message translates to:
  /// **'Your payment is failed, you will be brought back to [3rd party app name] in {x} seconds'**
  String payment_failed_brought_back_3rdapp(Object x);

  /// No description provided for @unfortunately_payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your payment is failed.'**
  String get unfortunately_payment_failed;

  /// No description provided for @you_are_about_to_deposit.
  ///
  /// In en, this message translates to:
  /// **'You are about to deposit amount of'**
  String get you_are_about_to_deposit;

  /// No description provided for @go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get go_home;

  /// No description provided for @enter_transfer_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter Transfer Amount'**
  String get enter_transfer_amount;

  /// No description provided for @merchant_client.
  ///
  /// In en, this message translates to:
  /// **'Merchant Client'**
  String get merchant_client;

  /// No description provided for @transfer_amount.
  ///
  /// In en, this message translates to:
  /// **'Transfer amount'**
  String get transfer_amount;

  /// No description provided for @note_optional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get note_optional;

  /// No description provided for @add_a_note.
  ///
  /// In en, this message translates to:
  /// **'Add a Note'**
  String get add_a_note;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @write_your_note.
  ///
  /// In en, this message translates to:
  /// **'Write your note...'**
  String get write_your_note;

  /// No description provided for @please_select_token_to_transfer.
  ///
  /// In en, this message translates to:
  /// **'Please select a token that you would like to transfer to merchant client'**
  String get please_select_token_to_transfer;

  /// No description provided for @please_select_token_to_deposit.
  ///
  /// In en, this message translates to:
  /// **'Please select a token that you would like to deposit'**
  String get please_select_token_to_deposit;

  /// No description provided for @exchange_rate_will_be_refreshed_after.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate will be refreshed after'**
  String get exchange_rate_will_be_refreshed_after;

  /// No description provided for @select_currency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get select_currency;

  /// No description provided for @exchange_rate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchange_rate;

  /// No description provided for @you_will_transfer.
  ///
  /// In en, this message translates to:
  /// **'You will transfer'**
  String get you_will_transfer;

  /// No description provided for @tap_to_add.
  ///
  /// In en, this message translates to:
  /// **'Tap to Add'**
  String get tap_to_add;

  /// No description provided for @select_token.
  ///
  /// In en, this message translates to:
  /// **'Select Token'**
  String get select_token;

  /// No description provided for @insufficient_balance_to_use_token.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance to use this token for transfer'**
  String get insufficient_balance_to_use_token;

  /// No description provided for @invalid_exchange_rate.
  ///
  /// In en, this message translates to:
  /// **'Invalid exchange rate'**
  String get invalid_exchange_rate;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @view_transaction_detail.
  ///
  /// In en, this message translates to:
  /// **'View Transaction Detail'**
  String get view_transaction_detail;
}

class _TChainPaymentLocalizationsDelegate extends LocalizationsDelegate<TChainPaymentLocalizations> {
  const _TChainPaymentLocalizationsDelegate();

  @override
  Future<TChainPaymentLocalizations> load(Locale locale) {
    return SynchronousFuture<TChainPaymentLocalizations>(lookupTChainPaymentLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_TChainPaymentLocalizationsDelegate old) => false;
}

TChainPaymentLocalizations lookupTChainPaymentLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return TChainPaymentLocalizationsEn();
    case 'id': return TChainPaymentLocalizationsId();
  }

  throw FlutterError(
    'TChainPaymentLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
