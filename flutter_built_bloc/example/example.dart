import 'bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_bloc/flutter_built_bloc.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocBuilder: (c) => ExampleBloc(), child: ExampleView());
  }
}

class ExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExampleBloc>(context);
    return SafeArea(
      top: false,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Center(
                    child: StreamBuilder<int>(
                        stream: bloc.count,
                        builder: (c, s) =>
                            Text(s.hasData ? s.data.toString() : "empty")))),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text("-1"),
                    onPressed: () => bloc.add.add(-1),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text("+1"),
                    onPressed: () => bloc.add.add(1),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text("Reset"),
              onPressed: () => bloc.reset.add(null),
            ),
          ]),
    );
  }
}
