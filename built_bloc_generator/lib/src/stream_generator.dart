import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:code_builder/code_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:source_gen/source_gen.dart';
import 'helpers.dart';

class StreamGenerator {
  final String name;

  final String subjectName;

  final Reference argumentType;

  final String subjectType;

  final String streamType;

  final String seedValue;

  final bool isSubject;

  StreamGenerator.fromSubject(FieldElement field, DartType argumentType)
      : this.isSubject = true,
        this.name = field.name,
        this.subjectName = field.name,
        this.seedValue = null,
        this.argumentType =
            argumentType != null ? referFromAnalyzer(argumentType) : refer("void"),
        this.subjectType = field.type.name,
        this.streamType = "Stream<${ argumentType != null ? argumentType.name : "void"}>";

  StreamGenerator.fromField(FieldElement field)
      : this.isSubject = false,
        this.name = field.name,
        this.subjectName = "_${field.name}Subject",
        this.seedValue = null, // field.initializer != null ? "" : "", // TODO
        this.argumentType = referFromAnalyzer(field.type),
        this.subjectType = "BehaviorSubject<${field.type.name}>",
        this.streamType = "Stream<${field.type.name}>";

  void generatePrivate(
    ConstructorBuilder privateConstructor,
    BlockBuilder privateConstructorBody,
    ClassBuilder private,
  ) {
    if (!this.isSubject) {
      final seed = this.seedValue != null ? "seedValue: $seedValue" : "";
      private.fields.add(Field((b) => b
        ..name = this.subjectName
        ..modifier = FieldModifier.final$
        ..assignment = Code("${subjectType}(sync: true, $seed)")
        ..type = refer(this.subjectType)));

      private.methods.add(Method((b) => b
        ..name = this.name
        ..type = MethodType.getter
        ..lambda = true
        ..returns = this.argumentType
        ..annotations.add(CodeExpression(Code("override")))
        ..body = Code("${subjectName}.value")));

      private.methods.add(Method((b) => b
        ..name = this.name
        ..type = MethodType.setter
        ..lambda = true
        ..requiredParameters.add(Parameter((b) => b
          ..name = "newValue"
          ..type = this.argumentType))
        ..annotations.add(CodeExpression(Code("override")))
        ..body = Code("${subjectName}.add(newValue)")));
    }
    privateConstructorBody.statements
        .add(Code("this.subscribeSubject(this.$subjectName);"));
  }

  void generatePublic(ClassBuilder public) {
    public.methods.add(Method((b) => b
      ..name = this.name
      ..lambda = true
      ..returns = refer(this.streamType)
      ..body = Code("this._internal.$subjectName.stream")
      ..type = MethodType.getter));
  }

  static List<StreamGenerator> find(ClassElement element) {
    final fieldStreams = element.fields.map((m) {
      final annotation = findAnnotation(m, BlocStream);
      if (annotation.isNotEmpty) {
        final checker = TypeChecker.fromRuntime(Subject);

        if (checker.isSuperTypeOf(m.type)) {
          DartType bound = null;

          if (m.type is ParameterizedType) {
            final paramTypes = (m.type as ParameterizedType);
            if(paramTypes.typeArguments.isNotEmpty) {
              bound = paramTypes.typeArguments.first;
            }
          }

          return StreamGenerator.fromSubject(m, bound);
        }

        return StreamGenerator.fromField(m);
      }
      return null;
    });

    final streams = fieldStreams.where((c) => c != null);

    if (streams.isNotEmpty) {
      return streams.toList();
    }

    return [];
  }
}
