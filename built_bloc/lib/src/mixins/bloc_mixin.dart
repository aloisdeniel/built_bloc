import '../bloc.dart';

/// A base class for generated mixins.
mixin GeneratedBloc<TBloc extends Bloc> {
  /// This method should registers all subscriptions
  /// on parent's bloc.
  void subscribeParent(TBloc parent) {}
}
