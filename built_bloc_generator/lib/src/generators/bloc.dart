import 'package:analyzer/dart/element/element.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:built_bloc_generator/src/annotations.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:code_builder/code_builder.dart';
import 'stream.dart';
import 'sink.dart';
import 'bind.dart';

class BlocGenerator {
  final ClassElement element;
  final List<StreamGenerator> streams;
  final List<SinkGenerator> sinks;
  final List<BindGenerator> listens;

  BlocGenerator(this.element)
      : this.listens = _scanForBinds(element),
        this.streams = _scanForStreams(element),
        this.sinks = _scanForSinks(element);

  String get name => privateName(this.element.name, "Bloc");

  Class buildMixin() {
    final builder = ClassBuilder()
      ..name = this.name
      ..implements.add(refer("GeneratedBloc<${element.name}>"));

    builder.fields.add(Field((b) => b
      ..name = "_parent"
      ..type = refer(element.name)));

    this.streams.forEach((s) => s.buildGetter(builder));
    this.sinks.forEach((s) => s.buildGetter(builder));

    builder.methods.add(this.buildMetadata());

    this.buildSubscription(builder);

    return builder.build();
  }

  void buildSubscription(ClassBuilder builder) {
    final block = BlockBuilder();
    block.statements.add(Code("this._parent = value;"));
    this.streams.forEach((s) => s.buildSubscription(block));
    this.sinks.forEach((s) => s.buildSubscription(block));
    this.listens.forEach((s) => s.buildSubscription(block));

    builder.methods.add(Method((b) => b
      ..name = "subscribeParent"
      ..annotations.add(CodeExpression(Code("override")))
      ..returns = refer("void")
      ..body = block.build()
      ..requiredParameters.add(Parameter((b) => b
        ..name = "value"
        ..type = refer(this.element.name)))));
  }

  Method buildMetadata() {
    final metadataBody = StringBuffer();
    metadataBody.write("{");
    metadataBody.write('"title": "${element.name}",');
    metadataBody.write('"sinks": {');
    metadataBody
        .write(this.sinks.map((s) => '"${s.name}": ${s.name}').join(", "));
    metadataBody.write('},');
    metadataBody.write('"streams": {');
    metadataBody
        .write(this.streams.map((s) => '"${s.name}": ${s.name}').join(", "));
    metadataBody.write('},');
    metadataBody.write("}");

    return Method((b) => b
      ..name = "metadata"
      ..returns = refer("Map<String,dynamic>")
      ..type = MethodType.getter
      ..lambda = true
      ..body = Code(metadataBody.toString()));
  }

  static List<StreamGenerator> _scanForStreams(ClassElement element) {
    return element.fields
        .map((field) => ifAnnotated<BlocStream, StreamGenerator>(
            field,
            (e, a) => StreamGenerator(
                field: e as FieldElement, annotation: streamFromAnnotation(a))))
        .where((x) => x != null)
        .toList();
  }

  static List<SinkGenerator> _scanForSinks(ClassElement element) {
    return element.fields
        .map((field) => ifAnnotated<BlocSink, SinkGenerator>(
            field,
            (e, a) {
              final public = publicName(e.name,"");
              final streamGenerator = ifAnnotated<BlocStream, StreamGenerator>(e, (ee,a) => StreamGenerator(
                field: ee as FieldElement, annotation: streamFromAnnotation(a)));

              final capitalizedPublic = public[0].toUpperCase() + public.substring(1);
              final defaultName = streamGenerator?.name == public ? "update$capitalizedPublic" : null;

              return SinkGenerator(
                field: e as FieldElement, annotation: sinkFromAnnotation(a), defaultName: defaultName);
            }))
        .where((x) => x != null)
        .toList();
  }

  static List<BindGenerator> _scanForBinds(ClassElement element) {
    return element.fields
        .map((method) => ifAnnotated<Bind, BindGenerator>(
            method,
            (e, a) => BindGenerator(
                blocClass: element,
                field: e as FieldElement,
                annotation: bindFromAnnotation(a))))
        .where((x) => x != null)
        .toList();
  }
}
