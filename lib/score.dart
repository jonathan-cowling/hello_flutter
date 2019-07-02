import 'dart:math';

// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_web/material.dart';

class Page extends StatelessWidget {
  final Random _scoreGenerator = Random();
  final int _maxScore = 710;

  @override
  Widget build(BuildContext context) {
    var score = _scoreGenerator.nextInt(_maxScore);

    return Stack(children: <Widget>[
//      charts.PieChart(
//        <charts.Series<_Segment, int>>[
//          charts.Series<_Segment, int>(
//            id: "",
//            data: <_Segment>[
//              _Segment("full", score),
//              _Segment("empty", _maxScore - score),
//            ],
//            domainFn: (seg, i) => seg.size,
//            measureFn: (seg, i) => seg.size,
//          )
//        ],
//        defaultRenderer: new charts.ArcRendererConfig(
//            arcWidth: 20,
//            startAngle: 3 * pi / 4,
//            arcLength: 3 * pi / 2
//        ),
//      ),
      Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('your credit score is:',
                  style: Theme.of(context).textTheme.display1),
              Text('$score', style: Theme.of(context).textTheme.display2),
            ]),
      )
    ]);
  }

}

class _Segment {
  final String id;
  final int size;

  _Segment(this.id, this.size);
}