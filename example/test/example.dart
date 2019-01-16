
import 'package:example/example.dart';

void main() {
  final bloc = ExampleBloc();
  bloc.count.listen((c) => print("count: $c"));
  bloc.add.add(10);
  bloc.reset.add(null);
}