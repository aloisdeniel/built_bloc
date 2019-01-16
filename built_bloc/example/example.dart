import 'dart:async';

import 'package:built_bloc/built_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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

/// This example would produce the same bloc as [ExampleBloc] but
/// is based on 'built_bloc_generator' instead.
@bloc
class _GeneratedExampleBloc extends Bloc {
  @sink
  PublishSubject<int> get add => fromPublish(onData: (int value) {
        this.count.add(this.count.value + 1);
      });

  @stream
  BehaviorSubject<int> get count => fromBehavior(0);
}

/// As a comparison, here would have been the class written with
/// pure vanilla code.
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
