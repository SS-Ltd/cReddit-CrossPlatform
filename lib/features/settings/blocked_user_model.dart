class BlockedUserModel {
  const BlockedUserModel(
      {required this.username,
      required this.userphoto,
      required this.onPressed});

  final String username;
  final String userphoto;
  final void Function() onPressed;
}
