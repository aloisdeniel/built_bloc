import 'package:built_bloc/built_bloc.dart';
import 'package:source_gen/source_gen.dart';

Listen listenFromAnnotation(ConstantReader reader) {
  final obj = reader.objectValue;
  final streamName = obj.getField("streamName").toStringValue();
  final external = obj.getField("external").toBoolValue() ?? false;
  return Listen(streamName, external: external);
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