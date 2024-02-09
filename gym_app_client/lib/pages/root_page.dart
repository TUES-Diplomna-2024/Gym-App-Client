import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/library_page.dart';
import 'package:gym_app_client/pages/profile_page.dart';
import 'package:gym_app_client/pages/signin_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currPage = 1;
  final List<Widget> _pages = const [
    LibraryPage(),
    SignInPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            label: "Library",
          ),
          NavigationDestination(
              icon: Icon(Icons.search_outlined), label: "Search"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile")
        ],
        onDestinationSelected: (int index) {
          setState(() => _currPage = index);
        },
        selectedIndex: _currPage,
      ),
    );
  }
}
