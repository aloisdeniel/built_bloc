# built_bloc

Generate the BLoC pattern boilerplate.

## Quickstart

In order to generate your bloc, you first have to declare a private class that should extends `Bloc` and be annotated with `@bloc`.

Then declare getters (annotated with `@stream` or `@sink`) that describe your subjects (from [rxdart](https://github.com/ReactiveX/rxdart)). Several helpers are available in the `Bloc` class, like `fromBehavior` and `fromPublish` shorcuts.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  BehaviorSubject<int> get count => fromBehavior(0);

  @sink
  PublishSubject<int> get add => fromPublish(onData: (int value) {
    this.count.add(this.count.value);
  });
}
```

This `_ExampleBloc` class will generate an `ExampleBloc` class that can be later used like a typical bloc.

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