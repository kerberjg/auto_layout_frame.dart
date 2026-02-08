import 'package:dart_package_template/dart_package_template.dart';

void main() {
  final calculator = Calculator();

  final sum = calculator.add(10, 5);
  print('10 + 5 = $sum');

  final difference = calculator.subtract(10, 5);
  print('10 - 5 = $difference');

  final product = calculator.multiply(10, 5);
  print('10 * 5 = $product');

  final quotient = calculator.divide(10, 5);
  print('10 / 5 = $quotient');
}
