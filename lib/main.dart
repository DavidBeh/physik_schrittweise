import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: MyInputForm(),
      ),
    );
  }
}

class MyInputForm extends StatefulWidget {
  final aController = TextEditingController();
  final deltaTController = TextEditingController();
  final tController = TextEditingController();

  MyInputForm({Key key}) : super (key: key) {
    aController.text = "9,81";
    deltaTController.text = "0,01";
    tController.text = "120";

  }

  @override
  _MyInputFormState createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  String yErrorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            MyTextField(
              controller: widget.aController,
              labelText: "a in m/s",
            ),
            SizedBox(width: 10,),
            MyTextField(
              controller: widget.deltaTController,
              labelText: "ΔT in s",
            ),
            SizedBox(width: 10,),
            MyTextField(
              controller: widget.tController,
              labelText: "t in s",
            ),
            SizedBox(width: 10,),
            SizedBox(
              child: FlatButton(
                height: 60,
                color: Colors.lightBlueAccent[100],
                onPressed: () {},
                child: Text("Berechnen"),

              )
            )
          ],
        ),
      ),
    );
  }
}
Future<void> _showMyDialog(String text, BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class MyTextField extends StatefulWidget {
  TextEditingController controller;
  double width;
  String labelText;

  MyTextField ({Key key, this.controller, this.width = 100, this.labelText}) :super(key:key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        controller: widget.controller,
      ),
    );
  }
}
