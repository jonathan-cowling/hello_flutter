import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  bool checked = false;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Router({
      "/": (_) => Container(),
      "/blue": (ctx) {
        final formKey = GlobalKey<FormState>();

        // TODO: use text editing controller and extract form to seperate class
        // TODO: checkbos field look at https://medium.com/saugo360/creating-custom-form-fields-in-flutter-85a8f46c2f41
        return Form(
              key: formKey,
              child: FractionallySizedBox(widthFactor: 1/3,
              child: Column(children: <Widget>[
               TextFormField(
                 decoration: InputDecoration(labelText: "Name"),
                 initialValue: name,
                 validator: (input) => input == "" ? "enter something" : null,
               ),
                FormField(validator: (args) => checked? null : "please check the box",
                    builder: (ctx) => Checkbox(value: checked, onChanged: (newChecked) {
                      setState(() {
                        checked = newChecked;
                      });
                    })
                ),
                RaisedButton(
                  child: Text("GO"),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      Navigator.of(ctx).pushNamed("/yellow");
                    }
                  }
                  )
              ]))
          );
      },
      "/yellow": (ctx) {
        return _BlockingPage();
      },
      "/unknown": (_) => Placeholder()
    }, "/blue", "/unknown");
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
      debugPrint("system onPop called");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(title: Text("leave all this yellowy goodness for blue?"),
        actions: <Widget>[
          RaisedButton(
              child: Text("NO"),
              textColor: Theme.of(ctx).colorScheme.onPrimary,
              onPressed: () {
                Navigator.pop(ctx);
              }
              ),
          FlatButton(child: Text("yes :("),
              onPressed: () {
            Navigator.pop(ctx);
            Navigator.pop(context);
          })
        ],)
      );
      return ;
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
    return Container(color: Colors.yellow, child: FlutterLogo());
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initializing state");
    _resisterOnPop();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("disposing state");
    _removeOnPop();
  }

}


