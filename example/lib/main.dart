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
}
