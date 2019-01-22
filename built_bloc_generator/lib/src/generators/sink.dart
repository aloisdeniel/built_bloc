import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

class SinkGenerator {
  final FieldElement field;
  final BlocSink annotation;
  final DartType argumentType;
  final String name;

  SinkGenerator({@required this.field, @required this.annotation, String defaultName})
      : argumentType = extractBoundType(field.type),
        this.name = annotation.name ?? defaultName ?? publicName(field.name, "Sink");

  void buildGetter(ClassBuilder builder) {
    builder.methods.add(Method((b) => b
      ..name = this.name
      ..type = MethodType.getter
      ..returns = refer("Sink<${this.argumentType?.name ?? "void"}>")
      ..lambda = true
      ..body = Code("this._parent.${field.name}.sink")));
  }

  void buildSubscription(BlockBuilder builder) {
    builder.statements.add(Code("value.subjects.add(value.${field.name});"));
  }
}