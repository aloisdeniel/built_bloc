/// An annotation used to specify that a field must be exposed as
/// a output [Stream].
class BlocStream {
  final Object seedValue;

  final Function onListen;

  /// Creates a new [BlocStream] instance.
  const BlocStream({this.seedValue, this.onListen});
}

const stream = BlocStream();
