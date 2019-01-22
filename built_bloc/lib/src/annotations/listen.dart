/// An annotation used to subscribe a method to a bloc's [Stream].
class Listen {
  /// The name of the stream or subject name the function will listen to.
  final String streamName;

  /// If set to `true`, add the [StreamSubscription] to the bloc's `subscriptions`.
  final bool external;

  /// Creates a new [Listen] instance.
  const Listen(this.streamName, {this.external});
}

/// Default [Listen] annotation. The stream name will be deduced
/// from the attached method name (your method should be named `_on<streamName>`).
const listen = Listen(null);
