import 'package:built_bloc/built_bloc.dart';

//part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  // Stream examples

  // Sink examples


  @sink
  void add3(int value) {
    print("Add: $value");
  }
}