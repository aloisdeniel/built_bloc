# built_bloc (in active development)

Generate the BLoC pattern boilerplate.

## Quickstart

Declare a new bloc by annotating a private class with `@bloc`. Each property can then be declared as a `@stream` or `@sink` to generate all the associated boilerplate code.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  final BehaviorSubject<int> count2 = BehaviorSubject<int>(sync: true, seedValue: 0);

  @stream
  int count = 0;

  @sink
  void add(int value) {
    print("Add: $value");
    this.count += value;
  }

  @sink
  void reset() {
    this.count = 0;
  }
}
```

This `_ExampleBloc` class will generate an `ExampleBloc` class that can be later used like a typical bloc.

It is responsible for :

* Exposing `Sinks` and `Steams` for each annotated elements
* Disposing underlying subjects and subscriptions declared this way

Here is the current result :

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _$ExampleBloc extends _ExampleBloc {
  _$ExampleBloc() : super() {
    this.subscribeSubject(this._addSubject, onData: this.add);
    this.subscribeSubject(this._resetSubject, onData: (_) => this.reset());
    this.subscribeSubject(this.count2);
    this.subscribeSubject(this._countSubject);
  }

  final PublishSubject<int> _addSubject = PublishSubject<int>(sync: true);

  final PublishSubject<void> _resetSubject = PublishSubject<void>(sync: true);

  final BehaviorSubject<int> _countSubject = BehaviorSubject<int>(
    sync: true,
    seedValue: 0,
  );

  @override
  int get count => _countSubject.value;
  @override
  set count(int newValue) => _countSubject.add(newValue);
}

class ExampleBloc extends Bloc {
  ExampleBloc() : this._internal = _$ExampleBloc();

  final _$ExampleBloc _internal;

  Sink<int> get add => this._internal._addSubject.sink;
  Sink<void> get reset => this._internal._resetSubject.sink;
  Stream<int> get count2 => this._internal.count2.stream;
  Stream<int> get count => this._internal._countSubject.stream;
  @override
  dispose() {
    super.dispose();
    this._internal.dispose();
  }
}
```

## How to use

### Install

There are a few separate packages you need to install:

```yaml
dependencies:
  built_bloc:

dev_dependencies:
  built_bloc_generator: 
  build_runner: 
```

### Run the generator

To run the generator, you must use `build_runner` cli:

```sh
flutter pub pub run build_runner watch
```