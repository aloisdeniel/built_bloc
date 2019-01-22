/// An annotation used to subscribe a method to a bloc's [Stream].
class Listen {

  final String streamName;

  /// Creates a new [Listen] instance.
  const Listen(this.streamName);
}