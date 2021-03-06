import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:fl_chart/fl_chart.dart';
import 'package:quiver/collection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:decimal/decimal.dart";
import 'berechnung.dart';
import "widget_input_verfahren.dart";
//import 'package:decimal/decimal.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //HomePage.route: (context) => HomePage(),
        GotArgumentsPage.route: (context) => GotArgumentsPage(),
        ResultsPage.route: (context) => ResultsPage(),
      },
      title: 'Physik Schrittweise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {
  PanelController panelController;
  @override
  void initState() {
    panelController = PanelController();
    super.initState();
  }

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        body: Center(
            child: Text("mitte")
        ),
        onPanelOpened: () {
          setState(() {
            isOpen = true;
          });
        },
        onPanelClosed: () {
          setState(() {
            isOpen = false;
          });
        },
        maxHeight: 300,
        collapsed: Container(
          color: Colors.blue[100],
          child: SizedBox.expand(
            child: FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Hinzufügen"),
              onPressed: isOpen ? null : () async {
                await panelController.open();
              },
            ),
          ),
        ),
        panel: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Drag"),
            FlatButton(
              child: Text("close"),
              onPressed: () async {
                if (panelController.isAttached)
                  await panelController.close();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Item $index"),
                  );
                },
              ),
            ),
          ],
        )
      )
    );
  }
}


class WidgetTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetFreierFallInput(),
    );
  }
}
class StartSeite extends StatefulWidget {
  @override
  _StartSeiteState createState() => _StartSeiteState();
}

class _StartSeiteState extends State<StartSeite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Physik Schrittweise"),
      ),
      body: SizedBox.expand(
        child: WidgetHinzufuegen(),
      ),
    );
  }
}


class FormArguments {
  Decimal a;
  Decimal deltaT;
  Decimal maxT;

  FormArguments(String a,String deltaT,String maxT) {
    this.a = Decimal.parse(a);
    this.deltaT = Decimal.parse(deltaT);
    this.maxT = Decimal.parse(maxT);
  }
}


class HomePage extends StatefulWidget {
  static const route = "/";

