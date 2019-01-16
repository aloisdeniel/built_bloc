# built_bloc (in active development)

Generate the BLoC pattern boilerplate.

## Why ?

After using the [BLoC pattern](https://medium.com/flutter-io/build-reactive-mobile-apps-in-flutter-companion-article-13950959e381) a little, it seems pretty cool for sharing code and separation of concerns, but I quickly found myself to write a **lot of repetitive boilerplate code** : I felt the need for a generator to assist me.

Here is a simple vanilla bloc example which obviously highlights repeated patterns while declaring subjects, streams, sinks and subscriptions.

```dart
class VanillaExampleBloc {

  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._add.stream;

  final PublishSubject<int> _add = PublishSubject<int>(sync: true);

  final BehaviorSubject<int> _count = BehaviorSubject<int>(sync: true, seedValue: 0);

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  VanillaExampleBloc() {
    subscriptions = [
      this._add.listen(_onAdd),
    ];
    subjects = [
      this._add,
      this._count,
    ];
  }

  void _onAdd(int value) {
    this._count.add(this._count.value + 1);
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
class _GeneratedExampleBloc extends Bloc {
  @sink
  PublishSubject<int> get add => fromPublish(onData: this._onAdd);

  @stream
  BehaviorSubject<int> get count => fromBehavior(0);

  void _onAdd(int value) {
    this._count.add(this._count.value + 1);
  }
}
```