import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/forget_password.dart';

void main() {
  
  test('Chech isValidEmail is working properly', () {
    String email = '';
    int result1 = isValidEmail(email);
    expect(result1, -1);
    String email2 = 'test';
    int result2 = isValidEmail(email2);
    expect(result2, -1);
  });
}