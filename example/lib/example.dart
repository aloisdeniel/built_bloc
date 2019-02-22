import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
class ExampleBloc extends Bloc with _ExampleBloc {

  ExampleBloc() {
    _add.map((v) => _count.value + v).listen(_count.add);
    //_reset.mapTo(0).listen(_count.add);
  }

  //@BlocStream("total")
  //@BlocSink("setTotal")
  @sink
  @stream
  final BehaviorSubject<int> _count = BehaviorSubject<int>(seedValue: 0);

  @sink
  final _add = PublishSubject<int>();

  @sink
  @Bind("_onReset")
  final PublishSubject<void> _reset = PublishSubject<void>();

  void _onReset() {
    this._count.add(0);
  }
}