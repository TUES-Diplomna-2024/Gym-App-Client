import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'library_custom_exercises_page.dart';
import 'library_workouts_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Library",
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.folder_outlined),
              text: "Workouts",
            ),
            Tab(
              icon: Icon(Icons.sports_gymnastics_outlined),
              text: "Custom Exercises",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LibraryWorkoutsPage(),
          LibraryCustomExercisesPage(),
        ],
      ),
    );
  }
}
