# built_bloc_generator

Generate the BLoC pattern boilerplate.

## Quickstart

In order to generate your bloc, you first have to declare a private class that should extends `Bloc`, be annotated with `@bloc` and with a mixin named `_<class name>`.

Then declare getters (annotated with `@stream` or `@sink`) that describe your subjects (from [rxdart](https://github.com/ReactiveX/rxdart)). 

You also subscribe to a subject with the `Listen` annotation.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class ExampleBloc extends Bloc with _ExampleBloc {
  @stream
  final BehaviorSubject<int> _count = BehaviorSubject<int>(seedValue: 0);

  @sink
  final PublishSubject<int> _add = PublishSubject<int>();

  @sink
  final PublishSubject<void> _reset = PublishSubject<void>();

  @Listen("_add")
  void _onAdd(int value) {
    this._count.add(this._count.value + value);
  }

  @Listen("_reset")
  void _onReset() {
    this._count.add(0);
  }
}
```

This `ExampleBloc` will expose your streams and sinks.

```dart
final myBloc = ExampleBloc();

myBloc.count.listen((v) {
    print("count: $v");
})

myBloc.add.add(42);

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