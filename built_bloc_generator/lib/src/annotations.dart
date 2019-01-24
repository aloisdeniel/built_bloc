import 'package:built_bloc/built_bloc.dart';
import 'package:source_gen/source_gen.dart';

Bind bindFromAnnotation(ConstantReader reader) {
  final obj = reader.objectValue;
  final methodName = obj.getField("methodName").toStringValue();
  final external = obj.getField("external").toBoolValue() ?? false;
  return Bind(methodName, external: external);
}

BlocStream streamFromAnnotation(ConstantReader reader) {
  final obj = reader.objectValue;
  final name = obj.getField("name").toStringValue();
  return BlocStream(name);
}

BlocSink sinkFromAnnotation(ConstantReader reader) {
  final obj = reader.objectValue;
  final name = obj.getField("name").toStringValue();
  return BlocSink(name);
}