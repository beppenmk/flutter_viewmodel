import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vm/widget/snapshot_builder.dart';

import '../viewmodel/counter_viewmodel.dart';

class FutureIncrementWidget extends StatelessWidget {
  FutureIncrementWidget({Key? key}) : super(key: key);

  int _counter = 0;
  final CounterViewModel vm = CounterViewModel();

  void _incrementCounter() {
    vm.increment(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FUTURE WIDGET"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            SnapshotBuilder<int>(
              broadcast: vm.number,
              initialData: 10,
              onData: (value) {
                _counter = value;
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),

            /*
            SnapshotBuilder<int>(
              broadcast: vm.number,
              initialData: 20,
              child: (value) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
           */
            /*
            SnapshotBuilder<int>(
              broadcast: vm.number,
              isAnimated: false,
              child: (value) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            */
            /*
            SnapshotBuilder<int>(
              broadcast: vm.number,
              onLoading: Container(
                width: 10,
                height: 10,
                color: Colors.red,
              ),
              onError: (e) => Text(e.toString()),
              animationDuration: const Duration(milliseconds: 2000),
              child: (value) => Text(
                '$value',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
             */
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
