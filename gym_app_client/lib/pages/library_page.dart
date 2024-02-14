import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/library_custom_exercises_page.dart';
import 'package:gym_app_client/pages/library_workouts_page.dart';

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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Library",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
