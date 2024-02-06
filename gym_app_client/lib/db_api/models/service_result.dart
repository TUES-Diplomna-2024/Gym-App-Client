import 'popup_info.dart';

class ServiceResult {
  late final PopUpInfo? popUpInfo;
  late final dynamic data;
  late final bool shouldSignOutUser;

  ServiceResult({
    this.popUpInfo,
    this.data,
    this.shouldSignOutUser = false,
  });
}
