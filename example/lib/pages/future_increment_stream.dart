import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../viewmodel/counter_viewmodel.dart';

class FutureIncrementStream extends StatefulWidget {
  const FutureIncrementStream({Key? key}) : super(key: key);

  @override
  State<FutureIncrementStream> createState() => _FutureIncrementStreamState();
}

class _FutureIncrementStreamState extends State<FutureIncrementStream> {
  int _counter = 0;
  CounterViewModel vm = CounterViewModel();

  @override
  void initState() {
    vm.number.stream?.listen((value) {
      setState(() {
        _counter = value;
      });
    });

    super.initState();
  }

  void _incrementCounter() {
    vm.increment(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FUTURE STREAM"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
