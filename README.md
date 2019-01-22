# built_bloc 

###*(in active development)*

Generate the BLoC pattern boilerplate.

## Why ?

After using the [BLoC pattern](https://medium.com/flutter-io/build-reactive-mobile-apps-in-flutter-companion-article-13950959e381) a little, it seems pretty cool for sharing code and separation of concerns, but I quickly found myself to write a **lot of repetitive boilerplate code** : I felt the need for a generator to assist me.

Here is a simple vanilla bloc example which obviously highlights repeated patterns while declaring subjects, streams, sinks and subscriptions.

```dart
class VanillaExampleBloc {

  Sink<void> get reset => this._reset.sink;

  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._count.stream;

  final PublishSubject<int> _add = PublishSubject<int>();

  final PublishSubject<void> _reset = PublishSubject<void>();

  final BehaviorSubject<int> _count = BehaviorSubject<int>(seedValue: 0);

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  VanillaExampleBloc() {
    subscriptions = [
      this._add.listen(_onAdd),
      this._reset.listen(_onReset),
    ];
    subjects = [
      this._add,
      this._count,
      this._reset,
    ];
  }

  void _onAdd(int value) {
    this._count.add(this._count.value + value);
  }

  void _onAdd(int value) {
    this._count.add(0);
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}
```

With **built_bloc**, you can replace all of that with just a few lines of code :

```dart
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

## How to use ?

See the [built_bloc_generator](https://pub.dartlang.org/packages/built_bloc_generator) package.