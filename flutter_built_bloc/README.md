# flutter_built_bloc

Helper widgets for adopting the [BLoC pattern](https://medium.com/flutter-io/build-reactive-mobile-apps-in-flutter-companion-article-13950959e381) in combination with [built_bloc](https://github.com/aloisdeniel/built_bloc/built_bloc)

## BlocProvider

Create a `BlocProvider` and give him your `Bloc`.

```dart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(bloc: ExampleBloc(), child: ExampleView());
  }
}
```

You can then access it with the `BlocProvider.of` method :

```dart
class ExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExampleBloc>(context);
    // ...
  }
}
```


## How to use

### Install

```yaml
dependencies:
  flutter_built_bloc:
```