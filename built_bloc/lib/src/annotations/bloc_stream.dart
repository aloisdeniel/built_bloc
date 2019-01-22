/// An annotation used to specify that a field must be exposed as
/// an output [Stream].
class BlocStream {
  /// The name of the generated [Stream] property. If not precised, the
  /// name will be deduced from the annotated field name.
  final String name;

  /// Creates a new [BlocStream] instance.
  const BlocStream([this.name]);
}

/// Default [BlocStream] annotation.
const stream = BlocStream();
