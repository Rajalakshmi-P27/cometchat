import 'package:cometchat_flutter/Logic/conversation_logic.dart';
import 'package:cometchat_flutter/UI/conversation_view.dart';

import 'package:flutter/material.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final conversationLogic = ConversationLogic();

  @override
  void initState() {
    super.initState();
    conversationLogic.initialize(context, setState);
  }

  @override
  void dispose() {
    conversationLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConversationView(
        context: context,
        logic: conversationLogic,
        onSelectTab: (index) =>
            setState(() => conversationLogic.selectedIndex = index),
      ),
    );
  }
}
