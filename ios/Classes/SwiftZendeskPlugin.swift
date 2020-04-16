import Flutter
import UIKit

import ZendeskCoreSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ChatProvidersSDK
import SupportSDK
import ChatSDK
import MessagingSDK

// documentation see: https://developer.zendesk.com/embeddables/docs/ios-unified-sdk/getting_started
public class SwiftZendeskPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zendesk", binaryMessenger: registrar.messenger())
        let instance = SwiftZendeskPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize": initialize(call, result)
        case "initializeChat": initializeChat(call, result)
        case "setVisitorInfo": setVisitorInfo(call, result)
        case "startChat": startChat(result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    public func initialize(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let error = FlutterError(code: "INITIALIZE_FAILED", message: "Failed to initialize", details: nil)
    
        guard let args = call.arguments else {
            result(error)
            return
        }

        if let mapOfArgs = args as? [String: String],
            let appId = mapOfArgs["appId"],
            let clientId = mapOfArgs["clientId"],
            let url = mapOfArgs["url"] {
            
            Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: url)
            
            let identity = Identity.createAnonymous()
            Zendesk.instance?.setIdentity(identity)
            Support.initialize(withZendesk: Zendesk.instance)
            
            let viewController = RequestUi.buildRequestList(with: [])
            
            // https://github.com/flutter/flutter/issues/25078#issuecomment-448500575
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
                
                result(true)
                return
            }
        } else {
            result(error)
        }
    }
    
    public func initializeChat(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let error = FlutterError(code: "INITIALIZE_CHAT_FAILED", message: "Failed to initialize chat", details: nil)
        
        guard let args = call.arguments else {
            result(error)
            return
        }
        
        if let mapOfArgs = args as? [String: String],
            let accountKey = mapOfArgs["accountKey"] {
            
            Chat.initialize(accountKey: accountKey, queue: .main)
            let config = ChatAPIConfiguration()
            
            if let department = mapOfArgs["department"] {
                config.department = department
            }
            
            if let visitor = mapOfArgs["appName"] {
                config.visitorPathOne = visitor
            }
            
            Chat.instance?.configuration = config
            
            
            result(true)
            return
            
        } else {
            result(error)
        }
    }
    
    public func setVisitorInfo(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let error = FlutterError(code: "SET_VISITOR_INFO_FAILED", message: "Failed to set visitor information", details: nil)
        
        guard let args = call.arguments else {
            result(error)
            return
        }
        
        if let mapOfargs = args as? [String: String],
            let name = mapOfargs["name"],
            let email = mapOfargs["email"],
            let phoneNumber = mapOfargs["phoneNumber"] {
            
            let visitorInfo = VisitorInfo(name: name, email: email, phoneNumber: phoneNumber)
            
            if let config: ChatAPIConfiguration = Chat.instance?.configuration {
                config.visitorInfo = visitorInfo
                Chat.instance?.configuration = config
                
                result(true)
                return
            }
        }
        
        result(error)
        
    }
    
    public func startChat(_ result: FlutterResult) {
        let error = FlutterError(code: "STARTING_CHAT_FAILED", message: "Failed to start chat", details: nil)
        
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Wahyoo Chat"

        let chatConfiguration = ChatConfiguration()
        chatConfiguration.isPreChatFormEnabled = false

        let chatEngine = try! ChatEngine.engine()
        let viewController = try! Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])

        // Present view controller
        // https://github.com/flutter/flutter/issues/25078#issuecomment-448500575
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
            
            result(true)
            return
        }
        
        result(error)
    }
}
