import 'package:flutter/material.dart';
import 'NewEntry.dart';
import 'Exit.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Root(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'newentry': (BuildContext context) => NewEntry(),
          'exit': (BuildContext context) => Exit(),
          'home': (BuildContext context) => Home(),
        },
        initialRoute: 'home',
      ),
    );
  }
}

class Root extends InheritedWidget {
  Root({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static Root of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Root) as Root;
  }

  @override
  bool updateShouldNotify(Root old) => true;
}
