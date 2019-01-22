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

  static String _findStreamName(String methodName) {
    final name = methodName.replaceFirst("_on", "");
    return "_" + name[0].toLowerCase() + name.substring(1);
  }

  void buildSubscription(BlockBuilder builder) {

    var streamName = annotation.streamName ?? _findStreamName(this.method.name);
    streamName = streamName.replaceAll("this.", "");
    streamName = "this._parent.${streamName}";

    final callback = this.argumentType == null
        ? "(_) => value.${method.name}()"
        : "value.${method.name}";

    final listen = "${streamName}.listen($callback)";

    final statement = this.annotation.external
        ? "value.subscriptions.add($listen);"
        : "$listen;";

    builder.statements.add(Code(statement));
  }
}
