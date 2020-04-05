package org.kruskall.audioevents

import android.content.Context
import android.content.IntentFilter
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** AudioeventsPlugin */
public class AudioeventsPlugin: FlutterPlugin, MethodCallHandler {

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "audioevents")
    channel.setMethodCallHandler(AudioeventsPlugin());

    if (AudioeventsPlugin.channelBackToDart == null) {
      AudioeventsPlugin.channelBackToDart = channel;
    }

    AudioeventsPlugin.context = flutterPluginBinding.applicationContext
  }

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
    private var context: Context? = null

    @JvmStatic
    private var channelBackToDart: MethodChannel? = null;

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      AudioeventsPlugin.channelBackToDart = MethodChannel(registrar.messenger(), "audioevents")
      AudioeventsPlugin.channelBackToDart?.setMethodCallHandler(AudioeventsPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "initialize") {

      val filter = IntentFilter()
      filter.addAction("com.spotify.music.playbackstatechanged")
      filter.addAction("com.spotify.music.metadatachanged")
      AudioeventsPlugin.context?.registerReceiver(
              AudioEventsBroadcastReceiver(AudioeventsPlugin.channelBackToDart), filter)

      Log.d("AudioEventsPlugin", "Registered intent receiver")

      result.success("Awright")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
