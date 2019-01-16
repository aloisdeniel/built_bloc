# built_bloc

Helper class for adopting the BLoC pattern, alongside with a few annotations to use in combination with [built_bloc_generator](https://github.com/aloisdeniel/built_bloc/built_bloc_generator) (**which is stongly recommended**).

## Quickstart

Simply extends from `Bloc` and access various helpers for registering subjects (like `addPublish`, `addBehavior`) and the `dispose` method which will close all underlying subscriptions.

```dart
class ExampleBloc extends Bloc {
  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._add.stream;

  PublishSubject<int> _add;

  BehaviorSubject<int> _count;

  ExampleBloc() {
    this._add = addPublish(onData: _onAdd);
    this._count = addBehavior(0);
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