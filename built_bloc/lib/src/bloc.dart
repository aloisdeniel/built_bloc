import 'dart:async';
import 'package:built_bloc/src/mixins/bloc_mixin.dart';
import 'package:rxdart/rxdart.dart';

import 'package:meta/meta.dart';

/// A [Bloc] is an abstraction of a view that exposes only [Stream] outputs
/// and [Sink] inputs.
///
/// Since a bloc manages several streams you must [dispose] it afterward for
/// closing all the underlying [subscriptions].
///
/// This class provides also a set of tools for helping with [Stream]s lifecycle :
///
/// * [subscriptions], [subjects] collections for automatically disposing
/// underlyning resources.
/// * [fromStream], [fromPublish], [fromSubject], [fromBehavior] are shortcuts for subscribing to
/// streams and add it to [subscriptions] collection.
class Bloc {
  /// Creates a new [Bloc] instance.
  Bloc() {
    if(this is GeneratedBloc) {
      (this as GeneratedBloc).subscribeParent(this);
    }
  }

  /// Add a [StreamSubscription] to this collection and it will
  /// be automatically cancelled when the bloc is disposed.
  final List<StreamSubscription<dynamic>> subscriptions = [];

  /// Add a [Subject] to this collection and it will
  /// be automatically closed when the bloc is disposed.
  final List<Subject<dynamic>> subjects = [];

  /// Cancel all the underlying [subscriptions] and close all [subjects].
  @mustCallSuper
  Future<void> dispose() async {
    if(this.subscriptions.isNotEmpty) {
      await Future.wait(this.subscriptions.map((s) => s.cancel()));
    }
    if(this.subjects.isNotEmpty) {
      await Future.wait(this.subjects.map((s) => s.close()));
    }
  }
}
