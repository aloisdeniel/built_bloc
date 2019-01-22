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

TResult ifAnnotated<TAnnotation, TResult>(Element element, TResult builder(Element e, ConstantReader annotation)) {
  final annotations = TypeChecker.fromRuntime(TAnnotation).annotationsOf(element);

  if (annotations.isEmpty) return null;
  final annotation = ConstantReader(annotations.first);
  return builder(element, annotation);
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
