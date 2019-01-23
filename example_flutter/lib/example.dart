import 'package:example/example.dart';
import 'package:flutter/material.dart';

class ExampleView extends StatefulWidget {
  @override
  ExampleViewState createState() {
    return ExampleViewState();
  }
}

class ExampleViewState extends State<ExampleView> {
  ExampleBloc _bloc;

  @override
  void initState() {
    this._bloc = ExampleBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._bloc.dispose();
    this._bloc = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Center(
                    child: StreamBuilder<int>(
                        stream: this._bloc.count,
                        builder: (c, s) =>
                            Text(s.hasData ? s.data.toString() : "empty")))),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text("-1"),
                    onPressed: () => this._bloc.add.add(-1),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text("+1"),
                    onPressed: () => this._bloc.add.add(1),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text("Reset"),
              onPressed: () => this._bloc.reset.add(null),
            ),
          ]),
    );
  }
}
