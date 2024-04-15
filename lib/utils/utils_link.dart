
bool linkFormat(String userInput) {

  RegExp urlRegex = RegExp(
      r'^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9]+)+[\S]*$');

  if (urlRegex.hasMatch(userInput)) {
    return true;
  } else {
    return false;
  }
}