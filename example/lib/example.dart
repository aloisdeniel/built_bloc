import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  Stream get direct => fromStream(null);

  @stream
  BehaviorSubject<int> get count => fromBehavior(0);

  @sink
  PublishSubject<int> get add => fromPublish(onData: (value) {
    this.count.add(this.count.value + value);
  });

  @sink
  PublishSubject<void> get reset => fromPublish(onData: (_) {
    this.count.add(0);
  });
}