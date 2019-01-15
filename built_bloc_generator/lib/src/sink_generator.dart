import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:code_builder/code_builder.dart';
import 'helpers.dart';

class SinkGenerator {
  final String name;

  final String subjectName;

  final String onListenName;

  final bool mustGenerateGetter;

  final Reference argumentType;

  final String subjectType;

  final String sinkType;

  final MethodElement element;

  SinkGenerator.fromMethod(MethodElement method)
      : this.element = method,
        this.name = method.name,
        this.onListenName = method.name,
        this.subjectName = "_${method.name}Subject",
        this.mustGenerateGetter = false,
        this.argumentType = (method.parameters.isNotEmpty
            ? referFromAnalyzer(method.parameters.first.type)
            : refer("void")),
        this.subjectType =
            "PublishSubject<${(method.parameters.isNotEmpty ? method.parameters.first.type.name : "void")}>",
        this.sinkType =
            "Sink<${(method.parameters.isNotEmpty ? method.parameters.first.type.name : "void")}>" {
    if (method.parameters.length > 1) {
      throw InvalidGenerationSourceError(
          'Generated sink  from a method `${method.name}` should only have one parameter',
          todo: 'Remove other parameters.',
          element: method);
    }
  }

  void generatePrivate(
    ConstructorBuilder privateConstructor,
    BlockBuilder privateConstructorBody,
    ClassBuilder private,
  ) {
    private.fields.add(Field((b) => b
      ..name = this.subjectName
      ..modifier = FieldModifier.final$
      ..assignment = Code("${subjectType}(sync: true)")
      ..type = refer(this.subjectType)));

    var onData = "this.$onListenName";
    if (element.parameters.isEmpty) {
      onData = "(_) => $onData()";
    }
    privateConstructorBody.statements.add(
        Code("this.subscribeSubject(this.$subjectName, onData: $onData);"));
  }

  void generatePublic(ClassBuilder public) {
    public.methods.add(Method((b) => b
      ..name = this.name
      ..lambda = true
      ..returns = refer(this.sinkType)
      ..body = Code("this._internal.$subjectName.sink")
      ..type = MethodType.getter));
  }

  static List<SinkGenerator> find(ClassElement element) {
    final methodSinks = element.methods.map((m) {
      final annotation = findAnnotation(m, BlocSink);
      if (annotation.isNotEmpty) {
        return SinkGenerator.fromMethod(m);
      }
      return null;
    });

    final sinks = methodSinks.where((c) => c != null);

    if (sinks.isNotEmpty) {
      return sinks.toList();
    }

    return [];
  }
}
