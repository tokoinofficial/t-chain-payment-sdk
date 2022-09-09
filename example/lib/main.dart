import 'package:example/cubit/fcm/fcm_bloc.dart';
import 'package:example/cubit/fcm/fcm_states.dart';
import 'package:example/data/product.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider<FcmCubit>(
    create: (context) => FcmCubit(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = '';
  String txn = '';
  String merchantID = '0xc3f2f0deaf2a9e4d20aae37e8802b1efef589d1a9e45e89ce1a2e179516df071';
  String bundleID = 'com.example.example';

  final List<Product> products = [
    const Product(
      id: 'ID_1',
      name: 'Package 1 (Buy 2 game coins)',
      description: '\$2',
      price: 2,
    ),
  ];

  final List<Product> withdrawalPackages = [
    const Product(
      id: 'ID_3',
      name: 'Claim \$10',
      description: '',
      price: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<FcmCubit>().initialFcm();

    TChainPaymentSDK.instance.init(
      merchantID: merchantID,
      bundleID: bundleID,
      delegate: _onHandlePaymentResult,
    );
  }

  @override
  void dispose() {
    TChainPaymentSDK.instance.close();
    super.dispose();
  }

  _onHandlePaymentResult(TChainPaymentResult result) {
    _showResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FcmCubit, FcmState>(
        listener: (context, state) {
          if (state is FcmMessageReceived) {
            _showResult(state.fcmNotification.result!);
            Fluttertoast.showToast(msg: 'Received new notification!');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('merchant ID: $merchantID'),
                  const SizedBox(height: 16),
                  const Text('status'),
                  Text(
                    status,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('txn'),
                  InkWell(
                    onTap: () =>
                        Clipboard.setData(ClipboardData(text: 'https://testnet.bscscan.com/tx/$txn')),
                    child: Text(
                      txn,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  ...products.map(
                    (e) {
                      return _buildItem(
                        itemName: e.name,
                        itemDescription: e.description,
                        itemId: e.id,
                        onTap: () => _buyProduct(e),
                      );
                    },
                  ),
                  ...withdrawalPackages.map(
                    (e) {
                      return _buildItem(
                        itemName: e.name,
                        itemDescription: e.description,
                        itemId: e.id,
                        onTap: () => _claim(e),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildItem({
    required String itemName,
    required String itemDescription,
    required String itemId,
    Function()? onTap,
  }) {
    return ListTile(
      title: Text(itemName),
      subtitle: Text(itemId),
      trailing: Text(itemDescription),
      onTap: onTap,
    );
  }

  _buyProduct(Product product) async {
    final result = await TChainPaymentSDK.instance.deposit(
      orderID: product.id,
      amount: product.price,
    );

    _showResult(result);
  }

  _claim(Product product) async {
    final result = await TChainPaymentSDK.instance.withdraw(
      orderID: product.id,
      amount: product.price,
    );

    _showResult(result);
  }

  _showResult(TChainPaymentResult result) {
    setState(() {
      status = result.status.name;
      txn = result.transactionID ?? '';
    });

    if (result.status == TChainPaymentStatus.error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(result.errorMessage ?? 'Unknown'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
