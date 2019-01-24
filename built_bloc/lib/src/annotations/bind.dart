/// An annotation used to subscribe a method to a bloc's [Stream].
class Bind {
  /// The name of the stream or subject name the function will listen to.
  final String methodName;

  /// If set to `true`, add the [StreamSubscription] to the bloc's `subscriptions`.
  final bool external;

  /// Creates a new [Listen] instance.
  const Bind(this.methodName, {this.external});
}
