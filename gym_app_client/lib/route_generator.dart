import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/pages/exercise/exercise_add_to_workouts_page.dart';
import 'package:gym_app_client/pages/exercise/exercise_create_page.dart';
import 'package:gym_app_client/pages/exercise/exercise_edit_page.dart';
import 'package:gym_app_client/pages/exercise/view_page/exercise_view_page.dart';
import 'package:gym_app_client/pages/profile/profile_edit_page.dart';
import 'package:gym_app_client/pages/profile/profile_page.dart';
import 'package:gym_app_client/pages/sign/signin_page.dart';
import 'package:gym_app_client/pages/sign/signup_page.dart';
import 'package:gym_app_client/pages/root_page.dart';
import 'package:gym_app_client/pages/sign/welcome_page.dart';
import 'package:gym_app_client/pages/workout/workout_edit_page.dart';
import 'package:gym_app_client/pages/workout/workout_view_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint("Route Args: ${args.toString()}");

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const RootPage());
      case "/welcome":
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case "/signin":
        return MaterialPageRoute(builder: (_) => SignInPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case "/profile":
        List<dynamic> pageArgs = args as List;
        final String userId = pageArgs[0];
        final onUpdate = pageArgs[1] as void Function();

        return MaterialPageRoute(
            builder: (_) => ProfilePage(
                  userId: userId,
                  onUpdate: onUpdate,
                ));
      case "/profile-edit":
        List<dynamic> pageArgs = args as List;
        final userInitState = pageArgs[0] as UserProfileModel;
        final onUpdate = pageArgs[1] as void Function();

        return MaterialPageRoute(
          builder: (_) => ProfileEditPage(
            userInitState: userInitState,
            onUpdate: onUpdate,
          ),
        );
      case "/exercise":
        List<dynamic> pageArgs = args as List;
        String exerciseId = pageArgs[0];
        final onUpdate = pageArgs[1] as void Function();

        return MaterialPageRoute(
          builder: (_) =>
              ExerciseViewPage(exerciseId: exerciseId, onUpdate: onUpdate),
        );
      case "/exercise-create":
        final onUpdate = args as void Function();

        return MaterialPageRoute(
            builder: (_) => ExerciseCreatePage(onUpdate: onUpdate));
      case "/exercise-edit":
        List<dynamic> pageArgs = args as List;
        final exerciseInitState = pageArgs[0] as ExerciseViewModel;
        final onUpdated = pageArgs[1] as void Function();

        return MaterialPageRoute(
          builder: (_) => ExerciseEditPage(
            exerciseInitState: exerciseInitState,
            onUpdate: onUpdated,
          ),
        );
      case "/exercise-add-in-workouts":
        String exerciseId = args.toString();

        return MaterialPageRoute(
            builder: (_) => ExerciseAddToWorkoutsPage(exerciseId: exerciseId));
      case "/workout":
        List<dynamic> pageArgs = args as List;
        final String workoutId = pageArgs[0];
        final onUpdate = pageArgs[1] as void Function();

        return MaterialPageRoute(
            builder: (_) =>
                WorkoutViewPage(workoutId: workoutId, onUpdate: onUpdate));
      case "/workout-edit":
        List<dynamic> pageArgs = args as List;
        final workoutInitState = pageArgs[0] as WorkoutViewModel;
        final onUpdate = pageArgs[1] as void Function();

        return MaterialPageRoute(
          builder: (_) => WorkoutEditPage(
            workoutInitState: workoutInitState,
            onUpdate: onUpdate,
          ),
        );
      default:
        SystemNavigator.pop();
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
