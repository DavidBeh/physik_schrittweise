import 'dart:math';

import "package:decimal/decimal.dart";
import 'package:flutter/cupertino.dart';
import 'package:physik_schrittweise/main.dart';

class Formel {
  int y = 0;
}

class Verfahren {
  Ergebnis startErgebnis;
  Ergebnis _letztesErgebnis;
  void Berechne() {

  }
}

class Ergebnis{

}
class SwFreiFallErgebnis extends Ergebnis{
  Decimal h;
  Decimal a;
  Decimal v;
  Decimal tMax;
  Decimal deltaT;
  Decimal t;
  SwFreiFallErgebnis({this.h, this.a, this.v, this.tMax, this.deltaT, this.t});
}
class SwFreiFallVerfahren extends Verfahren {

  @override
  SwFreiFallErgebnis get startErgebnis => super.startErgebnis;
  @override
  SwFreiFallErgebnis get _letztesErgebnis => super._letztesErgebnis ?? startErgebnis;
  var ergebnisse = List<SwFreiFallErgebnis>.empty(growable: true);
  SwFreiFallVerfahren({Decimal h, Decimal a, Decimal tMax, Decimal deltaT, Decimal v}) :super() {
    startErgebnis.h = h ?? Decimal.zero;
    startErgebnis.a = a ?? Decimal.parse("9.81");
    startErgebnis.tMax = tMax ?? Decimal.one;
    startErgebnis.deltaT = deltaT ?? Decimal.one;
    startErgebnis.v = v ?? Decimal.zero;
    ergebnisse.add(startErgebnis);
  }

  @override
  void Berechne() {
    while (_letztesErgebnis.t < startErgebnis.tMax) {
      var t = _letztesErgebnis.t + startErgebnis.deltaT;
      var a = startErgebnis.a;
      var v = _letztesErgebnis.v + a * startErgebnis.deltaT;
      var h = _letztesErgebnis.h + v * _letztesErgebnis.deltaT;
      var neu = SwFreiFallErgebnis(
        t: t,
        a: a,
        v: v,
        h: h,
        deltaT: startErgebnis.deltaT,
        tMax: startErgebnis.tMax);
      _letztesErgebnis = neu;
      ergebnisse.add(neu);
    }
  }

}