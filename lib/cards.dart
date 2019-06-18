import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart' as fluro;

class Page extends StatefulWidget {
  @override
  _PageState createState() {
    return _PageState();
  }
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {

    return Flow({
      "/": (_) => Padding(padding: EdgeInsets.all(0), child: Container(color: Colors.red)),
      "/test": (_) => Padding(padding: EdgeInsets.all(10), child: Container(color: Colors.green)),
      "/test/a": (ctx) => Padding(padding: EdgeInsets.all(0),
          child: Container(color: Colors.yellow, child: GestureDetector(onTap: (){
            Flow.of(ctx).pop();
          }))),
      "/test/abc": (ctx) => Padding(padding: EdgeInsets.all(30),
          child: Container(color: Colors.blue, child: GestureDetector(onTap: (){
            Flow.of(ctx).navigateTo("/test/a");
          }))),
      "/logo": (_) => FlutterLogo()
    },
        "/test/abc",
        "/logo"
    );
  }
}

class Flow extends StatefulWidget {
  final Map<String, Widget Function(BuildContext)> routes;
  final String initial;
  final String unknown;
  
  Flow(this.routes, this.initial, this.unknown);

  static FlowState of(BuildContext ctx) {
    return ctx.ancestorStateOfType(TypeMatcher<FlowState>());
  }
  
  @override
  State<StatefulWidget> createState() {
    return FlowState(routes, initial, unknown);
  }
}

class FlowState extends State<Flow> {
  final Map<String, Widget Function(BuildContext)> _routes;
  final String _initial;
  final String _unknown;
  final fluro.Router _router;

  FlowState._create(this._routes, this._initial, this._unknown, this._router);

  void navigateTo(String path) {
    _router.navigateTo(context, path);
  }
  
  void pop() {
    _router.pop(context);
  }
  
  factory FlowState(Map<String, Widget Function(BuildContext)> routes, String initial, String unknown) {
    final router = fluro.Router();
    routes.forEach((route, widget){
      router.define(route, handler: fluro.Handler(handlerFunc: (ctx, args) => widget(ctx)));
    });

    return FlowState._create(routes, initial, unknown, router);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Navigator(
        initialRoute: _initial,
        onGenerateRoute: _router.generator,
        onUnknownRoute: (settings) => PageRouteBuilder(
            settings: settings,
            pageBuilder: (ctx, animIn, animOut) => _routes[_unknown](ctx)),
        )
    );
  }
  
}