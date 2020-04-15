import 'package:flutter/material.dart';
import 'package:zendesk/zendesk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Zendesk zendesk;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const Text('initialize called inside initState'),
            RaisedButton(
              onPressed: () async {
                try {
                  final bool initialized =
                      await Zendesk.initialize('url', 'appId', 'clientId');

                  print('initialize $initialized');
                } catch (e) {
                  print(e.message);
                  print('no');
                }
                zendesk = Zendesk.getInstance();
              },
              child: const Text('initialize'),
            ),
            RaisedButton(
              onPressed: () {},
              child: const Text('initializeChat'),
            ),
          ],
        ),
      ),
    );
  }
}
