import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

import 'eligability-form.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() {
    return _PageState();
  }
}

class PopWidgetsBindingObserver extends WidgetsBindingObserver {
  final Future<bool> Function() _didPopRouteHandler;

  @override
  Future<bool> didPopRoute()async {
    return _didPopRouteHandler != null
        ? await _didPopRouteHandler()
        : super.didPopRoute();
  }

  PopWidgetsBindingObserver._(this._didPopRouteHandler);

  factory PopWidgetsBindingObserver({Future<bool> Function() onPop}) {

    return PopWidgetsBindingObserver._(onPop != null ? onPop : ()async => false);
  }
}

class _PageState extends State<Page> {

  @override
  Widget build(BuildContext context) {
    return Router({
      "/": (_) => Container(),
      "/blue": (ctx) => EligibilityForm(),
      "/yellow": (ctx) {
        return _BlockingPage();
      },
    }, "/blue", "/blue");
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
  String _currentRoute;

  _RouterState(this.routes, this.initial, this.unknown);

  @override
  Widget build(BuildContext context) {
    return Container(
            child: Navigator(
                initialRoute: initial,
                onUnknownRoute: (settings) => PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (ctx, animIn, animOut) => routes[unknown](context)
                ),
                onGenerateRoute: (settings) {
                  return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (ctx, animIn, animOut) {
                        _currentRoute = settings.name;
                        var route = routes[_currentRoute];
                        print(settings);
                        if (route == null) {
                          return routes[unknown](ctx);
                        }
                        return route(ctx);
                      });
                })
    );
  }
}

class _BlockingPage extends StatefulWidget {
  @override
  _BlockingPageState createState() {
    return _BlockingPageState();
  }
}

class _BlockingPageState extends State<_BlockingPage> {

  PopWidgetsBindingObserver _popObserver;

  _BlockingPageState() {
    this._popObserver = PopWidgetsBindingObserver(onPop: ()async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(title: Text("Do you really want to go back?"),
        actions: <Widget>[
          RaisedButton(
              child: Text("no"),
              textColor: Theme.of(ctx).colorScheme.onPrimary,
              onPressed: () {
                Navigator.pop(ctx);
              }
              ),
          FlatButton(child: Text("yes"),
              onPressed: () {
            Navigator.pop(ctx);
            Navigator.pop(context);
          })
        ])
      );
    });
  }

  void _resisterOnPop() {
    WidgetsBinding.instance.addObserver(_popObserver);
  }

  void _removeOnPop() {
    WidgetsBinding.instance.removeObserver(_popObserver);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: FlutterLogo());
  }

  @override
  void initState() {
    super.initState();
    _resisterOnPop();
  }

  @override
  void dispose() {
    super.dispose();
    _removeOnPop();
  }

}


