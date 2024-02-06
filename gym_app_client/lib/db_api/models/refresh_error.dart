import 'popup_info.dart';

class RefreshError {
  late final PopUpInfo popUpInfo;
  late final bool shouldSignOutUser;

  RefreshError({
    required this.popUpInfo,
    this.shouldSignOutUser = false,
  });
}
