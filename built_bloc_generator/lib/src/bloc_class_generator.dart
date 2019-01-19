import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:built_bloc_generator/src/subject_generator.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

class BlocClassGenerator {
  final String publicName;
  String get privateName => "_\$$publicName";
  final ClassElement element;
  final ConstantReader annotation;
  final BuildStep buildStep;
  final List<SubjectGenerator> subjects;

  BlocClassGenerator(this.element, this.annotation, this.buildStep)
      : this.publicName = _generateBlocName(element.name),
        this.subjects = SubjectGenerator.find(element);

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
    this.subjects.forEach((s) => s.generatePublic(builder));

    _addConstructorParameters(constructor);
    constructor.initializers
        .add(Code("this._internal = $privateName" + _constructorArgs()));
    builder.constructors.add(constructor.build());

    builder.methods.add(Method((b) => b
      ..name = "dispose"
      ..annotations.add(CodeExpression(Code("override")))
      ..body = Block((b) => b
        ..statements.addAll(
            [Code("super.dispose();"), Code("this._internal.dispose();")]))));

    final t ={
      "title": "",
    };

    final metadataBody = StringBuffer();
    metadataBody.write("{");
    metadataBody.write('"title": "$publicName",');
    metadataBody.write('"sinks": {');
    metadataBody.write(this.subjects.where((s) => s.isSink).map((s) => '"${s.name}": ${s.name}').join(", "));
    metadataBody.write('},');
    metadataBody.write('"streams": {');
    metadataBody.write(this.subjects.where((s) => s.isStream).map((s) => '"${s.name}": ${s.name}').join(", "));
    metadataBody.write('},');
    metadataBody.write("}");

    builder.methods.add(Method((b) => b
      ..name = "metadata"
      ..returns = refer("Map<String,dynamic>")
      ..type = MethodType.getter
      ..lambda = true
      ..body = Code(metadataBody.toString())));

    return builder.build();
  }

  Class _generatePrivate() {
    final builder = ClassBuilder()
      ..extend = refer(this.element.name)
      ..name = this.privateName;

    final constructor = ConstructorBuilder();
    final constructorBody = BlockBuilder();
    this.subjects.forEach(
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
