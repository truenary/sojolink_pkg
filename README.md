# sojo_link

An alternative to Firebase Dynamic Links which offers similar API and setup, enabling seamless migration with minimal code changes.

Firebase Dynamic Links is shutting down in August 2025. SojoLink is your solution.
With this package you can quickly migration existing Firebase Dynamic Links to SojoLink.

[![pub package](https://img.shields.io/pub/v/sojo_link.svg)](https://pub.dev/packages/sojo_link)

## Getting Started

Setup your project with SojoLink and get started: https://sojolink.com

## Setup

### 1. Create a SojoLink account

1. Sign up at [https://sojolink.com](https://sojolink.com)
2. Create a new project
3. Navigate to Project Configuration

### 2. Configure your apps

#### Android Configuration
Add your Android app with the following details:
- App name
- Associated domain
- Package name
- SHA256 fingerprint

#### iOS Configuration
Add your iOS app with the following details:
- App name
- Associated domain
- Bundle ID
- Team ID
- Paths

### 3. Create Dynamic Links

After configuring your apps:

1. Navigate to "Dynamic Links" in your SojoLink dashboard
2. Click "Create Dynamic Link"
3. Configure your link:
   - Enter the Deep Link URL (the path you want to open in your app)
   - Set link behavior for iOS/Android
   - Configure fallback URLs for when the app isn't installed
   - Add optional UTM parameters for campaign tracking
4. Save your dynamic link to generate a short link
5. Use this short link in your marketing materials, social media, or sharing features

---

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  sojo_link: ^latest_version
```

Run:

```bash
flutter pub get
```

---

## Platform Integration

### Android Setup

Add the following to your `AndroidManifest.xml` inside the `<application>` tag:

```xml
<activity
    android:name=".MainActivity"
    android:launchMode="singleTask"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="https"
            android:host="www.example.com" />
    </intent-filter>
</activity>
```

> **Note:** Replace `www.example.com` with the deep link you added while creating dynamic links in your SojoLink project.


---

### iOS Setup

Update your `Info.plist` file with:

```xml
<!-- Custom URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>YOUR_DOMAIN</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>sojo-link</string> <!-- Replace with your  custom URL scheme -->
        </array>
    </dict>
</array>

<!-- Universal Links -->
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:YOUR_DOMAIN</string> <!-- Replace with your actual domain -->
</array>
```
> **Note:** Use the same domain that you configured for your dynamic links in your SojoLink project.

---

## Usage

### Import SojoLink Package

```dart
import 'package:sojo_link/sojo_link.dart';

void main() {
  runApp(MyApp());
}
```

### Listen for Dynamic Links

You can listen for dynamic links in your StatefulWidget:

```dart
import 'dart:developer';
import 'package:sojo_link/sojo_link.dart';

class _MyHomePageState extends State<MyHomePage> {
  String deepLink = '';
  Map<String, String> utmParam = {};

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() {
    SojoLink.instance.onLink.listen((pendingDynamicLink) {
      log("AppLink: ${pendingDynamicLink.link.toString()}");
      setState(() {
        deepLink = pendingDynamicLink.link.toString();
        utmParam = pendingDynamicLink.utmParameters;
      });
      
      // Handle the link here, e.g., navigate to a specific screen
      final Uri deepLinkUri = pendingDynamicLink.link;
      Navigator.pushNamed(context, deepLinkUri.path);
    });
  }
  
  // Rest of your widget implementation
}
```
---

### PendingDynamicLink Class

The `PendingDynamicLink` class provides:

```dart
class PendingDynamicLink {
  /// The dynamic link that was opened.
  final Uri link;
  
  /// Optional utm parameters from the dynamic link.
  final Map<String, String> utmParameters;
  
  PendingDynamicLink({
    required this.link,
    this.utmParameters = const {},
  });
}
```

---
