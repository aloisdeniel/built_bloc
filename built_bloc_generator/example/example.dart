import 'package:built_bloc/built_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// This class would generate an `ExampleBloc` class that would
/// exposes only a [Sink] for [add], and a [Stream] for [count].
@bloc
class _ExampleBloc extends Bloc {
  @sink
  PublishSubject<int> get add => fromPublish(onData: (int value) {
        this.count.add(this.count.value + 1);
      });

  @stream
  BehaviorSubject<int> get count => fromBehavior(0);
}