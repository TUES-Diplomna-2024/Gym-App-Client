import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/pages/exercise/exercise_add_in_workouts_page.dart';
import 'package:gym_app_client/pages/exercise/exercise_create_page.dart';
import 'package:gym_app_client/pages/exercise/exercise_view_page.dart';
import 'package:gym_app_client/pages/profile/profile_edit_page.dart';
import 'package:gym_app_client/pages/sign/signin_page.dart';
import 'package:gym_app_client/pages/sign/signup_page.dart';
import 'package:gym_app_client/pages/root_page.dart';
import 'package:gym_app_client/pages/workout/workout_view_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint("Route Args: ${args.toString()}");

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const RootPage());
      case "/signin":
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case "/profile-edit":
        try {
          List<dynamic> pageArgs = args as List;
          final userStartState = pageArgs[0] as UserProfileModel;
          final onProfileUpdated =
              pageArgs[1] as void Function(UserUpdateModel);

          return MaterialPageRoute(
            builder: (_) => ProfileEditPage(
              userStartState: userStartState,
              onProfileUpdated: onProfileUpdated,
            ),
          );
        } on Exception {
          return _errorRoute();
        }
      case "/exercise":
        String exerciseId = args.toString();
        return MaterialPageRoute(
            builder: (_) => ExerciseViewPage(exerciseId: exerciseId));
      case "/exercise-create":
        return MaterialPageRoute(builder: (_) => const ExerciseCreatePage());
      case "/exercise-add-in-workouts":
        String exerciseId = args.toString();
        return MaterialPageRoute(
            builder: (_) => ExerciseAddInWorkoutsPage(exerciseId: exerciseId));
      case "/workout":
        String workoutId = args.toString();
        return MaterialPageRoute(
            builder: (_) => WorkoutViewPage(workoutId: workoutId));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("Error!"),
          ),
        );
      },
    );
  }
}
