import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/dashboard_menu_card.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {'title': 'Profile', 'route': '/profile', 'icon': Icons.person},
      {'title': 'Course Schedule', 'route': '/schedule', 'icon': Icons.schedule},
      {'title': 'Campus Event', 'route': '/events', 'icon': Icons.event},
      {'title': 'Study Group', 'route': '/groups', 'icon': Icons.group},
      {'title': 'Campus Map', 'route': '/map', 'icon': Icons.map},
      {'title': 'Announcements', 'route': '/announcements', 'icon': Icons.announcement},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Life Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.indigo[50],
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: menus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];
            return DashboardMenuCard(
              title: menu['title'] as String,
              icon: menu['icon'] as IconData,
              onTap: () => context.push(menu['route'] as String),
            );
          },
        ),
      ),
    );
  }
}


