import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_validate.dart';

void main() {
  
  test('Chech isValidEmailOrUsername is working properly', () {
    String username = '';
    int result1 = isValidEmailOrUsername(username);
    expect(result1, -1);
    String username2 = 'test';
    int result2 = isValidEmailOrUsername(username2);
    expect(result2, 1);
    String email = 'test@';
    int result3 = isValidEmailOrUsername(email);
    expect(result3, -1);
    String email1 = 'usama.nasser';
    int result4 = isValidEmailOrUsername(email1);
    expect(result4, -1);
    String email2 = 'usama.nasser@';
    int result5 = isValidEmailOrUsername(email2);
    expect(result5, -1);
    String email3 = 'usama.nasser@com';
    int result6 = isValidEmailOrUsername(email3);
    expect(result6, -1);
    String email4 = 'usama.nasser@.com';
    int result7 = isValidEmailOrUsername(email4);
    expect(result7, -1);
    String email5 = 'usama.nasser@gamil.com';
    int result8 = isValidEmailOrUsername(email5);
    expect(result8, 1);
  });
}