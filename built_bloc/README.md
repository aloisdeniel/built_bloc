# built_bloc

Helper class for adopting the [BLoC pattern](https://medium.com/flutter-io/build-reactive-mobile-apps-in-flutter-companion-article-13950959e381), alongside with a few annotations to use in combination with [built_bloc_generator](https://github.com/aloisdeniel/built_bloc/built_bloc_generator) (**which is stongly recommended**).

## Quickstart

Simply extends from `Bloc` and add your `subjects` and `subscriptions`.

```dart
class ExampleBloc extends Bloc {
  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._add.stream;

  final PublishSubject<int> _add = PublishSubject<int>();

  final BehaviorSubject<int> _count = BehaviorSubject<int>(seedValue: 0);

  ExampleBloc() {
    this.subjects.addAll([_add, _count]);
    this.subscriptions.addAll([ _add.listen(_onAdd) ]);
  }

  void _onAdd(int value) {
    this._count.add(this._count.value + 1);
  }
}
```

## How to use

### Install

```yaml
dependencies:
  built_bloc:
```