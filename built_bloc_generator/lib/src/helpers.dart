import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

String publicName(String name, String suffixIfNotPrivate) {
  if (name.startsWith("_")) {
    return name.substring(1);
  }
  return "$name$suffixIfNotPrivate";
}

String privateName(String name, String suffixIfNotPublic) {
  if (name.startsWith("_")) {
    return "$name$suffixIfNotPublic";
  }
  return "_$name";
}

TResult ifAnnotated<TAnnotation, TResult>(
    Element element, TResult builder(Element e, ConstantReader annotation)) {
  final annotations =
      TypeChecker.fromRuntime(TAnnotation).annotationsOf(element);

  if (annotations.isEmpty) return null;
  final annotation = ConstantReader(annotations.first);
  return builder(element, annotation);
}

/// Get code builder reference from an analyzer [type].
Reference referFromAnalyzer(DartType type) {
  return refer(type.name, type.element?.librarySource?.uri?.toString());
}

/// Extract a parameterized type from a field's [type].
String extractBoundTypeName(FieldElement field) {
  DartType bound = null;

  if (field.type is ParameterizedType) {
    final arguments = (field.type as ParameterizedType).typeArguments;
    if (arguments.isNotEmpty) {
      bound = arguments.first;
    }

    if (bound != null && bound.isUndefined) {
      final source = field.computeNode();
      print("source:" + source.toSource());
    }
  }

  if (bound == null || bound.isVoid) {
    return "void";
  }

  return bound.name;
}

bool isExactlyRuntime(DartType t, Type runtimeType) {
  final streamType = TypeChecker.fromRuntime(runtimeType);
  return streamType.isExactlyType(t);
}

bool isSuperTypeRuntime(DartType t, Type runtimeType) {
  final streamType = TypeChecker.fromRuntime(runtimeType);
  return streamType.isSuperTypeOf(t);
}
