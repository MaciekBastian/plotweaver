import 'dart:math';

String randomId([int length = 16]) {
  final random = Random.secure();
  const chars =
      'QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890';

  final stringBuffer = StringBuffer();
  for (int i = 0; i < length; i++) {
    stringBuffer.write(chars[random.nextInt(chars.length)]);
  }

  return stringBuffer.toString();
}
