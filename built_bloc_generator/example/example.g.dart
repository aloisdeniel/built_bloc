// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class _ExampleBloc implements GeneratedBloc<ExampleBloc> {
  ExampleBloc _parent;

  Stream<int> get count => _parent._count.stream;
  Sink<int> get add => this._parent._add.sink;
  Sink<void> get reset => this._parent._reset.sink;
  @override
  void subscribeParent(ExampleBloc value) {
    this._parent = value;
    value.subjects.add(value._count);
    value.subjects.add(value._add);
    value.subjects.add(value._reset);
    value.subscriptions.add(this._parent._add.listen(value._onAdd));
    value.subscriptions.add(this._parent._reset.listen((_) => value._onReset));
  }
}
