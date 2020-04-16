import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zendesk/zendesk_identity.dart';

extension on String {
  String get emptyIfNull => this ?? '';
}

class Zendesk {
  Zendesk._();

  static const MethodChannel _channel = MethodChannel('zendesk');

  static Zendesk _instance;

  static Zendesk getInstance() {
    _instance = _instance ?? Zendesk._();
    return _instance;
  }

  static Future<bool> initialize(
    String zendeskUrl,
    String appId,
    String clientId, {
    ZendeskIdentity identity,
  }) async {
    final Map<String, String> args = <String, String>{
      'appId': appId,
      'clientId': clientId,
      'url': zendeskUrl,
      'name': identity.name,
      'email': identity.email,
    };

    return await _channel.invokeMethod<bool>('initialize', args);
  }

  Future<bool> initializeChat(
    String accountKey, {
    String department,
    String appName,
  }) async {
    final Map<String, String> args = <String, String>{
      'accountKey': accountKey,
      'department': department,
      'appName': appName,
    };

    return await _channel.invokeMethod<bool>('initializeChat', args);
  }

  /// Leave all fields blank when anonymous visitor is expected
  ///
  /// is iOS and Zendesk SDK [note] is not used
  Future<bool> setVisitorInfo({
    String name,
    String email,
    String phoneNumber,
    String note,
  }) async {
    final Map<String, String> args = <String, String>{
      'name': name.emptyIfNull,
      'email': email.emptyIfNull,
      'phoneNumber': phoneNumber.emptyIfNull,
      'note': note.emptyIfNull,
    };

    return await _channel.invokeMethod<bool>('setVisitorInfo', args);
  }

  Future<bool> startChat() async {
    return await _channel.invokeMethod<bool>('startChat');
  }
}
