# built_bloc (in active development)

Generate the BLoC pattern boilerplate.

## Quickstart

In order to generate your bloc, you first have to declare a private class that should extends `Bloc` and be annotated with `@bloc`.

Then declare getters that describe and register your subjects (from rxdart). Several helpers are available in the `Bloc` class, like `addBehavior` and `addPublish` shorcuts.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  BehaviorSubject<int> get count => addBehavior(0);

  @sink
  PublishSubject<int> get add => addPublish(onData: (int value) {
    this.count.add(this.count.value);
  });
}
```

This `_ExampleBloc` class will generate an `ExampleBloc` class that can be later used like a typical bloc.

Here is the current result :

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _$ExampleBloc extends _ExampleBloc {
  _$ExampleBloc() : super() {}

  BehaviorSubject _countSubject;

  PublishSubject _addSubject;

  @override
  get count {
    if (this._countSubject == null) {
      this._countSubject = super.count;
    }
    return this._countSubject;
  }

  @override
  get add {
    if (this._addSubject == null) {
      this._addSubject = super.add;
    }
    return this._addSubject;
  }
}

class ExampleBloc extends Bloc {
  ExampleBloc() : this._internal = _$ExampleBloc();

  final _$ExampleBloc _internal;

  Stream<int> get count => this._internal.count.stream;
  Sink<int> get add => this._internal.add.sink;
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