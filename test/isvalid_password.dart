import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_validate.dart';

void main() {
  
  test('Valid password should return true', () {
    expect(isValidPassword('Password1'), true);
  });

  test('Password without uppercase letter should return false', () {
    expect(isValidPassword('password1'), false);
  });

  test('Password without lowercase letter should return false', () {
    expect(isValidPassword('PASSWORD1'), false);
  });

  test('Password without number should return false', () {
    expect(isValidPassword('Password'), false);
  });

  test('Password with less than 8 characters should return false', () {
    expect(isValidPassword('Pass1'), false);
  });

  test('Empty password should return false', () {
    expect(isValidPassword(''), false);
  });
}
