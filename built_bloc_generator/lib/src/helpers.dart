import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

/// Search for an [annotation] attached to the [element].
List<AnnotatedElement> findAnnotation(Element element, Type annotation) {
  return TypeChecker.fromRuntime(annotation)
      .annotationsOf(element)
      .map((c) => AnnotatedElement(ConstantReader(c), element))
      .toList();
}

/// Get code builder reference from an analyzer [type].
Reference referFromAnalyzer(DartType type) {
  return refer(type.name, type.element?.librarySource?.uri?.toString());
}

/// Extract a parameterized type from a [type].
DartType extractBoundType(DartType type) {
  DartType bound = null;

  if (type is ParameterizedType) {
    if (type.typeArguments.isNotEmpty) {
      bound = type.typeArguments.first;
    }
  }
  return bound;
}

bool isExactlyRuntime(DartType t, Type runtimeType) {
  final streamType = TypeChecker.fromRuntime(runtimeType);
  return streamType.isExactlyType(t);
}

bool isSuperTypeRuntime(DartType t, Type runtimeType) {
  final streamType = TypeChecker.fromRuntime(runtimeType);
  return streamType.isSuperTypeOf(t);
}
