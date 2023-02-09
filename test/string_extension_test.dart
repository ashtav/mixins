// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:mixins/mixins.dart';

void main() {
  String price = Faker.price(5);
  test('Check price generator, result: $price', () {
    // expect contains Rp and length of number if 5
    expect(price.contains('Rp'), true);
    expect(price.numeric.toString().length, 5);
  });
}
