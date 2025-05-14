import 'package:cometchat_flutter/UI/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace these with your actual CometChat credentials
  const String appID = "275084e9c589298d";
  const String region = "in";
  const String authKey = "d325b3312898d83667bd2d9159729b5cbd30b008";

  // Build the UIKit settings
  UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
        ..subscriptionType = CometChatSubscriptionType.allUsers
        ..autoEstablishSocketConnection = true
        ..region = region
        ..appId = appID
        ..authKey = authKey)
      .build();

  // Initialize CometChat
  await CometChatUIKit.init(
    uiKitSettings: uiKitSettings,
    onSuccess: (String successMessage) {
      debugPrint("✅ CometChat initialized successfully: $successMessage");
    },
    onError: (CometChatException e) {
      debugPrint("❌ CometChat initialization failed: ${e.message}");
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CometChat Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
