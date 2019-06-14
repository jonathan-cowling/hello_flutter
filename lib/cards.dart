import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() {
    return _PageState();
  }
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Router({
      "/": Container(color: Colors.red, padding: EdgeInsets.all(0)),
      "/test": Container(color: Colors.green, padding: EdgeInsets.all(30)),
      "/test/a": Container(color: Colors.yellow, padding: EdgeInsets.all(50)),
      "/test/abc": Container(color: Colors.blue, padding: EdgeInsets.all(60)),
      "/logo": FlutterLogo()
    },
        "/test/abc",
        "/logo"
    );
  }
}

class Router extends StatefulWidget {
  final Map<String, Widget> routes;
  final String initial;
  final String unknown;
  
  Router(this.routes, this.initial, this.unknown);
  
  @override
  State<StatefulWidget> createState() {
    return _RouterState(routes, initial, unknown);
  }
}

class _RouterState extends State<Router> {
  final Map<String, Widget> routes;
  final String initial;
  final String unknown;

  _RouterState(this.routes, this.initial, this.unknown);

  @override
  Widget build(BuildContext context) {
    return Container(child: Navigator(
        initialRoute: initial,
        onUnknownRoute: (settings) => PageRouteBuilder(
            settings: settings,
            pageBuilder: (ctx, animIn, animOut) => routes[unknown]),
        onGenerateRoute: (settings) {
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (ctx, animIn, animOut) {
                  var route = routes[settings.name];
                  print(settings);
                  if (route == null) {
                    return routes[unknown];
                  }
                  return route;
                }
            );
        })
    );
  }
  
}