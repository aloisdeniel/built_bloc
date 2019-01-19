import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:code_builder/code_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:source_gen/source_gen.dart';
import 'helpers.dart';

class SubjectGenerator {
  final String name;

  final String subjectName;

  final Reference argumentType;

  final String subjectType;

  final String sinkType;

  final String streamType;

  final bool isDirect;

  final bool isSink;

  final bool isStream;

  SubjectGenerator(PropertyAccessorElement method, DartType argumentType,
      {this.isSink, this.isStream, this.isDirect})
      : this.name = method.name,
        this.subjectName = "_${method.name}Subject",
        this.argumentType = argumentType != null
            ? referFromAnalyzer(argumentType)
            : refer("void"),
        this.subjectType =
            method.returnType.name + "<${argumentType?.name ?? "void"}>",
        this.streamType = "Stream<${argumentType?.name ?? "void"}>",
        this.sinkType = "Sink<${argumentType?.name ?? "void"}>";

  void generatePrivate(
    ConstructorBuilder privateConstructor,
    BlockBuilder privateConstructorBody,
    ClassBuilder private,
  ) {
    if (!this.isDirect) {
      private.methods.add(Method((b) => b
        ..name = this.name
        ..annotations.add(CodeExpression(Code("override")))
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code("this.$subjectName")));

      privateConstructorBody.statements.addAll([
        Code("this.$subjectName = super.$name;"),
        Code("this.subjects.add(this.$subjectName);"),
      ]);

      private.fields.add(Field((b) => b
        ..name = this.subjectName
        ..type = refer(this.subjectType)));
    }
  }

  void generatePublic(ClassBuilder public) {
    final builder = MethodBuilder()
      ..name = this.name
      ..lambda = true
      ..type = MethodType.getter
      ..returns = this.isSink ? refer(this.sinkType) : refer(this.streamType);
    if (this.isDirect) {
      builder..body = Code("this._internal.$name");
    } else if (this.isSink) {
      builder..body = Code("this._internal.$name.sink");
    } else if (this.isStream) {
      builder..body = Code("this._internal.$name.stream");
    }

    public.methods.add(builder.build());
  }

  static List<SubjectGenerator> find(ClassElement element) {
    final subjects = element.accessors.map((m) {
      final sinkAnnotations = findAnnotation(m, BlocSink);
      final streamAnnotations = findAnnotation(m, BlocStream);

      if (sinkAnnotations.isEmpty && streamAnnotations.isEmpty) {
        return null;
      }

      final isDirect = isExactlyRuntime(m.returnType, Stream) ||
          isExactlyRuntime(m.returnType, Sink);

      if (!(isDirect || isSuperTypeRuntime(m.returnType, Subject))) {
        throw InvalidGenerationSourceError(
            'The properties marked with \'BlocStream\' or \'BlocSink\' annotations must be either of \'Stream\', \'Sink\' exact types, or a \'Subject\' subtype',
            todo:
                'Change the return type of your property to \'Stream\', \'Sink\' exact types, or a \'Subject\' subtype',
            element: m);
      }

      return SubjectGenerator(m, extractBoundType(m.returnType),
          isDirect: isDirect,
          isStream: streamAnnotations.isNotEmpty,
          isSink: sinkAnnotations.isNotEmpty);
    });

    return subjects.where((c) => c != null).toList();
  }
}
