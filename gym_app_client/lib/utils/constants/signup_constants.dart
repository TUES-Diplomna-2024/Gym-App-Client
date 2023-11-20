class SignUpConstants {
  static const int minUsernameLength = 6;
  static const int maxUsernameLength = 32;

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 16;

  static const int allowableYearsRange = 122;

  static const String emailRegEx =
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

  static const String passwordRegEx =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,16}$";
}
