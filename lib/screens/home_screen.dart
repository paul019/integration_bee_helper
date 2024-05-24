import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/competition_planner_page.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_page.dart';
import 'package:integration_bee_helper/screens/mission_control_page/mission_control_page.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_wrapper.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/presentation_screen_two_wrapper.dart';
import 'package:integration_bee_helper/screens/settings_page/settings_page.dart';
import 'package:integration_bee_helper/services/basic_services/auth_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
      page: const MissionControlPage(),
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
    PageInfo(
      title: 'Settings',
      icon: const Icon(Icons.settings),
      page: const SettingsPage(),
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
                showDialog(
                  context: context,
                  builder: (context) => PointerInterceptor(
                    child: AlertDialog(
                      title: const Text('Choose presentation'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PresentationScreenWrapper(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Main presentation'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PresentationScreenTwoWrapper(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Side presentation'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.present_to_all),
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
        type: BottomNavigationBarType.fixed,
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
