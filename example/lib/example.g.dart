// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _$ExampleBloc extends _ExampleBloc {
  _$ExampleBloc() : super() {}

  BehaviorSubject _countSubject;

  PublishSubject _addSubject;

  PublishSubject _resetSubject;

  @override
  get count {
    if (this._countSubject == null) {
      this._countSubject = super.count;
    }
    return this._countSubject;
  }

  @override
  get add {
    if (this._addSubject == null) {
      this._addSubject = super.add;
    }
    return this._addSubject;
  }

  @override
  get reset {
    if (this._resetSubject == null) {
      this._resetSubject = super.reset;
    }
    return this._resetSubject;
  }
}

class ExampleBloc extends Bloc {
  ExampleBloc() : this._internal = _$ExampleBloc();

  final _$ExampleBloc _internal;

  Stream<int> get count => this._internal.count.stream;
  Sink<int> get add => this._internal.add.sink;
  Sink<void> get reset => this._internal.reset.sink;
  @override
  dispose() {
    super.dispose();
    this._internal.dispose();
  }
}
