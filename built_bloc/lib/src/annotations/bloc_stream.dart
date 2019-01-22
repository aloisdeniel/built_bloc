/// An annotation used to specify that a field must be exposed as
/// an output [Stream].
class BlocStream {

  final String name;

  /// Creates a new [BlocStream] instance.
  const BlocStream([this.name]);
}

/// Default [BlocStream] annotation.
const stream = BlocStream();
