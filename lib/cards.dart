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
      "/": (_, _f) => Container(color: Colors.red),
      "/green": (_, _f) => Container(color: Colors.green),
      "/blue": (ctx, _) => GestureDetector(
          onTap: () {
            Navigator.of(ctx).pushNamed("/yellow");
          },
          child: Container(color: Colors.blue)
      ),
      "/yellow": (ctx, registerOnPop) {
        registerOnPop(() {
          Navigator.of(ctx).pop();
          return false;
        });
        return Container(color: Colors.yellow, child: FlutterLogo()
        );
      },
      "/unknown": (_, _f) => Placeholder()
    }, "/blue", "/unknown");
  }
}

class Router extends StatefulWidget {
  final Map<String,
      Widget Function(BuildContext, void Function(bool Function()))> routes;
  final String initial;
  final String unknown;

  Router(this.routes, this.initial, this.unknown);

  @override
  State<StatefulWidget> createState() {
    return _RouterState(routes, initial, unknown);
  }
}

class _RouterState extends State<Router> {
  final Map<String,
      Widget Function(BuildContext, void Function(bool Function()))> routes;
  final Map<String, bool Function()> _onPop = Map();
  final String initial;
  final String unknown;
  String _currentRoute;

  _RouterState(this.routes, this.initial, this.unknown);

  void _registerOnPop(String route, bool Function() onPop) {
    _onPop[route] = onPop;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: WillPopScope(
            child: Navigator(
                initialRoute: initial,
                onUnknownRoute: (settings) => PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (ctx, animIn, animOut) => routes[unknown](
                        context, (onPop) => _registerOnPop(null, onPop))),
                onGenerateRoute: (settings) {
                  return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (ctx, animIn, animOut) {
                        _currentRoute = settings.name;
                        var route = routes[_currentRoute];
                        print(settings);
                        if (route == null) {
                          return routes[unknown](ctx, (onPop) => _registerOnPop(null, onPop));
                        }
                        return route(ctx, (onPop) => _registerOnPop(_currentRoute, onPop));
                      });
                }),
            onWillPop: () async {
              final onPop = _onPop[_currentRoute];
              return onPop != null ? onPop() : true;
            }));
  }
}
