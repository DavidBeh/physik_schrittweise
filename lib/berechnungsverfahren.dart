import 'dart:collection';
import 'dart:core';
import "package:decimal/decimal.dart";
import 'package:flutter/material.dart' show Color, Colors;
import 'package:quiver/collection.dart';

enum ParameterWichtigkeit { benotigt, optional }
enum WerteWichtigkeit { wichtig, interressant, nebensachlich, versteckt }

class Parameter {
  ParameterWichtigkeit wichtigkeit;
  String label;
  Parameter({this.label  = "", this.wichtigkeit = ParameterWichtigkeit.benotigt});
}



class Test<T>{
  T mainval;
}

class Werte<T> extends DelegatingList<T> {
  String label;
  String einheit;
  WerteWichtigkeit wichtigkeit;
  final List<T> _l = [];
  List<T> get delegate => _l;

// your custom methods
}


class Verfahren {
  Color visualColor = Colors.red;
  List<Parameter> parameter;
  List<Decimal> xAxis;
  List<Decimal> yAxis;
  List<List<Decimal>> _results;
  bool ParameterSpeichern(List<String> params) {
    return false;
  }
}

class FreiFallVerfahren extends Verfahren {
  FreiFallVerfahren() {
    parameter = [
      Parameter(
        label: "a",
        wichtigkeit: ParameterWichtigkeit.benotigt,
      ),
      Parameter(
        label: "t max",
        wichtigkeit: ParameterWichtigkeit.benotigt,
      ),
      Parameter(
        label: "Δt",
        wichtigkeit: ParameterWichtigkeit.benotigt,
      ),
    ];
  }
  @override
  bool ParameterSpeichern(List<String> params) {

  }
}