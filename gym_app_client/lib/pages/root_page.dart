import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/library/library_page.dart';
import 'package:gym_app_client/pages/profile/profile_page.dart';
import 'package:gym_app_client/pages/sign/signin_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> _pages = const [
    LibraryPage(),
    SignInPage(),
    ProfilePage()
  ];

  final _pageController = PageController(initialPage: 1);
  int _currIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          if (mounted) setState(() => _currIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined), label: "Library"),
          NavigationDestination(
              icon: Icon(Icons.search_outlined), label: "Search"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile")
        ],
        onDestinationSelected: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(microseconds: 500),
            curve: Curves.ease,
          );
        },
        selectedIndex: _currIndex,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
