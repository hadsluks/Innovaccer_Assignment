import 'package:flutter/material.dart';
import 'NewEntry.dart';
import 'Exit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Innovaccer Entrance"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("New Entry"),
              ),
              Tab(
                child: Text("Grant Exit"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[NewEntry(), Exit()],
        ),
      ),
    );
  }
}
