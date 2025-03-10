import 'dart:async';

import 'package:test_app_flutter/emitter/emitter.dart';

class FilteredEmitter<T> implements ReadableEmitter<T> {
  final ReadableEmitter<T> source;
  final _controller = StreamController<T>.broadcast();

  @override
  Stream<T> get stream => _controller.stream;

  T _value;
  @override
  T get value => _value;

  FilteredEmitter({required this.source, required T Function(T value) filter}) : _value = filter(source.value) {
    source.stream.listen((value) {
      _value = filter(value);
      _raise(_value);
    });
  }

  void _raise(T value) {
    _controller.add(value);
  }
}
