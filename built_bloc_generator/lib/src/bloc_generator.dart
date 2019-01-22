import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:built_bloc/built_bloc.dart';
import 'generators/bloc.dart' as gen;

class BlocGenerator extends GeneratorForAnnotation<BuiltBloc> {
  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      final name = element.name;

      if (!element.allSupertypes.any((s) => s.name == "Bloc")) {
        throw InvalidGenerationSourceError(
            'Generator can only target classes that inherit from Bloc class.',
            todo: 'Add the Bloc as a supertype of `$name`.',
            element: element);
      }

      final generator = gen.BlocGenerator(element);
      final mixinClass = generator.buildMixin();

      var library =
          Library((b) => b..body.addAll([mixinClass])..directives.addAll([]));

      var emitter = DartEmitter();
      var source = '${library.accept(emitter)}';
      return [DartFormatter().format(source)];
    }

    final name = element.name;
    throw InvalidGenerationSourceError('Generator cannot target `$name`.',
        todo: 'Remove the BuiltBloc annotation from `$name`.',
        element: element);
  }
}
