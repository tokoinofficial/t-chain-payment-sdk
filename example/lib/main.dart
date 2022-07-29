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

  @override
  void initState() {
    super.initState();

    TWPaymentSDK.instance.init(
      appID: 'appID',
      schemeCallback: 'mtwalletcallback',
    );
  }

  void _incrementCounter() {
    setState(() {
      _amount++;
    });
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
            PaymentButton(
              type: Type.sendToko,
              amount: _amount,
              env: Env.stag,
              address: '0xabc',
            ),
            const SizedBox(height: 10),
            PaymentButton(
              type: Type.buyToko,
              amount: _amount,
              env: Env.stag,
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
    final result = await TWPaymentSDK.instance.buyProduct(
      productID: product.id,
      productPrice: product.price,
    );

    switch (result.status) {
      case TWPaymentResultStatus.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed')),
        );
        break;

      case TWPaymentResultStatus.unknown:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown')),
        );
        break;
      default:
        break;
    }
  }
}
