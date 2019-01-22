import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class ExampleBloc extends Bloc with _ExampleBloc {
  //@BlocStream("total")
  //@BlocSink("setTotal")
  @sink
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

   @Listen("_reset", external: true)
  void _onReset() {
    this._count.add(0);
  }
}