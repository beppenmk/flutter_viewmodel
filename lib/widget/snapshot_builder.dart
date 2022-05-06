import 'package:flutter/material.dart';
import 'package:flutter_vm/vm.dart';

///
///This widget helps you to use ViewModel data in your UI
///You can pass widget to execute when receiving data or error or when loading.
///You can set if show animation when state changes and set the duration
///

class SnapshotBuilder<T> extends StatelessWidget {
  final BroadcastStream<T> broadcast;
  final T? initialData;
  final Widget Function(T) onData;
  final Widget Function(dynamic)? onError;
  final Widget? onLoading;
  final bool isAnimated;
  final Duration _animationDuration = const Duration(milliseconds: 400);
  final Duration? animationDuration;

  const SnapshotBuilder({
    Key? key,
    required this.broadcast,
    required this.onData,
    this.onLoading,
    this.onError,
    this.initialData,
    this.animationDuration,
    this.isAnimated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: broadcast.stream,
      initialData: initialData,
      builder: (context, snapshot) => _Snapshot<T>(
        snapshot,
        onData: onData,
        onError: onError,
        onLoading: onLoading,
        isAnimated: isAnimated,
        animationDuration: (animationDuration != null)
            ? animationDuration!
            : _animationDuration,
      ),
    );
  }
}

class _Snapshot<T> extends StatefulWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T)? onData;
  final Widget Function(dynamic)? onError;
  final Widget? onLoading;
  final bool isAnimated;
  final Duration animationDuration;

  const _Snapshot(
    this.snapshot, {
    Key? key,
    required this.onData,
    this.onLoading,
    this.onError,
    required this.isAnimated,
    required this.animationDuration,
  }) : super(key: key);

  @override
  _SnapshotState<T> createState() => _SnapshotState();
}

class _SnapshotState<T> extends State<_Snapshot<T>> {
  ValueNotifier<AsyncSnapshot<T>>? _state;
  final Key _loaded = UniqueKey();
  final Key _load = UniqueKey();

  @override
  void initState() {
    _state = ValueNotifier<AsyncSnapshot<T>>(widget.snapshot);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _state?.value = widget.snapshot;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _Snapshot<T> oldWidget) {
    _state?.value = widget.snapshot;
    super.didUpdateWidget(oldWidget);
  }

  Widget _getLoader() {
    if (widget.onLoading != null) {
      return widget.onLoading!;
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncSnapshot<T>>(
      valueListenable: _state!,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot, _) {
        if (snapshot.hasError) {
          if (widget.onError != null) {
            return widget.onError!(snapshot.error!);
          }
          return Container(
            color: Colors.transparent,
          );
        }

        if (widget.isAnimated) {
          return AnimatedSwitcher(
            duration: widget.animationDuration,
            child: (snapshot.hasData && widget.onData != null)
                ? Container(
                    key: _loaded,
                    child: widget.onData!(snapshot.data!),
                  )
                : Container(
                    key: _load,
                    child: _getLoader(),
                  ),
          );
        } else {
          if (snapshot.hasData && widget.onData != null) {
            return widget.onData!(snapshot.data!);
          } else {
            return _getLoader();
          }
        }
      },
    );
  }
}
