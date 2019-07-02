import 'package:flutter_web/material.dart';
import 'package:hello_flutter/report.dart' as report;
import 'package:hello_flutter/cards.dart' as cards;
import 'package:hello_flutter/score.dart' as score;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super(key: null);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: FlutterLogo(), title: Text("Score")),
          BottomNavigationBarItem(icon: FlutterLogo(), title: Text("Report")),
          BottomNavigationBarItem(icon: FlutterLogo(), title: Text("Cards")),
        ],
        onTap: (i) { setState(() { _page = i; });
        },
      ),
      body: Pages(_page),
    );
  }
}

class Pages extends StatelessWidget {
  final int _pageIndex;

  Pages(this._pageIndex);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      score.Page(),
      report.Page(),
      cards.Page(),
    ];
    try {
      return pages[_pageIndex];
    } catch (e) {
      return Placeholder();
    }
  }
}
