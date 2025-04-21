package com.truenary.sojo_link;

import androidx.annotation.NonNull;


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.NewIntentListener;

import android.net.Uri;
import android.os.Handler;
import org.json.JSONObject;
import android.app.Activity;
import android.content.Intent;

import android.util.Log;
import java.util.HashMap;
import java.util.Map;

public class SojoLinkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
    private static final String TAG = "SojoLinkPlugin";
    // Make sure this matches your Dart channel name
    private static final String CHANNEL = "sojo_dynamic_links";
    private MethodChannel channel;
    private Activity activity;
    private Handler mainHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);
        Log.d(TAG, "SojoLinkPlugin attached to engine");
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        result.notImplemented();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addOnNewIntentListener(this);
        processIntent(activity.getIntent());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public boolean onNewIntent(Intent intent) {
        if (intent != null) {
            // Process the new intent
            processIntent(intent);
            return true;
        }
        Log.d(TAG, "Received null intent");
        return false;
    }

    /**
     * Processes an intent to extract dynamic link information.
     * Extracts the base URL and UTM parameters from the intent's data URI.
     * Sends the extracted data to Flutter through the method channel.
     */
    private void processIntent(Intent intent) {

        Uri linkUri = intent.getData();
        if (linkUri == null) {
            Log.d(TAG, "No URI data in the intent");
            return;
        }

        // Prepare data to send to Flutter
        Map<String,Object> linkData = new HashMap<>();

        // Extract the base URL (scheme + host + path)
        String baseUrl = linkUri.getScheme() + "://" + linkUri.getHost() + linkUri.getPath();

        Map<String, String> utmParameters = new HashMap<>();
        String utmCampaignId = linkUri.getQueryParameter("utm_campaign_id");

        // Extract UTM parameters
        if (utmCampaignId != null && !utmCampaignId.trim().isEmpty()) {
            utmParameters.put("utm_campaign_id", utmCampaignId);
        }

        // Build the complete link data
        linkData.put("link",baseUrl);
        linkData.put("utmParameters",utmParameters);

        // Send the data to Flutter if the channel is available
        if (channel != null) {
            channel.invokeMethod("SojoDynamicLink#onSuccess", linkData);
        } else {
            Log.e(TAG, "Channel is null, cannot send data to Flutter");
        }

    }
}