import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

List<AnnotatedElement> findAnnotation(Element element, Type annotation) {
  return TypeChecker.fromRuntime(annotation)
      .annotationsOf(element)
      .map((c) => AnnotatedElement(ConstantReader(c), element))
      .toList();
}

Reference referFromAnalyzer(DartType type) {
  return refer(type.name, type.element.librarySource.uri.toString());
}