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

### Custom names

To control how sink and stream properties are generated you can specify names by using `@BlocStream("custom") / @BlocSink("custom")` instead of `@stream/@sink`.

### Both `Sink` and `Stream`

If you want that your subject export both a `Sink` and a `Stream`, you can add two annotations on you unique property.

By default, you sink will be renamed `update<name>`.

### External listen

By default, all `Listen` marked subscriptions aren't added to the `subscriptions` bloc's list since they are cancelled when their subject is closed.

If you want your subscription to be added to the `subscriptions` bloc list, you can set the `external` constructor parameter to `true` (`@Listen("_reset", external: true)`).

### Run the generator

To run the generator, you must use `build_runner` cli:

```sh
flutter pub pub run build_runner watch
```