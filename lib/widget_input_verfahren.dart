import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class WidgetHinzufuegen extends StatefulWidget {
  @override
  _WidgetHinzufuegenState createState() => _WidgetHinzufuegenState();
}

class _WidgetHinzufuegenState extends State<WidgetHinzufuegen> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return FlatButton(
          child: Text("Freier Fall"),

        );
      },
    );
  }
}

class WidgetInputCard extends StatefulWidget {
  Widget child;
  WidgetInputCard({Key key, this.child}) : super (key: key);
  @override
  _WidgetInputCardState createState() => _WidgetInputCardState();
}

class _WidgetInputCardState extends State<WidgetInputCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Text(
                "Verfahren",
                style: Theme.of(context).primaryTextTheme.headline5
            ),
          ),
          Container(
            color: Color.fromARGB(200, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }
}


class WidgetFreierFallInput extends StatefulWidget {
  @override
  _WidgetFreierFallInputState createState() => _WidgetFreierFallInputState();
}

class _WidgetFreierFallInputState extends State<WidgetFreierFallInput> {
  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
    return WidgetInputCard(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"^\d*[.,]?\d*")),
              ] + List.generate(20, (index) => FilteringTextInputFormatter.deny(RegExp(r"(?<=[.,]\d{" + index.toString() + r"})[.,]\d*"))),
              decoration: InputDecoration(
                labelText: "a in m/s²",
                border: OutlineInputBorder(),
              ),
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }
}

