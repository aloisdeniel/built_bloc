import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class ExampleBloc extends Bloc with _ExampleBloc {
  @stream
  final BehaviorSubject<int> _count = BehaviorSubject<int>(seedValue: 0);

  @sink
  @Bind("_onAdd")
  final PublishSubject<int> _add = PublishSubject<int>(); 

  @sink
  @Bind("_onReset")
  final PublishSubject<void> _reset = PublishSubject<void>();

  void _onAdd(int value) {
    this._count.add(this._count.value + value);
  }

  void _onReset() {
    this._count.add(0);
  }
}