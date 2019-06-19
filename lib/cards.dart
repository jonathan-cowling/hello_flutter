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
      "/": (_) => WillPopScope(child: Container(color: Colors.red),
      onWillPop: ()async {
        log("popping scope from route");
        return false;
      }),
      "/test": (_) => Container(color: Colors.green),
      "/test/a": (_) => Container(color: Colors.yellow),
      "/test/abc": (_) => WillPopScope(child: Container(color: Colors.blue),
          onWillPop: ()async {
            log("popping scope from inner route");
            return false;
          }),
      "/logo": (_) => FlutterLogo()
    },
        "/test/abc",
        "/logo"
    );
  }
}

class Router extends StatefulWidget {
  final Map<String, Widget Function(BuildContext)> routes;
  final String initial;
  final String unknown;
  
  Router(this.routes, this.initial, this.unknown);
  
  @override
  State<StatefulWidget> createState() {
    return _RouterState(routes, initial, unknown);
  }
}

class _RouterState extends State<Router> {
  final Map<String, Widget Function(BuildContext)> routes;
  final String initial;
  final String unknown;

  _RouterState(this.routes, this.initial, this.unknown);

  @override
  Widget build(BuildContext context) {
    return Container(child: WillPopScope(child:
    Navigator(
        initialRoute: initial,
        onUnknownRoute: (settings) => PageRouteBuilder(
            settings: settings,
            pageBuilder: (ctx, animIn, animOut) => routes[unknown](context)),
        onGenerateRoute: (settings) {
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (ctx, animIn, animOut) {
                  var route = routes[settings.name];
                  print(settings);
                  if (route == null) {
                    return routes[unknown](context);
                  }
                  return route(context);
                }
            );
        }),
        onWillPop: ()async {
      print("not popping, router state");
      return false;
    })
    );
  }
}