import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:built_bloc_generator/src/helpers.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

class BindGenerator {
  final FieldElement field;
  final MethodElement method;
  final Bind annotation;
  final String argumentType;
  BindGenerator(
      {@required ClassElement blocClass, @required this.field, @required this.annotation})
      : this.argumentType = extractBoundTypeName(field),
        this.method = _findListenMethod(blocClass, field, annotation.methodName,
            extractBoundTypeName(field));

  static MethodElement _findListenMethod(ClassElement blocClass,
      FieldElement field, String name, String argumentType) {
    final method = blocClass.methods.firstWhere((m) => m.name == name,
        orElse: () => throw InvalidGenerationSourceError(
            'No method found with name `$name` on class `${blocClass.name}`',
            todo:
                'Add a method`void $name(${argumentType} value)` on class `${blocClass.name}',
            element: field));

    return method;
  }

  void buildSubscription(BlockBuilder builder) {
    var streamName = field.name;

    /// We call `listen` directly on [field] only if it is a stream, else we 
    /// consider that the type must have a `.stream` property.
    final checker = TypeChecker.fromRuntime(Stream);
    if (!checker.isAssignableFromType(this.field.type)) {
      streamName += ".stream";
    }

    streamName = "this._parent.${streamName}";

    final callback = this.argumentType == null || this.argumentType == "void"
        ? "(_) => value.${method.name}()"
        : "value.${method.name}";

    final errorManagement = annotation.swallowErrors ? ', onError: (_) {}' : '';

    final listen = "${streamName}.listen($callback$errorManagement)";

    final statement = this.annotation.external
        ? "value.subscriptions.add($listen);"
        : "$listen;";

    builder.statements.add(Code(statement));
  }
}
