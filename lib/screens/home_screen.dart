import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/competition_planner_page.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_page.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_wrapper.dart';
import 'package:integration_bee_helper/services/auth_service.dart';

class PageInfo {
  final String title;
  final Icon icon;
  final Widget page;

  PageInfo({required this.title, required this.icon, required this.page});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<PageInfo> pages = [
    PageInfo(
      title: 'Mission control',
      icon: const Icon(Icons.keyboard),
      page: Container(),
    ),
    PageInfo(
      title: 'Competition planner',
      icon: const Icon(Icons.list),
      page: const CompetitionPlannerPage(),
    ),
    PageInfo(
      title: 'Integrals',
      icon: const Icon(Icons.edit),
      page: const IntegralsPage(),
    ),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heidelberg Integration Bee'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PresentationScreenWrapper(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => AuthService.logOut(),
          icon: const Icon(Icons.logout),
        ),
      ),
      body: pages[selectedIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        items: pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: page.icon,
                label: page.title,
              ),
            )
            .toList(),
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
