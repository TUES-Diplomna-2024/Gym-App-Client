import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/pages/admin_panel/admin_panel_view_page.dart';
import 'package:gym_app_client/pages/exercise/exercise_search_page.dart';
import 'package:gym_app_client/pages/library/library_page.dart';
import 'package:gym_app_client/pages/profile/profile_page.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _tokenService = TokenService();
  final _pageController = PageController(initialPage: 1);

  bool _isCurrUserAdmin = false;
  bool _isLoading = true;
  List<Widget> _pages = [];
  int _currIndex = 1;

  @override
  void initState() {
    _setCurrentUserAdmin();
    super.initState();
  }

  Future<void> _setCurrentUserAdmin() async {
    final currUserRole = await _tokenService.getCurrUserRole();

    if (mounted) {
      setState(() {
        _isCurrUserAdmin = RoleConstants.adminRoles.contains(currUserRole);

        _pages = _isCurrUserAdmin
            ? [
                const LibraryPage(),
                const ExerciseSearchPage(),
                const AdminPanelViewPage(),
                ProfilePage(),
              ]
            : [const LibraryPage(), const ExerciseSearchPage(), ProfilePage()];

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          if (mounted) setState(() => _currIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined), label: "Library"),
          const NavigationDestination(
              icon: Icon(Icons.search_outlined), label: "Search"),
          if (_isCurrUserAdmin) ...{
            const NavigationDestination(
                icon: Icon(Icons.admin_panel_settings_outlined),
                label: "Admin Panel"),
          },
          const NavigationDestination(
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
