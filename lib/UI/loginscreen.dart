// Login Screen
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_flutter/UI/conversationlistscreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _uidController = TextEditingController();

  void _login() async {
    String uid = _uidController.text.trim();
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a UID")),
      );
      return;
    }

    await CometChatUIKit.login(
      uid,
      onSuccess: (User user) {
        debugPrint(" Login successful: ${user.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ConversationsScreen()),
        );
      },
      onError: (CometChatException e) {
        debugPrint(" Login failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.message}")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CometChat Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _uidController,
              decoration: InputDecoration(
                labelText: "Enter UID",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
