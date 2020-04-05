package org.kruskall.audioevents

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

class AudioEventsBroadcastReceiver : BroadcastReceiver {
    private val channelBackToDart: MethodChannel?;

    constructor(channelBackToDart: MethodChannel?) {
        this.channelBackToDart = channelBackToDart
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action: String? = intent.action

        if (action == "com.spotify.music.playbackstatechanged") {
            val playing = intent.getBooleanExtra("playing", false)
            val positionInMs = intent.getIntExtra("playbackPosition", 0)

            channelBackToDart?.invokeMethod(
                    "playbackStateChanged",
                    listOf(playing, positionInMs))

        } else if (action == "com.spotify.music.metadatachanged") {
            val trackId = intent.getStringExtra("id")
            val artistName = intent.getStringExtra("artist")
            val albumName = intent.getStringExtra("album")
            val trackName = intent.getStringExtra("track")
            val trackLengthInSec = intent.getIntExtra("length", 0)

            channelBackToDart?.invokeMethod(
                    "metadataChanged",
                    listOf(trackName))
        }
    }
}