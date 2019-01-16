import 'package:rxdart/rxdart.dart';
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  @stream
  Stream get direct => null;

  @stream
  BehaviorSubject<int> get count => addBehavior(0);

  @sink
  PublishSubject<int> get add => addPublish(onData: (value) {
    this.count.add(this.count.value + value);
  });

  @sink
  PublishSubject<void> get reset => addPublish(onData: (_) {
    this.count.add(0);
  });
}