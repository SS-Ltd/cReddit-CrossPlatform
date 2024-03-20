import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/forget_password.dart';

void main() {
  
  test('Chech isValidEmail is working properly', () {
    String username = '';
    int result1 = isValidEmail(username);
    expect(result1, -1);
    String username2 = 'test';
    int result2 = isValidEmail(username2);
    expect(result2, 1);
    String email = 'test@';
    int result3 = isValidEmail(email);
    expect(result3, -1);
    String email1 = 'usama.nasser';
    int result4 = isValidEmail(email1);
    expect(result4, -1);
    String email2 = 'usama.nasser@';
    int result5 = isValidEmail(email2);
    expect(result5, -1);
    String email3 = 'usama.nasser@com';
    int result6 = isValidEmail(email3);
    expect(result6, -1);
    String email4 = 'usama.nasser@.com';
    int result7 = isValidEmail(email4);
    expect(result7, -1);
    String email5 = 'usama.nasser@gamil.com';
    int result8 = isValidEmail(email5);
    expect(result8, 1);
  });
}