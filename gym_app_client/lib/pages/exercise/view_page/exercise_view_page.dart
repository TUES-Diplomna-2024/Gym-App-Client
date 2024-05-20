import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/exercise/view_page/exercise_info_page.dart';
import 'package:gym_app_client/pages/exercise/view_page/exercise_records_page.dart';
import 'package:gym_app_client/pages/exercise/view_page/exercise_stats_page.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';

class ExerciseViewPage extends StatefulWidget {
  final String exerciseId;
  final void Function() onUpdate;

  const ExerciseViewPage({
    super.key,
    required this.exerciseId,
    required this.onUpdate,
  });

  @override
  State<ExerciseViewPage> createState() => _ExerciseViewPageState();
}

class _ExerciseViewPageState extends State<ExerciseViewPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: BackLeadingAppBar(
        title: "Exercise",
        context: context,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.info_outline),
              text: "Info",
            ),
            Tab(
              icon: Icon(Icons.equalizer_outlined),
              text: "Stats",
            ),
            Tab(
              icon: Icon(Icons.book),
              text: "Records",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExerciseInfoPage(
              exerciseId: widget.exerciseId, onUpdate: widget.onUpdate),
          ExerciseStatsPage(exerciseId: widget.exerciseId),
          ExerciseRecordsPage(exerciseId: widget.exerciseId),
        ],
      ),
    );
  }
}
