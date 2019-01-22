import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_bloc/built_bloc.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

class ListenGenerator {
  final MethodElement method;
  final Listen annotation;
  final DartType argumentType;
  ListenGenerator({@required this.method, @required this.annotation})
      : argumentType =
            method.parameters.isNotEmpty ? method.parameters.first.type : null;

  void buildSubscription(BlockBuilder builder) {
    final callback = this.argumentType == null
        ? "(_) => value.${method.name}()"
        : "value.${method.name}";
    builder.statements.add(Code(
        "value.subscriptions.add(this._parent.${annotation.streamName}.listen($callback));"));
  }
}
