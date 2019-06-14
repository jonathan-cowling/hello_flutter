import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() {
    return _PageState();
  }
}

class _PageState extends State<Page> {
  List<Tab> tabs = [
    Tab(text: "Summary"),
    Tab(text: "Accounts"),
    Tab(text: "Personal"),
    Tab(text: "Connections"),
    Tab(text: "Search History"),
    Tab(text: "Public Records",)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Column(children: [
          Container(child: TabBar(
            isScrollable: true,
            tabs: tabs,
            labelColor: Theme.of(context).textTheme.body1.color,
          )),
          Expanded(
            child: TabBarView(children: <Widget>[
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
            ]),
          ),
        ]),
    );
  }
}
