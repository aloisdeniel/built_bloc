import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  BehaviorSubject<int> get count => behavior(0);

  @sink
  PublishSubject<int> get add => publish(onData: (value) {
    this.count.add(this.count.value + value);
  });

  @sink
  PublishSubject<void> get reset => publish(onData: (_) {
    this.count.add(0);
  });
}