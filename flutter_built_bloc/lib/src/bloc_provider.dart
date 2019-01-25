import 'package:built_bloc/built_bloc.dart';
import 'package:flutter/widgets.dart';

/// A widget that hosts a [Bloc].
/// 
/// It gives access to the [bloc] to all its descendent widgets.
/// 
/// This provider will also dispose the bloc when the widget is disposed.
class BlocProvider<T extends Bloc> extends StatefulWidget {

  /// The provided bloc.
  final T bloc;

  /// The child widget that will have access to the provided bloc through
  /// the [of] method.
  final Widget child;

  /// Creates a widget that gives acces to a [bloc] to all its descendent widgets.
  const BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  /// The [Bloc] from the closest [BlocProvider] instance that encloses the given
  /// context.
  static T of<T extends Bloc>(BuildContext context) {
    final type = _typeOf<_InheritedBlocProvider<T>>();
    final provider =
        context.inheritFromWidgetOfExactType(type) as _InheritedBlocProvider<T>;
    return provider?.bloc;
  }

  @override
  _BlocProviderState createState() => _BlocProviderState();
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedBlocProvider<T>(
      bloc: this.widget.bloc,
      child: widget.child,
    );
  }
}

class _InheritedBlocProvider<T extends Bloc> extends InheritedWidget {
  final T bloc;
  _InheritedBlocProvider({@required Widget child, @required this.bloc})
      : super(child: child);

  @override
  bool updateShouldNotify(_InheritedBlocProvider<T> oldWidget) {
    return this.bloc != oldWidget.bloc;
  }
}

Type _typeOf<T>() => T;
