/// An annotation used to specify that a field must be exposed as
/// an input [Sink].
class BlocSink {
  /// The name of the generated [Sink] property. If not precised, the
  /// name will be deduced from the annotated field name.
  final String name;

  /// Creates a new [BlocSink] instance.
  const BlocSink([this.name]);
}

/// Default [BlocSink] annotation.
const sink = BlocSink();
