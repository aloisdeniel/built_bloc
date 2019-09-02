/// An annotation used to subscribe a method to a bloc's [Stream].
class Bind {
  /// The name of the stream or subject name the function will listen to.
  final String methodName;

  /// If set to `true`, add the [StreamSubscription] to the bloc's `subscriptions`.
  final bool external;

  /// If set to `false`, errors will be propagated to main FlutterError.
  final bool swallowErrors;

  /// Creates a new [Listen] instance.
  const Bind(this.methodName, {this.external = false, this.swallowErrors = true});
}
