import 'tchain_payment_localizations.dart';

/// The translations for Indonesian (`id`).
class TChainPaymentLocalizationsId extends TChainPaymentLocalizations {
  TChainPaymentLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get invalid_code => 'Kode tidak valid';

  @override
  String get something_went_wrong_please_try_later => 'Ada sesuatu yang tidak beres, silakan coba lagi nanti';

  @override
  String get you_are_not_enough_bnb => 'BNB Anda tidak cukup untuk mengirim transaksi';

  @override
  String get the_selected_wallet_supports_eth_network_please_select_another_one => 'Dompet yang dipilih hanya mendukung jaringan ETH, silakan pilih dompet yang mendukung jaringan BNB Smart Chain untuk menggunakan fitur ini.';

  @override
  String get done => 'Selesai';

  @override
  String get retry => 'Coba Kembali';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Batalkan';

  @override
  String get our_policy => 'our policy';

  @override
  String get next => 'Next';

  @override
  String get btn_continue => 'Lanjutkan';

  @override
  String get submit => 'Submit';

  @override
  String get blocks => 'Blok';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get you_will_pay => 'Kamu Akan Membayar';

  @override
  String get payment_confirmation => 'Konfirmasi pembayaran';

  @override
  String get select_coin_type_to_pay => 'Pilih tipe koin yang ingin Anda bayar';

  @override
  String get payment_status => 'Status Pembayaran';

  @override
  String get payment_amount => 'Jumlah Pembayaran';

  @override
  String get deposit_amount => 'Jumlah Deposit';

  @override
  String get deposit_confirmation => 'Konfirmasi Deposit';

  @override
  String get select_coin_type_to_deposit => 'Pilih tipe koin yang ingin Anda depositkan';

  @override
  String get balance => 'Saldo';

  @override
  String get coin_type => 'Tipe Koin';

  @override
  String get select_coin_type => 'Pilih Tipe Koin';

  @override
  String your_balance_is_not_enough(Object x) {
    return 'Saldo Anda tidak cukup $x untuk melakukan pembayaran';
  }

  @override
  String get and => 'dan';

  @override
  String get transaction_fee => 'Biaya Transaksi';

  @override
  String get pay_toko_amount => 'Jumlah Toko yang Dibayar';

  @override
  String get service_fee => 'Biaya Layanan';

  @override
  String x_discount_applied(Object x) {
    return '(Diskon $x% digunakan)';
  }

  @override
  String get use_toko_pay => 'Bayar ';

  @override
  String get use_toko_to_get => ' untuk mendapatkan ';

  @override
  String get use_toko_of_service_fee => ' dari biaya layanan (Saldo: ';

  @override
  String get discount => 'diskon';

  @override
  String get unable_to_apply_discount => 'Tidak Dapat Menggunakan Diskon';

  @override
  String unable_to_apply_discount_desc(Object x, Object y) {
    return 'Kamu tidak punya cukup TOKO (TOKO yang tersedia: $x) untuk mendapatkan diskon $y% dari biaya layanan. Silakan depositkan lebih banyak TOKO ke saldo Anda terlebih dahulu dan proses pembayaran kembali.';
  }

  @override
  String get deposit => 'Deposit';

  @override
  String get deposit_payment_status => 'Status Pembayaran Deposit';

  @override
  String get payment_proceeding => 'Pembayaran Diproses';

  @override
  String payment_proceeding_brought_back_3rdapp(Object x) {
    return 'Pembayaran Anda sedang diproses, Anda akan dibawa kembali ke [nama aplikasi pihak ketiga] dalam $x detik';
  }

  @override
  String payment_proceeding_can_take_up(Object x) {
    return 'Pembayaran Anda sedang diproses, bisa memakan waktu hingga $x detik. Mohon tunggu.';
  }

  @override
  String get payment_proceeding_can_take_longer => 'Pembayaran Anda sedang diproses, dapat memakan waktu lebih lama dari biasanya karena lalu lintas jaringan yang sibuk. Mohon tunggu.';

  @override
  String get payment_completed => 'Pembayaran Selesai';

  @override
  String payment_completed_brought_back_3rdapp(Object x) {
    return 'Pembayaran Anda berhasil diselesaikan, Anda akan dibawa kembali ke [3rd party app name] dalam $x detik';
  }

  @override
  String get payment_completed_successfully => 'Pembayaran Anda berhasil diselesaikan.';

  @override
  String get payment_failed => 'Pembayaran Gagal';

  @override
  String payment_failed_brought_back_3rdapp(Object x) {
    return 'Pembayaran Anda gagal, Anda akan dibawa kembali ke [nama aplikasi pihak ketiga] dalam $x detik';
  }

  @override
  String get unfortunately_payment_failed => 'Sayangnya, pembayaran Anda gagal.';

  @override
  String get you_are_about_to_deposit => 'Anda akan mendepostikan sejumlah';

  @override
  String get go_home => 'Akses Beranda';

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
  String get coming_soon => 'Segera Hadir';

  @override
  String get view_transaction_detail => 'View Transaction Detail';

  @override
  String get please_try_again => 'Silahkan coba lagi';

  @override
  String allow_this_app_transfer(Object x) {
    return 'Allow this app transfer up to $x on your behalf?';
  }

  @override
  String get duration_of_approve_request => 'Durasi proses permintaan persetujuan mungkin membutuhkan waktu. Harap bersabar dan tunggu saat sedang diproses.';

  @override
  String get approve_request => 'Permintaan Persetujuan';

  @override
  String get failed_to_approve_deposit => 'Gagal menyetujui deposit';

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

  @override
  String get by_clicking_confirm_you_understood_and_agreed_to => 'By clicking “Confirm”, you understood and agreed to ';
}
