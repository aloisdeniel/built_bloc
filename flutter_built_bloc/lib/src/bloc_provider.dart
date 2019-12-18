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
class BlocProvider<T extends Bloc> extends Provider<T> {
  /// Creates a widget that gives acces to a [bloc] to all its descendent widgets.
  BlocProvider({
    Key key,
    @required BlocBuilder<T> blocBuilder,
    Widget child,
  })  : assert(blocBuilder != null),
        super(
            key: key,
            create: blocBuilder,
            dispose: (context, bloc) => bloc.dispose(),
            child: child);

  /// The [Bloc] from the closest [BlocProvider] instance that encloses the given
  /// context.
  static T of<T extends Bloc>(BuildContext context) => Provider.of<T>(context);
}
