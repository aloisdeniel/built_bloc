/// An annotation used to specify that a field must be exposed as
/// an input [Sink].
class BlocSink {
  /// Creates a new [BlocSink] instance.
  const BlocSink();
}

/// Default [BlocSink] annotation.
const sink = BlocSink();