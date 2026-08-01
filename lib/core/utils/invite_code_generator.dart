import 'dart:math';

class InviteCodeGenerator {
  InviteCodeGenerator._();

  static const _characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  static final Random _random = Random();

  static String generate({
    int length = 8,
  }) {
    return List.generate(
      length,
      (_) => _characters[_random.nextInt(_characters.length)],
    ).join();
  }
}
