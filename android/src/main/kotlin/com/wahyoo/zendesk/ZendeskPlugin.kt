package com.wahyoo.zendesk

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import zendesk.chat.Chat
import zendesk.chat.ChatEngine
import zendesk.chat.VisitorInfo
import zendesk.core.AnonymousIdentity
import zendesk.core.Zendesk
import zendesk.messaging.MessagingActivity
import zendesk.support.Support
import zendesk.support.requestlist.RequestListActivity

/** ZendeskPlugin */
/// should migrate to v2: https://developer.zendesk.com/embeddables/docs/chat-sdk-v-2-for-android/introduction
@Suppress("unused", "RedundantVisibilityModifier")
public class ZendeskPlugin(var context: Context? = null) : FlutterPlugin, MethodCallHandler, ActivityAware {

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "zendesk")
        channel.setMethodCallHandler(ZendeskPlugin(flutterPluginBinding.applicationContext))
    }

    override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {}

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "zendesk")
            channel.setMethodCallHandler(ZendeskPlugin(registrar.context()))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "initializeChat" -> initializeChat(call, result)
            "setVisitorInfo" -> setVisitorInfo(call, result)
            "startChat" -> startChat(result)
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivity() {}

    /// channels
    private fun initialize(call: MethodCall, result: Result) {
        context?.let {
            val appId: String = call.argument("appId")!!
            val clientId: String = call.argument("clientId")!!
            val url: String = call.argument("url")!!

            Zendesk.INSTANCE.init(it, url, appId, clientId)
            val identity = AnonymousIdentity.Builder()

            if (call.hasArgument("name")) {
                val name: String = call.argument("name")!!
                identity.withNameIdentifier(name)
            }

            if (call.hasArgument("email")) {
                val email: String = call.argument("email")!!
                identity.withEmailIdentifier(email)
            }

            Zendesk.INSTANCE.setIdentity(identity.build())
            Support.INSTANCE.init(Zendesk.INSTANCE)

            // RequestListActivity.builder().show(it)
            result.success(true)
            return
        }

        result.error("INITIALIZE_FAILED", "Failed to initialize", null)
    }

    private fun buildIdentity(){}

    private fun initializeChat(call: MethodCall, result: Result) {
        val accountKey: String = call.argument("accountKey")!!
        Chat.INSTANCE.init(context!!, accountKey)

        val chatProvider = Chat.INSTANCE.providers()?.chatProvider()

        if (call.hasArgument("department")) {
            chatProvider?.setDepartment(call.argument<String>("department")!!, null)
        }

        result.success(true)
    }

    private fun setVisitorInfo(call: MethodCall, result: Result) {
        val profileProvider = Chat.INSTANCE.providers()?.profileProvider()

        val visitorInfo = VisitorInfo.builder()
                .withPhoneNumber(call.argument("name"))
                .withEmail(call.argument("email"))
                .withName(call.argument("phoneNumber"))
                .build()

        if (call.hasArgument("note")) {
            profileProvider?.setVisitorNote(call.argument("note")!!, null)
        }

        profileProvider?.setVisitorInfo(visitorInfo, null)
        result.success(true)
    }

    private fun startChat(result: Result) {
        context?.let {
            MessagingActivity.builder()
                    .withEngines(ChatEngine.engine())
                    .show(it)
        }

        result.error("STARTING_CHAT_FAILED", "Failed to start chat", null)
    }
}
