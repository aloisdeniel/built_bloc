import 'dart:async';
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
  /// Add a [StreamSubscription] to this collection and it will
  /// be automatically cancelled when the bloc is disposed.
  @protected
  final List<StreamSubscription<dynamic>> subscriptions = [];

  /// Add a [Subject] to this collection and it will
  /// be automatically closed when the bloc is disposed.
  @protected
  final List<Subject<dynamic>> subjects = [];

  /// Subscribing to a [stream] like would have done with [Stream.listen], but adds
  /// the resulting [StreamSubscription] to the [subscriptions] collection for it to
  /// be disposed with the bloc.
  @protected
  Stream<T> fromStream<T>(Stream<T> stream,
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    if (stream != null && onData != null) {
      this.subscriptions.add(stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError));
    }
    return stream;
  }

  /// Subscribing to a [subject]'s stream like would have done with [subject.stream.listen], but adds
  /// the resulting [StreamSubscription] to the [subscriptions] collection for it to
  /// be disposed with the bloc.
  @protected
  Subject<T> fromSubject<T>(Subject<T> subject,
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    this.fromStream(subject?.stream,
        onData: onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
    return subject;
  }

  /// Instanciates a new synchronous [PublishSubject], adds it to [subjects] and optionally
  /// subscribe to its stream.
  @protected
  PublishSubject<T> fromPublish<T>(
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    return this.fromSubject(PublishSubject<T>(sync: true),
        onData: onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
  }

  /// Instanciates a new synchronous [BehaviorSubject] with a [seedValue], adds it to [subjects] and optionally
  /// subscribe to its stream.
  @protected
  BehaviorSubject<T> fromBehavior<T>(T seedValue,
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    return this.fromSubject(
        BehaviorSubject<T>(sync: true, seedValue: seedValue),
        onData: onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
  }

  /// Same behavior as [fromPublish], but adds the resulting subject to [subjects].
  @protected
  PublishSubject<T> addPublish<T>(
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    final subject = this.fromPublish(
        onData: onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
    this.subjects.add(subject);
    return subject;
  }

  /// Same behavior as [fromBehavior], but adds the resulting subject to [subjects].
  @protected
  BehaviorSubject<T> addBehavior<T>(T seedValue,
      {void onData(T newValue),
      Function onError,
      void onDone(),
      bool cancelOnError}) {
    final subject = this.fromBehavior(seedValue,
        onData: onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
    this.subjects.add(subject);
    return subject;
  }

  /// Cancel all the underlying [subscriptions] and close all [subjects].
  @mustCallSuper
  void dispose() {
    this.subscriptions.forEach((s) => s.cancel());
    this.subjects.forEach((s) => s.close());
  }
}
