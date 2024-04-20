int isValidEmailOrUsername(String input) {
  final RegExp emailRegex =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  final RegExp usernameRegex = RegExp(
    r'^[a-zA-Z0-9_-]*$',
  );

  if (input.isEmpty) {
    return -1;
  } else if (emailRegex.hasMatch(input) || usernameRegex.hasMatch(input)) {
    return 1;
  } else {
    return -1;
  }
}

bool isValidPassword(String password) {
  return password.length >= 8 &&
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]')) &&
      password.contains(RegExp(r'[0-9]'));
}
