import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewmodel/base/broadcast_stream_controller.dart';
import 'package:viewmodel/widget/snapshot.dart';

class SnapshotBuilder<T> extends StatelessWidget {
  final BroadcastStream<T> broadcast;
  final T? initialData;
  final Widget Function(T) child;
  final Widget Function(dynamic)? onError;
  final Widget? onLoading;
  final bool isAnimated;
  final Duration _animationDuration = const Duration(milliseconds: 400);
  final Duration? animationDuration;
  const SnapshotBuilder({
    Key? key,
    required this.broadcast,
    required this.child,
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
      builder: (context, snapshot) => Snapshot<T>(
        snapshot,
        onData: child,
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
