import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:code_builder/code_builder.dart';
import 'helpers.dart';

class SubjectGenerator {
  final String name;

  final String subjectName;

  final Reference argumentType;

  final String subjectType;

  final String sinkType;

  final String streamType;

  final bool isSink;

  final bool isStream;

  SubjectGenerator(PropertyAccessorElement method, DartType argumentType,
      {this.isSink, this.isStream})
      : this.name = method.name,
        this.subjectName = "_${method.name}Subject",
        this.argumentType = argumentType != null
            ? referFromAnalyzer(argumentType)
            : refer("void"),
        this.subjectType = method.returnType.name,
        this.streamType =
            "Stream<${argumentType?.name ?? "void"}>",
        this.sinkType =
            "Sink<${argumentType?.name ?? "void"}>";

  void generatePrivate(
    ConstructorBuilder privateConstructor,
    BlockBuilder privateConstructorBody,
    ClassBuilder private,
  ) {
    private.methods.add(Method((b) => b
      ..name = this.name
      ..annotations.add(CodeExpression(Code("override")))
      ..type = MethodType.getter
      ..body = Block((b) => b
        ..statements.addAll([
          Code(
              "if(this.$subjectName == null) { this.$subjectName = super.$name; } "),
          Code("return this.$subjectName;")
        ]))));

    private.fields.add(Field((b) => b
      ..name = this.subjectName
      ..type = refer(this.subjectType)));
  }

  void generatePublic(ClassBuilder public) {
    if (this.isSink) {
      public.methods.add(Method((b) => b
        ..name = this.name
        ..lambda = true
        ..returns = refer(this.sinkType)
        ..body = Code("this._internal.$name.sink")
        ..type = MethodType.getter));
    } else if (this.isStream) {
      public.methods.add(Method((b) => b
        ..name = this.name
        ..lambda = true
        ..returns = refer(this.streamType)
        ..body = Code("this._internal.$name.stream")
        ..type = MethodType.getter));
    }
  }

  static List<SubjectGenerator> find(ClassElement element) {
    final subjects = element.accessors.map((m) {
      final sinkAnnotations = findAnnotation(m, BlocSink);
      final streamAnnotations = findAnnotation(m, BlocStream);

      if(sinkAnnotations.isEmpty && streamAnnotations.isEmpty) {
        return null;
      }

      return SubjectGenerator(m, extractBoundType(m.returnType),
          isStream: streamAnnotations.isNotEmpty,
          isSink: sinkAnnotations.isNotEmpty);
    });

    return subjects.where((c) => c != null).toList();
  }
}
