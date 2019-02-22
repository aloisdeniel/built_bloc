import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

class StreamGenerator {
  final FieldElement field;
  final BlocStream annotation;
  final String argumentType;
  final String name;

  StreamGenerator({@required this.field, @required this.annotation})
      : argumentType = extractBoundTypeName(field),
        this.name = annotation.name ?? publicName(field.name, "Stream");

  void buildGetter(ClassBuilder builder) {
    builder.methods.add(Method((b) => b
      ..name = this.name
      ..type = MethodType.getter
      ..returns = refer("Stream<${this.argumentType}>")
      ..lambda = true
      ..body = Code("_parent.${field.name}.stream")));
  }

  void buildSubscription(BlockBuilder builder) {
    builder.statements.add(Code("value.subjects.add(value.${field.name});"));
  }
}