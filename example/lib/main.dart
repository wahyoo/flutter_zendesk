import 'package:flutter/material.dart';
import 'package:flutter_zendesk/zendesk.dart';
import 'package:flutter_zendesk/zendesk_identity.dart';
import 'package:zendesk_example/env.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(null),
    );
  }
}

class HomePageArguments {}

class HomePage extends StatefulWidget {
  const HomePage(this.args, {Key key}) : super(key: key);

  final HomePageArguments args;

  static const String routeName = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Zendesk zendesk = Zendesk.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          RaisedButton(
            onPressed: () async {
              try {
                final bool initialized = await Zendesk.initialize(
                  Env.ZENDESK_URL,
                  Env.ZENDESK_APP_ID,
                  Env.ZENDESK_CLIENT_ID,
                  identity: ZendeskIdentity(
                    name: 'Identity Name',
                    email: 'identity@email.com',
                  ),
                );

                print('initialize $initialized');
              } catch (e) {
                print(e.message);
                print('no');
              }
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
            onPressed: () async {
              try {
                final bool started = await zendesk.startChat();

                print(started);
              } catch (e) {
                print(e.message.toString());
              }
            },
            child: const Text('startChat'),
          ),
        ],
      ),
    );
  }
}
