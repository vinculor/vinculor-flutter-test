import 'dart:async';

abstract class ReadableEmitter<T> {
  Stream<T> get stream;
  T get value;
}

abstract class CachedEmitter {
  Duration? get cacheDuration;
  DateTime? get lastFetchedAt;
  void clear();
}

class Emitter<T> implements ReadableEmitter<T> {
  final _controller = StreamController<T>.broadcast();

  @override
  Stream<T> get stream => _controller.stream;

  final T _initialValue;
  T _value;
  @override
  T get value => _value;
  set value(T value) {
    _value = value;

    _raise(value);
  }

  Emitter({required T initialValue})
      : _initialValue = initialValue,
        _value = initialValue;

  void _raise(T value) {
    _controller.add(value);
  }

  void raise() => _raise(value);

  void clear() {
    value = _initialValue;
  }
}
