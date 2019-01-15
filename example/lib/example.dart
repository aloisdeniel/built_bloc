import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  final BehaviorSubject<int> count2 = BehaviorSubject<int>(sync: true, seedValue: 0);

  @stream
  int count = 0;

  @sink
  void add(int value) {
    print("Add: $value");
    this.count += value;
  }

  @sink
  void reset() {
    this.count = 0;
  }
}


/*
@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc()
      : this.count2 = BehaviorSubject<int>(seedValue: 0, sync: true),
        this.add2 = PublishSubject<int>();

  // Stream examples

  @BlocStream(seedValue: 0)
  BehaviorSubject<int> get count;

  @BlocStream() // Self managed initialization;
  final BehaviorSubject<int> count2;

  @BlocStream(seedValue: 0)
  int get count3;
  void set count3(int value);

  // Sink examples

  @sink
  PublishSubject<int> get add;

  @sink // Self managed initialization;
  final PublishSubject<int> add2;

  @sink
  void add3(int value) {
    print("Add: $value");
  }

  @sink
  void update() {
    print("Update!");
  }
}

// Expected generated target
class TExampleBloc extends Bloc {
  final _$TExampleBloc _internal = _$TExampleBloc();

  Sink<int> get add => this._internal._addSubject.sink;

  Sink<int> get add2 => this._internal.add2.sink;

  Sink<int> get add3 => this._internal._add3Subject.sink;

  Sink<void> get update => this._internal._updateSubject.sink;

  @override
  void dispose() {
    super.dispose();
    this._internal.dispose();
  }
}

class _$TExampleBloc extends _ExampleBloc {
  _$TExampleBloc()
      : this._countSubject = BehaviorSubject<int>(seedValue: 0, sync: true),
        this._count3Subject = BehaviorSubject<int>(seedValue: 0, sync: true),
        this._addSubject = PublishSubject<int>(sync: true),
        this._add3Subject = PublishSubject<int>(sync: true),
        this._updateSubject = PublishSubject<void>(sync: true) {
    this.subscribeSubject(this._countSubject);
    this.subscribeSubject(this.count2);
    this.subscribeSubject(this._count3Subject);
    this.subscribeSubject(this._addSubject);
    this.subscribeSubject(this.add2);
    this.subscribeSubject(this._add3Subject, onData: this.add3);
    this.subscribeSubject(this._updateSubject, onData: (_) => this.update());
  }

  @override
  PublishSubject<int> get add => this._addSubject;

  @override
  BehaviorSubject<int> get count => this._countSubject.stream;

  @override
  int get count3 => this._count3Subject.value;

  @override
  void set count3(int value) => this._count3Subject.add(value);

  final PublishSubject<int> _addSubject;
  final PublishSubject<void> _updateSubject;
  final PublishSubject<int> _add3Subject;
  final BehaviorSubject<int> _countSubject;
  final BehaviorSubject<int> _count3Subject;
}
*/