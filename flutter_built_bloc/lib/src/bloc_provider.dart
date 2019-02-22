import 'package:built_bloc/built_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A builder that creates a bloc instance for a given context.
typedef T BlocBuilder<T extends Bloc>(BuildContext context);

/// A widget that hosts a [Bloc].
///
/// It gives access to the [bloc] to all its descendent widgets.
///
/// This provider will also dispose the bloc when the widget is disposed.
class BlocProvider<T extends Bloc> extends StatelessWidget {
  /// The provided bloc.
  final BlocBuilder<T> blocBuilder;

  /// The child widget that will have access to the provided bloc through
  /// the [of] method.
  final Widget child;

  /// Creates a widget that gives acces to a [bloc] to all its descendent widgets.
  const BlocProvider({
    Key key,
    @required this.blocBuilder,
    this.child,
  })  : assert(child != null || blocBuilder != null),
        super(key: key);

  /// The [Bloc] from the closest [BlocProvider] instance that encloses the given
  /// context.
  static T of<T extends Bloc>(BuildContext context) => Provider.of<T>(context);

  @override
  Widget build(BuildContext context) {
    return StatefulProvider<T>(
      valueBuilder: this.blocBuilder,
      onDispose: (context, bloc) => bloc.dispose(),
      child: this.child,
    );
  }
}