  HomePage({Key key}) : super (key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const url = "https://github.com/DavidBeh/physik_schrittweise";
    return Scaffold(
      appBar: AppBar(
        title: Text("Physik Schrittweise"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton.icon(
              icon: Icon(Icons.open_in_new),
              color: Colors.white,
              textColor: Colors.white,
              label: Text("Github"),
              onPressed: () async {
                if(await canLaunch(url)) {
                  await launch(url);
                }
                else throw "Could not launch $url";
              },
              borderSide: BorderSide(
                color: Colors.white,
                width: 2
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton.icon(
              icon: Icon(Icons.help_outline),
              color: Colors.white,
              textColor: Colors.white,
              label: Text("Über"),
              onPressed: (){
                showAboutDialog(
                  applicationName: "Schrittweise Fallberechnung Prototyp",
                  applicationVersion: "alpha",
                  context: context,
                );
              },
              borderSide: BorderSide(
                  color: Colors.white,
                  width: 2
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: MyInputForm(),
      )
    );
  }
}
calcAsync() {

}
Stream<StreamBerechnungSnapshot> StreamBerechnung(Decimal a, Decimal maxT, Decimal deltaT) async* {


  //List<Berechnung> listBerechnungen = new List<Berechnung>.empty(growable: true);

  var updateStopwatch = Stopwatch();
  var a_berechnung = Berechnung(
    t: Decimal.zero,
    y: Decimal.zero,
    a: a,
    v: Decimal.zero,
    durchgang: 0,
    deltaT: deltaT,
  );

  StreamBerechnungSnapshot snap = StreamBerechnungSnapshot(a_berechnung.t.toDouble(), false);
  snap.listBerechnungen.add(a_berechnung);
  yield snap;
  await Future.delayed(const Duration(milliseconds: 300), (){});
  updateStopwatch.start();
  do {
    a_berechnung = Berechnung(
      t: a_berechnung.ergebnis.t,
      y: a_berechnung.ergebnis.y,
      a: a_berechnung.ergebnis.a,
      v: a_berechnung.ergebnis.v,
      durchgang: a_berechnung.durchgang + 1,
      deltaT: deltaT,
    );
    snap.listBerechnungen.add(a_berechnung);
    snap.Update(a_berechnung.t / maxT, false);
    yield snap;

    if (updateStopwatch.elapsedMilliseconds > 100) {
      updateStopwatch.stop();
      await Future.delayed(const Duration(microseconds: 1), (){});
      updateStopwatch.reset();
      updateStopwatch.start();
    }
  } while (a_berechnung.t <= maxT);

  yield snap;

}
class StreamBerechnungSnapshot{
  double progress;
  bool fertig;
  List<Berechnung> listBerechnungen = List<Berechnung>.empty(growable: true);
  StreamBerechnungSnapshot(this.progress, this.fertig);
  Update(progress, fertg) {
    this.progress = progress;
    this.fertig = fertig;
  }
}

class Berechnung{
  Decimal t;
  Decimal y;
  Decimal a;
  Decimal v;
  Decimal deltaT;
  int durchgang;
  Ergebnis ergebnis;
  Berechnung.copy(Berechnung berechnung) {
    t = berechnung.t;
    y = berechnung.y;
    a = berechnung.a;
    v = berechnung.v;
    deltaT = berechnung.deltaT;
    durchgang = berechnung.durchgang;
    ergebnis = Ergebnis.copy(berechnung.ergebnis);
  }

  Berechnung({this.t, this.y, this.a, this.v, this.deltaT, this.durchgang = 0}) {
    t ??= Decimal.zero;
    y ??= Decimal.zero;
    a ??= Decimal.parse("-9.81");
    v ??= Decimal.zero;
    deltaT ??= Decimal.parse("0.1");
    var tneu = t + deltaT;
    var aneu = a;
    var vneu = v + aneu * deltaT;
    var yneu = y + vneu * deltaT;
    ergebnis = Ergebnis(aneu, vneu, yneu, tneu);
  }
}
class Ergebnis{
  Decimal a;
  Decimal v;
  Decimal y;
  Decimal t;
  Ergebnis.copy(Ergebnis ergebnis) {
    a = ergebnis.a;
    v = ergebnis.v;
    y = ergebnis.y;
    t = ergebnis.t;
  }
  Ergebnis(this.a, this.v, this.y, this.t);
}


class GotArgumentsPage extends StatefulWidget {
  static const route = "/arguments";

  GotArgumentsPage({Key key}) : super(key: key);


  @override
  _GotArgumentsPageState createState() => _GotArgumentsPageState();
}

class _GotArgumentsPageState extends State<GotArgumentsPage> {
  Stream stream;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final FormArguments args = ModalRoute.of(context).settings.arguments;
    stream = StreamBerechnung(args.a, args.maxT, args.deltaT);
    return Scaffold(
      appBar: AppBar(title: Text("Berechnung"),),
      body: Center(
        child: StreamBuilder(

          stream: stream,
          builder: (context, snapshotData) {


              if (snapshotData.hasData || snapshotData.data != null) {

              StreamBerechnungSnapshot snapshot = snapshotData.data;
              if (snapshotData.connectionState == ConnectionState.done) {

                return RaisedButton(
                  child: Text("Weiter"),
                  color: Colors.redAccent[100],
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      ResultsPage.route,
                      arguments: snapshot,);
                  },
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(value: snapshot.progress, ),
                    Text((snapshot.progress * 100).toInt().toString() + "%"),
                    Text("Berechnete Schritte :" + snapshot.listBerechnungen.length.toString())
                  ],
                ),
              );
            }
            else return CircularProgressIndicator();
          },
        )
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {

  static const route = "/results";

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final StreamBerechnungSnapshot args = ModalRoute.of(context).settings.arguments;
    List<int> colorCodes = <int>[50, 100, 200, 300, 400, 500, 600, 500, 400, 300, 200, 100];
    return Scaffold(
      appBar: AppBar(
        title: Text("Ergebnisse"),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SizedBox(
            child: Column(
              children: [
                Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text("Schritt",), flex: 2,),
                        Expanded(child: Text("t: " + args.listBerechnungen[0].t.toString()), flex: 5,),
                        Expanded(child: Text("y: " + args.listBerechnungen[0].y.toString()), flex: 5,),
                        Expanded(child: Text("v: " + args.listBerechnungen[0].v.toString()), flex: 5,),
                        Expanded(child: Text("a: " + args.listBerechnungen[0].a.toString()), flex: 5,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(

                    itemCount: args.listBerechnungen.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.lightBlue[colorCodes[index%12]],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child: Text((index+1).toString()), flex: 2, ),
                              Expanded(child: Text(args.listBerechnungen[index].ergebnis.t.toString()), flex: 5,),
                              Expanded(child: Text(args.listBerechnungen[index].ergebnis.y.toString()), flex: 5,),
                              Expanded(child: Text(args.listBerechnungen[index].ergebnis.v.toString()), flex: 5,),
                              Expanded(child: Text(args.listBerechnungen[index].ergebnis.a.toString()), flex: 5,),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 80, 10, 20),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: args.listBerechnungen.map((e) => FlSpot(
                        e.t.toDouble(), e.y.toDouble()
                      )).toList(),
                      barWidth: 1.5,
                      dotData: FlDotData(
                        show: false,
                      )
                    )
                  ]
                )
              ),
            ),
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows),
            label: "Tabelle",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Graph"
          ),
        ],
      ),
    );
  }
}


class MyInputForm extends StatefulWidget {
  final aController = TextEditingController();
  final deltaTController = TextEditingController();
  final maxTController = TextEditingController();

  MyInputForm({Key key}) : super (key: key) {
    aController.text = "-9.81";
    deltaTController.text = "0.01";
    maxTController.text = "10";

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
              labelText: "a in m/s²",
            ),
            SizedBox(width: 10,),
            MyTextField(
              controller: widget.deltaTController,
              labelText: "Δt in s",
            ),
            SizedBox(width: 10,),
            MyTextField(
              controller: widget.maxTController,
              labelText: "max t in s",
            ),
            SizedBox(width: 10,),
            SizedBox(
              child: FlatButton(
                height: 60,
                color: Colors.lightBlueAccent[100],
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    GotArgumentsPage.route,
                    arguments: FormArguments(
                        widget.aController.text,
                        widget.deltaTController.text,
                        widget.maxTController.text)
                  );
                },
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
