import 'package:flutter/material.dart';
import 'package:zendesk/zendesk.dart';
import 'package:zendesk_example/env.dart';

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
                  final bool initialized = await Zendesk.initialize(
                    Env.ZENDESK_URL,
                    Env.ZENDESK_APP_ID,
                    Env.ZENDESK_CLIENT_ID,
                  );

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
              onPressed: () async {
                final bool status = await zendesk.initializeChat(
                  Env.ZENDESK_ACCOUNT_KEY,
                  department: 'Customer Wahyoo Mart Staging',
                  appName: 'com.wahyoo_mobile.staging',
                );

                print(status);
              },
              child: const Text('initializeChat'),
            ),
            RaisedButton(
              onPressed: () async {
                final bool status = await zendesk.setVisitorInfo(
                  name: 'Visitor name',
                  phoneNumber: '08222222222',
                );

                print(status);
              },
              child: const Text('setVisitorInfo'),
            ),
            RaisedButton(
              onPressed: () {
                zendesk.startChat();
              },
              child: const Text('startChat'),
            ),
          ],
        ),
      ),
    );
  }
}
