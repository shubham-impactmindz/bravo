import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'chat_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatListView(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
