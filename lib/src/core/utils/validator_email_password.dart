class ValidatorEmailPassword {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.length < 6) return false;

    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUpperCase && hasSpecialChar;
  }
}
