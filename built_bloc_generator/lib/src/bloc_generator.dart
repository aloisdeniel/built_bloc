import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:built_bloc/built_bloc.dart';

import 'bloc_class_generator.dart';

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

      final generator = BlocClassGenerator(element, annotation, buildStep);
      return generator.generate();
    }

    final name = element.name;
    throw InvalidGenerationSourceError('Generator cannot target `$name`.',
        todo: 'Remove the BuiltBloc annotation from `$name`.',
        element: element);
  }
}
