import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'messagescreen.dart';
import '../Logic/conversation_logic.dart';

class ConversationView extends StatelessWidget {
  final BuildContext context;
  final ConversationLogic logic;
  final void Function(int index) onSelectTab;

  const ConversationView({
    super.key,
    required this.context,
    required this.logic,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return CometChatConversations(
      showBackButton: false,
      appBarOptions: [
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xFFF5F5F5), width: 1),
          ),
          color: Color(0xFFFFFFFF),
          elevation: 4,
          menuPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          icon: Padding(
            padding: EdgeInsets.only(left: 12, right: 16),
            child: CometChatAvatar(
              width: 40,
              height: 40,
              image: CometChatUIKit.loggedInUser?.avatar,
              name: CometChatUIKit.loggedInUser?.name,
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case '/Create':
                onSelectTab(2);
                break;
              case '/logout':
                logic.logout();
                break;
            }
          },
          position: PopupMenuPosition.under,
          enableFeedback: false,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 44,
              padding: EdgeInsets.all(16),
              value: '/Create',
              child: Row(children: [
                Icon(Icons.add_comment_outlined,
                    color: Color(0xFFA1A1A1), size: 24),
                SizedBox(width: 8),
                Text("Create Conversation",
                    style: TextStyle(fontSize: 14, color: Color(0xFF141414))),
              ]),
            ),
            PopupMenuItem(
              height: 44,
              padding: EdgeInsets.all(16),
              value: '/name',
              enabled: false,
              child: Row(children: [
                Icon(Icons.account_circle_outlined,
                    color: Color(0xFFA1A1A1), size: 24),
                SizedBox(width: 8),
                Text(CometChatUIKit.loggedInUser?.name ?? "",
                    style: TextStyle(fontSize: 14, color: Color(0xFF141414))),
              ]),
            ),
            PopupMenuItem(
              height: 44,
              padding: EdgeInsets.all(16),
              value: '/logout',
              child: Row(children: [
                Icon(Icons.logout, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text("Logout",
                    style: TextStyle(fontSize: 14, color: Colors.red)),
              ]),
            ),
            PopupMenuItem(
              enabled: false,
              height: 44,
              padding: EdgeInsets.zero,
              value: '/version',
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
                ),
                padding: EdgeInsets.all(16),
                child: Text("V5.0.0_alpha1",
                    style: TextStyle(fontSize: 14, color: Color(0xFF727272))),
              ),
            ),
          ],
        ),
      ],
      conversationsStyle: CometChatConversationsStyle(
        avatarStyle: CometChatAvatarStyle(
          borderRadius: BorderRadius.circular(8),
          backgroundColor: const Color(0xFFFBAA75),
        ),
        badgeStyle: CometChatBadgeStyle(
          backgroundColor: const Color(0xFFF76808),
        ),
      ),
      onItemTap: (conversation) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagesScreen(
              user: conversation.conversationWith is User
                  ? conversation.conversationWith as User
                  : null,
              group: conversation.conversationWith is Group
                  ? conversation.conversationWith as Group
                  : null,
            ),
          ),
        );
      },
      addOptions: (conversation, controller, context) => [
        CometChatOption(
          id: "Archive",
          iconWidget: Icon(Icons.archive_outlined, color: Colors.grey),
          title: "Archive",
          onClick: () => logic.archiveConversation(conversation),
        ),
        CometChatOption(
          id: "Pin",
          iconWidget: Icon(Icons.push_pin_outlined, color: Colors.grey),
          title: "Pin",
          onClick: () => logic.pinConversation(conversation),
        ),
        CometChatOption(
          id: "Mark As Read",
          iconWidget: Icon(Icons.mark_chat_unread_outlined, color: Colors.grey),
          title: "Mark as unread",
          onClick: () => logic.markAsRead(conversation),
        ),
        CometChatOption(
          id: "Delete",
          iconWidget: Icon(Icons.delete_outline, color: Colors.red),
          title: "Delete",
          onClick: () => logic.deleteConversation(conversation),
        ),
      ],
      subtitleView: (context, conversation) {
        String subtitle = "";
        if (conversation.conversationWith is User) {
          User user = conversation.conversationWith as User;
          final dateTime = user.lastActiveAt ?? DateTime.now();
          subtitle =
              "Last Active at ${DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime)}";
        } else {
          Group group = conversation.conversationWith as Group;
          final dateTime = group.createdAt ?? DateTime.now();
          subtitle =
              "Created at ${DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime)}";
        }
        return Text(
          subtitle,
          style: TextStyle(
              color: Color(0xFF727272),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        );
      },
      datePattern: (conversation) => DateFormat('hh:mm a')
          .format(conversation.lastMessage?.sentAt ?? DateTime.now()),
    );
  }
}
