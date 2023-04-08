import 'tchain_payment_localizations.dart';

/// The translations for English (`en`).
class TChainPaymentLocalizationsEn extends TChainPaymentLocalizations {
  TChainPaymentLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get invalid_code => 'Invalid code';

  @override
  String get something_went_wrong_please_try_later => 'Something went wrong, please try later';

  @override
  String get you_are_not_enough_bnb => 'You do not have enough BNB to perform this transaction';

  @override
  String get the_selected_wallet_supports_eth_network_please_select_another_one => 'The selected wallet supports ETH network only, please select a wallet supporting BNB Smart Chain network to use the feature.';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get our_policy => ' our policy';

  @override
  String get next => 'Next';

  @override
  String get btn_continue => 'Continue';

  @override
  String get submit => 'Submit';

  @override
  String get blocks => 'Blocks';

  @override
  String get confirm => 'Confirm';

  @override
  String get you_will_pay => 'You Will Pay';

  @override
  String get payment_confirmation => 'Payment confirmation';

  @override
  String get select_coin_type_to_pay => 'Select a coin type that you\'d like to pay';

  @override
  String get payment_status => 'Payment Status';

  @override
  String get payment_amount => 'Payment Amount';

  @override
  String get deposit_amount => 'Deposit Amount';

  @override
  String get deposit_confirmation => 'Deposit Confirmation';

  @override
  String get select_coin_type_to_deposit => 'Select a coin type that you\'d like to deposit';

  @override
  String get balance => 'Balance';

  @override
  String get coin_type => 'Coin Type';

  @override
  String get select_coin_type => 'Select Coin Type';

  @override
  String your_balance_is_not_enough(Object x) {
    return 'Your balance is not enough $x to make the payment';
  }

  @override
  String get and => 'and';

  @override
  String get transaction_fee => 'Transaction Fee';

  @override
  String get pay_toko_amount => 'Pay TOKO Amount';

  @override
  String get service_fee => 'Service Fee';

  @override
  String x_discount_applied(Object x) {
    return '($x% discount applied)';
  }

  @override
  String get use_toko_pay => 'Pay ';

  @override
  String get use_toko_to_get => ' to get ';

  @override
  String get use_toko_of_service_fee => ' of the service fee (Balance: ';

  @override
  String get discount => 'discount';

  @override
  String get unable_to_apply_discount => 'Unable to Apply Discount';

  @override
  String unable_to_apply_discount_desc(Object x, Object y) {
    return 'You don\'t have enough TOKO (available TOKO: $x) to get $y% discount of the service fee. Please deposit more TOKO to your balance first and proceed the payment again.';
  }

  @override
  String get deposit => 'Deposit';

  @override
  String get deposit_payment_status => 'Deposit Payment Status';

  @override
  String get payment_proceeding => 'Payment Proceeding';

  @override
  String payment_proceeding_brought_back_3rdapp(Object x) {
    return 'Your payment is proceeding, you will be brought back to [3rd party app name] in $x seconds';
  }

  @override
  String payment_proceeding_can_take_up(Object x) {
    return 'Your payment is proceeding, it can take up to $x seconds. Please wait.';
  }

  @override
  String get payment_proceeding_can_take_longer => 'Your payment is proceeding, it can take longer than usual due to busy traffic network. Please wait.';

  @override
  String get payment_completed => 'Payment Completed';

  @override
  String payment_completed_brought_back_3rdapp(Object x) {
    return 'Your payment completed successfully, you will be brought back to [3rd party app name] in $x seconds';
  }

  @override
  String get payment_completed_successfully => 'Your payment completed successfully.';

  @override
  String get payment_failed => 'Payment Failed';

  @override
  String payment_failed_brought_back_3rdapp(Object x) {
    return 'Your payment is failed, you will be brought back to [3rd party app name] in $x seconds';
  }

  @override
  String get unfortunately_payment_failed => 'Unfortunately, your payment is failed.';

  @override
  String get you_are_about_to_deposit => 'You are about to deposit amount of';

  @override
  String get go_home => 'Go Home';

  @override
  String get enter_transfer_amount => 'Enter Transfer Amount';

  @override
  String get merchant_client => 'Merchant Client';

  @override
  String get transfer_amount => 'Transfer amount';

  @override
  String get note_optional => 'Note (optional)';

  @override
  String get add_note => 'Add Note';

  @override
  String get note => 'Note';

  @override
  String get write_your_note => 'Write your note...';

  @override
  String get please_select_token_to_transfer => 'Please select a token that you would like to transfer to merchant client';

  @override
  String get please_select_token_to_deposit => 'Please select a token that you would like to deposit';

  @override
  String get exchange_rate_will_be_refreshed_after => 'Exchange rate will be refreshed after';

  @override
  String get select_currency => 'Select Currency';

  @override
  String get exchange_rate => 'Exchange Rate';

  @override
  String get you_will_transfer => 'You will transfer';

  @override
  String get tap_to_add => 'Tap to Add';

  @override
  String get select_token => 'Select Token';

  @override
  String get insufficient_balance_to_use_token => 'Insufficient balance to use this token for transfer';

  @override
  String get invalid_exchange_rate => 'Invalid exchange rate';

  @override
  String get coming_soon => 'Coming Soon';

  @override
  String get view_transaction_detail => 'View Transaction Detail';

  @override
  String get please_try_again => 'Please try again.';

  @override
  String allow_this_app_transfer(Object x) {
    return 'Allow this app transfer up to $x on your behalf?';
  }

  @override
  String get duration_of_approve_request => 'Duration of approve request process may take time. Please be patient and wait while it’s being processed.';

  @override
  String get approve_request => 'Approve Request';

  @override
  String get failed_to_approve_deposit => 'Failed to approve deposit';

  @override
  String get from => 'From';

  @override
  String get approve_request_pending => 'Approve Request Pending';

  @override
  String get approve_request_pending_desc => 'An approve request transaction is being processed. We recommend you wait until its process finishes or if you want to send another approve request, you will have to  pay another transaction fee.';

  @override
  String get send_another_request => 'Send Another Request';

  @override
  String get keep_waiting => 'Keep Waiting';
}
