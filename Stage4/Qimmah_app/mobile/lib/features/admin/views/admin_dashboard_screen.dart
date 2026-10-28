import 'package:flutter/material.dart';

import 'manage_reviews_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المسارات'),
              Tab(text: 'التقييمات'),
              Tab(text: 'المستخدمين'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('قائمة المسارات')),
            ManageReviewsScreen(),
            Center(child: Text('قائمة المستخدمين')),
          ],
        ),
      ),
    );
  }
}