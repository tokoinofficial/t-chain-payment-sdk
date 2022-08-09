import 'package:example/data/product.dart';
import 'package:flutter/material.dart';
import 'package:tk_payment_gateway/tk_payment_gateway.dart';

void main() {
  runApp(const MyApp());
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
  num _amount = 0;

  final List<Product> products = [
    const Product(
      id: 'ID_ITEM_1',
      name: 'Buy 1000 KNB (game currency)',
      price: 100,
    ),
    const Product(
      id: 'ID_ITEM_2',
      name: 'Buy 5000 KNB (game currency)',
      price: 450,
    ),
  ];

  final List<Product> withdrawalPackages = [
    const Product(
      id: 'ID_1',
      name: 'Claim \$100',
      price: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();

    TWPaymentSDK.instance.init(
      merchantID: 'merchantID',
      bundleID: 'com.example.example',
      delegate: _onHandlePaymentResult,
    );
  }

  @override
  void dispose() {
    TWPaymentSDK.instance.close();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _amount++;
    });
  }

  _onHandlePaymentResult(TWPaymentResult result) {
    _showResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...products.map(
              (e) {
                return _buildItem(
                  itemName: e.name,
                  itemId: e.id,
                  itemPrice: e.price,
                  onTap: () => _buyProduct(e),
                );
              },
            ),
            ...withdrawalPackages.map(
              (e) {
                return _buildItem(
                  itemName: e.name,
                  itemId: e.id,
                  itemPrice: e.price,
                  onTap: () => _claim(e),
                );
              },
            ),
            const Divider(),
            const Text(
              'Amount to send:',
            ),
            const SizedBox(height: 10),
            Text(
              '$_amount',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10),
            TWPaymentButton(
              action: TWPaymentAction.deposit,
              amount: _amount.toDouble(),
              onResult: (result) => _showResult(result),
            ),
            const SizedBox(height: 10),
            TWPaymentButton(
              action: TWPaymentAction.withdraw,
              amount: _amount.toDouble(),
              onResult: (result) => _showResult(result),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildItem({
    required String itemName,
    required String itemId,
    required double itemPrice,
    Function()? onTap,
  }) {
    return ListTile(
      title: Text(itemName),
      subtitle: Text(itemId),
      trailing: Text('\$${itemPrice.toString()}'),
      onTap: onTap,
    );
  }

  _buyProduct(Product product) async {
    final result = await TWPaymentSDK.instance.purchase(
      orderID: product.id,
      amount: product.price,
    );

    _showResult(result);
  }

  _claim(Product product) async {
    final result = await TWPaymentSDK.instance.withdraw(
      orderID: product.id,
      amount: product.price,
    );

    _showResult(result);
  }

  _showResult(TWPaymentResult result) {
    switch (result.status) {
      case TWPaymentResultStatus.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed')),
        );
        break;

      case TWPaymentResultStatus.waiting:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('waiting')),
        );
        break;

      case TWPaymentResultStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('success ${result.transactionID ?? ''}')),
        );
        break;
      case TWPaymentResultStatus.operationInProgress:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('operationInProgress')),
        );
        break;
      case TWPaymentResultStatus.cancelled:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('cancelled')),
        );
        break;
    }
  }
}
