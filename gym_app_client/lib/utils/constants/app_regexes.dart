class AppRegexes {
  static const String emailRegex =
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

  static const String passwordRegex =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,16}$";

  static bool isValidEmail(String email) => RegExp(emailRegex).hasMatch(email);

  static bool isValidPassword(String password) =>
      RegExp(passwordRegex).hasMatch(password);
}
