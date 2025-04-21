import Flutter
import UIKit

public class SojoLink {
  static public let shared = SojoLinkIosPlugin()

  private init() {}
}

public final class SojoLinkIosPlugin: NSObject, FlutterPlugin {
  private var eventSink: FlutterEventSink?

  private var initialLink: String?
  private var initialLinkSent = false
  private var latestLink: String?
  private var methodChannel: FlutterMethodChannel?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance: SojoLinkIosPlugin = SojoLink.shared
    instance.methodChannel = FlutterMethodChannel(
      name: "sojo_dynamic_links",
      binaryMessenger: registrar.messenger()
    )

    if let channel = instance.methodChannel {
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
    registrar.addApplicationDelegate(instance)
  }

  // Allow to capture links when apps also override application callbacks
  public func getLink(launchOptions: [AnyHashable : Any]?) -> URL? {
    guard let options = launchOptions else {
      return nil
    }

    // Custom URL
    if let url = options[UIApplication.LaunchOptionsKey.url] as? URL {
      return url
    }

    // Universal link
    else if let activityDictionary = options[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
      for key in activityDictionary.keys {
        if let userActivity = activityDictionary[key] as? NSUserActivity {
          if let url = userActivity.webpageURL {
            return url
          }
        }
      }
    }

    return nil
  }

  // Universal Links
  public func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]) -> Void
  ) -> Bool {
    
    if let url = userActivity.webpageURL {
      handleLink(url: url)
    }

    return false
  }

  // Custom URL schemes
  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    handleLink(url: url)
    return false
  }

  public func handleLink(url: URL) {
    let link = url.absoluteString
    latestLink = link
    if initialLink == nil {
      initialLink = link
    }

    var utmParameters: [String: String] = [:]
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if let queryItems = components?.queryItems {
      for item in queryItems {
        if item.name == "utm_campaign_id" {
          utmParameters["utm_campaign_id"] = item.value
        }
      }
    }

    let linkData: [String: Any] = [
      "link": link,
      "utmParameters": utmParameters
    ]

    // Send the data to Flutter throught method channel
    if let methodChannel = methodChannel {
      methodChannel.invokeMethod("SojoDynamicLink#onSuccess", arguments: linkData)
    }
  }
}