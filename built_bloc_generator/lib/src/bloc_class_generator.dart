import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:built_bloc_generator/src/sink_generator.dart';
import 'package:built_bloc_generator/src/stream_generator.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

class BlocClassGenerator {
  final String publicName;
  String get privateName => "_\$$publicName";
  final ClassElement element;
  final ConstantReader annotation;
  final BuildStep buildStep;
  final List<SinkGenerator> sinks;
  final List<StreamGenerator> streams;

  BlocClassGenerator(this.element, this.annotation, this.buildStep)
      : this.publicName = _generateBlocName(element.name),
        this.sinks = SinkGenerator.find(element),
        this.streams = StreamGenerator.find(element);

  static String _generateBlocName(String name) {
    if (name.startsWith("_")) {
      return name.substring(1);
    }
    return "${name}Bloc";
  }

  Iterable<String> generate() {
    var classes = [
      _generatePrivate(),
      _generatePublic(),
    ];

    var library =
        Library((b) => b..body.addAll(classes)..directives.addAll([]));

    var emitter = DartEmitter();
    var source = '${library.accept(emitter)}';
    return [DartFormatter().format(source)];
  }

  Class _generatePublic() {
    final builder = ClassBuilder()
      ..name = this.publicName
      ..extend = refer("Bloc");

    final constructor = ConstructorBuilder();
    builder.fields.add(Field((b) => b
      ..name = "_internal"
      ..type = refer(this.privateName)
      ..modifier = FieldModifier.final$));
    this.sinks.forEach((s) => s.generatePublic(builder));
    this.streams.forEach((s) => s.generatePublic(builder));

    _addConstructorParameters(constructor);
    constructor.initializers
        .add(Code("this._internal = $privateName" + _constructorArgs()));
    builder.constructors.add(constructor.build());

    builder.methods.add(Method((b) => b
    ..name = "dispose"
    ..annotations.add(CodeExpression(Code("override")))
    ..body = Block((b) => b..statements.addAll([
      Code("super.dispose();"),
      Code("this._internal.dispose();")
    ]))));

    return builder.build();
  }

  Class _generatePrivate() {
    final builder = ClassBuilder()
      ..extend = refer(this.element.name)
      ..name = this.privateName;

    final constructor = ConstructorBuilder();
    final constructorBody = BlockBuilder();
    this.sinks.forEach(
        (s) => s.generatePrivate(constructor, constructorBody, builder));
    this.streams.forEach(
        (s) => s.generatePrivate(constructor, constructorBody, builder));
    constructor.body = constructorBody.build();

    _addConstructorParameters(constructor);
    constructor.initializers.add(Code("super" + _constructorArgs()));
    builder.constructors.add(constructor.build());

    return builder.build();
  }

  String _constructorArgs() {
    final superInit = StringBuffer();

    superInit.write("(");

    if (this.element.constructors != null &&
        this.element.constructors.first.parameters.isNotEmpty) {
      final parameters = this.element.constructors.first.parameters;

      final requiredParamaters = parameters.where((p) => !p.isOptional);
      final optionalParamaters = parameters.where((p) => p.isOptional);

      requiredParamaters.forEach((c) => superInit.write(c.name + ", "));
      optionalParamaters
          .forEach((c) => superInit.write(c.name + ": " + c.name + ", "));
    }

    superInit.write(")");

    return superInit.toString();
  }

  void _addConstructorParameters(ConstructorBuilder c) {
    if (this.element.constructors != null &&
        this.element.constructors.first.parameters.isNotEmpty) {
      final parameters = this.element.constructors.first.parameters;

      final requiredParamaters = parameters.where((p) => !p.isOptional);
      c.requiredParameters
          .addAll(requiredParamaters.map((p) => Parameter((b) => b
            ..name = p.name
            ..type = referFromAnalyzer(p.type))));

      final optionalParamaters = parameters.where((p) => p.isOptional);
      c.optionalParameters
          .addAll(optionalParamaters.map((p) => Parameter((b) => b
            ..name = p.name
            ..named = true
            ..type = referFromAnalyzer(p.type))));
    }
  }
}
