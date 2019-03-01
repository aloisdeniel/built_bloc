# built_bloc_generator

Generate the [BLoC pattern](https://medium.com/flutter-io/build-reactive-mobile-apps-in-flutter-companion-article-13950959e381) boilerplate.

## Quickstart

In order to generate your bloc, your class must extend `Bloc`, be annotated with `@bloc` and with a mixin named `_<class name>`.

Then declare your [subject fields](https://github.com/ReactiveX/rxdart)  and annotate them with `@stream` or `@sink` to generate a public getter accordingly. 

You can also subscribe to a subject with the `Bind` annotation.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class ExampleBloc extends Bloc with _ExampleBloc {
  @stream
  final BehaviorSubject<int> _count = BehaviorSubject<int>.seeded(0);

  @sink
  @Bind("_onAdd")
  final PublishSubject<int> _add = PublishSubject<int>();

  @sink
  @Bind("_onReset")
  final PublishSubject<void> _reset = PublishSubject<void>();

  void _onAdd(int value) {
    this._count.add(this._count.value + value);
  }

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

To control how sink and stream getters are generated you can specify names by using `@BlocStream("custom") / @BlocSink("custom")` instead of `@stream/@sink`.

### Both `Sink` and `Stream`

If you want that a subject to be both exported sa `Sink` and `Stream`, you can add two annotations on a unique property.

By default, you sink will be renamed `update<name>`.

### Run the generator

To run the generator, you must use `build_runner` cli:

```sh
flutter pub pub run build_runner watch
```