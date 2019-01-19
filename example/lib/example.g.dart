// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _$ExampleBloc extends _ExampleBloc {
  _$ExampleBloc() : super() {
    this._countSubject = super.count;
    this.subjects.add(this._countSubject);
    this._addSubject = super.add;
    this.subjects.add(this._addSubject);
    this._resetSubject = super.reset;
    this.subjects.add(this._resetSubject);
  }

  BehaviorSubject<int> _countSubject;

  PublishSubject<int> _addSubject;

  PublishSubject<void> _resetSubject;

  @override
  get count => this._countSubject;
  @override
  get add => this._addSubject;
  @override
  get reset => this._resetSubject;
}

class ExampleBloc extends Bloc {
  ExampleBloc() : this._internal = _$ExampleBloc();

  final _$ExampleBloc _internal;

  Stream<dynamic> get direct => this._internal.direct;
  Stream<int> get count => this._internal.count.stream;
  Sink<int> get add => this._internal.add.sink;
  Sink<void> get reset => this._internal.reset.sink;
  @override
  dispose() {
    super.dispose();
    this._internal.dispose();
  }

  Map<String, dynamic> get metadata => {
        "title": "ExampleBloc",
        "sinks": {"add": add, "reset": reset},
        "streams": {"direct": direct, "count": count},
      };
}
