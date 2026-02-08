import 'package:dart_package_template/dart_package_template.dart';
import 'package:test/test.dart';

void main() {
  group('Calculator', () {
    test('adds two numbers', () {
      final calculator = Calculator();
      expect(calculator.add(2, 3), equals(5));
    });

    test('subtracts two numbers', () {
      final calculator = Calculator();
      expect(calculator.subtract(5, 3), equals(2));
    });

    test('multiplies two numbers', () {
      final calculator = Calculator();
      expect(calculator.multiply(4, 3), equals(12));
    });

    test('divides two numbers', () {
      final calculator = Calculator();
      expect(calculator.divide(10, 2), equals(5));
    });

    test('throws error on division by zero', () {
      final calculator = Calculator();
      expect(() => calculator.divide(10, 0), throwsArgumentError);
    });

    test('calculates using the calculate method', () {
      final calculator = Calculator();
      expect(calculator.calculate(2, Operation.add, 3), equals(5));
      expect(calculator.calculate(5, Operation.subtract, 3), equals(2));
      expect(calculator.calculate(4, Operation.multiply, 3), equals(12));
      expect(calculator.calculate(10, Operation.divide, 2), equals(5));
    });
  });
}
