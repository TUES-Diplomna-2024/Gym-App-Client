import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/admin_panel/admin_panel_exercises_page.dart';
import 'package:gym_app_client/pages/admin_panel/admin_panel_users_page.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';

class AdminPanelViewPage extends StatefulWidget {
  const AdminPanelViewPage({super.key});

  @override
  State<AdminPanelViewPage> createState() => _AdminPanelViewPageState();
}

class _AdminPanelViewPageState extends State<AdminPanelViewPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Admin Panel",
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: "Users",
            ),
            Tab(
              icon: Icon(Icons.fitness_center),
              text: "Exercises",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [AdminPanelUsersPage(), AdminPanelExercisesPage()],
      ),
    );
  }
}
