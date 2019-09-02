import 'package:built_bloc/built_bloc.dart';
import 'package:source_gen/source_gen.dart';

Bind bindFromAnnotation(ConstantReader reader) {
  final obj = reader.objectValue;
  final methodName = obj.getField("methodName").toStringValue();
  final external = obj.getField("external").toBoolValue() ?? false;
  final swallowErrors = obj.getField("swallowErrors").toBoolValue() ?? true;
  return Bind(methodName, external: external, swallowErrors: swallowErrors);
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