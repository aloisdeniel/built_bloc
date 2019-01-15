// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _$ExampleBloc extends _ExampleBloc {
  _$ExampleBloc() : super() {
    this.subscribeSubject(this._addSubject, onData: this.add);
    this.subscribeSubject(this._resetSubject, onData: (_) => this.reset());
    this.subscribeSubject(this.count2);
    this.subscribeSubject(this._countSubject);
  }

  final PublishSubject<int> _addSubject = PublishSubject<int>(sync: true);

  final PublishSubject<void> _resetSubject = PublishSubject<void>(sync: true);

  final BehaviorSubject<int> _countSubject = BehaviorSubject<int>(
    sync: true,
  );

  @override
  int get count => _countSubject.value;
  @override
  set count(int newValue) => _countSubject.add(newValue);
}

class ExampleBloc extends Bloc {
  ExampleBloc() : this._internal = _$ExampleBloc();

  final _$ExampleBloc _internal;

  Sink<int> get add => this._internal._addSubject.sink;
  Sink<void> get reset => this._internal._resetSubject.sink;
  Stream<int> get count2 => this._internal.count2.stream;
  Stream<int> get count => this._internal._countSubject.stream;
  @override
  dispose() {
    super.dispose();
    this._internal.dispose();
  }
}
