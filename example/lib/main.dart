import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sojo_link/sojo_link.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String deepLink = "";
  Map<String, dynamic> utmParam = {};

  @override
  void initState() {
    super.initState();
    SojoLink.instance.onLink.listen((pendingDynamicLink) {
      log("AppLink: ${pendingDynamicLink.link.toString()}");
      setState(() {
        deepLink = pendingDynamicLink.link.toString();
        utmParam = pendingDynamicLink.utmParameters;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Here is the Link",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  deepLink,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "UtmParameters $utmParam",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
    );
  }
}
