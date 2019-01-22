/// An annotation used to specify that a field must be exposed as
/// an input [Sink].
class BlocSink {
   final String name;

  /// Creates a new [BlocSink] instance.
  const BlocSink([this.name]);
}

/// Default [BlocSink] annotation.
const sink = BlocSink();