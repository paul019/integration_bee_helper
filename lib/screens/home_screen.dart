import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/competition_planner_page.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_page.dart';
import 'package:integration_bee_helper/screens/mission_control_page/mission_control_page.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_wrapper.dart';
import 'package:integration_bee_helper/screens/settings_page/settings_page.dart';
import 'package:integration_bee_helper/services/basic_services/auth_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

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
  static List<PageInfo> pages = [];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel?>(context);

    pages = [
      PageInfo(
        title: MyIntl.of(context).missionControl,
        icon: const Icon(Icons.keyboard),
        page: const MissionControlPage(),
      ),
      PageInfo(
        title: MyIntl.of(context).competitionPlanner,
        icon: const Icon(Icons.list),
        page: const CompetitionPlannerPage(),
      ),
      PageInfo(
        title: MyIntl.of(context).integrals,
        icon: const Icon(Icons.edit),
        page: const IntegralsPage(),
      ),
      PageInfo(
        title: MyIntl.of(context).settings,
        icon: const Icon(Icons.settings),
        page: const SettingsPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(settings?.competitionName ?? MyIntl.of(context).appName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => _showPresentationDialog(context),
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

  void _showPresentationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: Text(MyIntl.of(context).choosePresentation),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const PresentationScreenWrapper(
                        type: PresentationScreenType.one,
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.looks_one_outlined),
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const PresentationScreenWrapper(
                        type: PresentationScreenType.two,
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.looks_two_outlined),
                iconSize: 60,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(MyIntl.of(context).cancel),
            ),
          ],
        ),
      ),
    );
  }
}
