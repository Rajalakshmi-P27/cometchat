import 'package:cometchat_flutter/UI/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class ConversationLogic with CometChatConversationEventListener {
  List<String> archivedConversations = [];
  List<String> pinnedConversations = [];
  Map<String, TypingIndicator> typingMap = {};
  List<Conversation> activeConversations = [];
  int selectedIndex = 0;

  late BuildContext context;
  late void Function(VoidCallback fn) setState;

  void initialize(BuildContext ctx, void Function(VoidCallback fn) setFn) {
    context = ctx;
    setState = setFn;
    _loadPersistedState();
    CometChatConversationEvents.addConversationListListener(
        "conversation_listener", this);
  }

  void dispose() {
    CometChatConversationEvents.removeConversationListListener(
        "conversation_listener");
  }

  void _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pinnedConversations = prefs.getStringList("pinnedConversations") ?? [];
      archivedConversations =
          prefs.getStringList("archivedConversations") ?? [];
    });
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("pinnedConversations", pinnedConversations);
    await prefs.setStringList("archivedConversations", archivedConversations);
  }

  void onTypingStarted(TypingIndicator typingIndicator) {
    if (_userIsNotBlocked(typingIndicator.sender)) {
      _setTypingIndicator(typingIndicator, true);
    }
  }

  void onTypingEnded(TypingIndicator typingIndicator) {
    if (_userIsNotBlocked(typingIndicator.sender)) {
      _setTypingIndicator(typingIndicator, false);
    }
  }

  bool _userIsNotBlocked(User user) =>
      user.blockedByMe != true && user.hasBlockedMe != true;

  void _setTypingIndicator(
      TypingIndicator typingIndicator, bool isTypingStarted) {
    final key = typingIndicator.receiverType == ReceiverTypeConstants.user
        ? typingIndicator.sender.uid
        : typingIndicator.receiverId;

    if (isTypingStarted) {
      typingMap[key] = typingIndicator;
    } else {
      typingMap.remove(key);
    }
    setState(() {});
  }

  void archiveConversation(Conversation conversation) {
    setState(() {
      activeConversations.remove(conversation);
      archivedConversations.add(conversation.conversationId!);
    });
    _persistState();
    _showSnackBar("Conversation archived");
  }

  void pinConversation(Conversation conversation) {
    if (!pinnedConversations.contains(conversation.conversationId)) {
      pinnedConversations.add(conversation.conversationId!);
      _persistState();
      _showSnackBar("Conversation pinned");
    }
  }

  void markAsRead(Conversation conversation) {
    if (conversation.lastMessage != null) {
      CometChat.markAsRead(
        conversation.lastMessage!,
        onSuccess: (_) => _showSnackBar("Marked as read"),
        onError: (error) => _showSnackBar("Failed: $error"),
      );
    }
  }

  void deleteConversation(Conversation conversation) {
    CometChat.deleteConversation(
      conversation.conversationId!,
      conversation.conversationType,
      onSuccess: (_) => _showSnackBar("Deleted successfully"),
      onError: (error) => _showSnackBar("Delete failed: $error"),
    );
  }

  void logout() async {
    try {
      await CometChat.logout(
        onSuccess: (_) {
          _clearSessionData();
          _showSnackBar("Logged out successfully");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        },
        onError: (error) => _showSnackBar("Logout failed: $error"),
      );
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("pinnedConversations");
    await prefs.remove("archivedConversations");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
