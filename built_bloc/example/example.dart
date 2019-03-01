import 'dart:async';

import 'package:built_bloc/built_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ExampleBloc extends Bloc {
  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._add.stream;

  final PublishSubject<int> _add = PublishSubject<int>();

  final BehaviorSubject<int> _count = BehaviorSubject<int>.seeded(0);

  ExampleBloc() {
    this.subjects.addAll([_add, _count]);
    this.subscriptions.addAll([ _add.listen(_onAdd) ]);
  }

  void _onAdd(int value) {
    this._count.add(this._count.value + 1);
  }
}

/// As a comparison, here would have been the class written with
/// pure vanilla code.
class VanillaExampleBloc {

  Sink<int> get add => this._add.sink;

  Stream<int> get count => this._add.stream;

  final PublishSubject<int> _add = PublishSubject<int>(sync: true);

  final BehaviorSubject<int> _count = BehaviorSubject<int>.seeded(0, sync: true);

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
