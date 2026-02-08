import 'dart:io';

import 'package:dart_package_template/dart_package_template.dart';

/// An interactive CLI example demonstrating advanced usage of the package.
void main() {
  final calculator = Calculator();

  // Ask the user for two numbers and an operation
  num? a, b;
  String? operation;

  while (a == null) {
    stdout.write('Enter the first number: ');
    final input = stdin.readLineSync();
    if (input != null) {
      a = num.tryParse(input);
      if (a == null) {
        print('Invalid number, please try again.');
      }
    }
  }

  while (operation == null) {
    stdout.write('Enter an operation (+, -, *, /): ');
    final input = stdin.readLineSync();
    if (input != null && ['+', '-', '*', '/'].contains(input)) {
      operation = input;
    } else {
      print('Invalid operation, please try again.');
    }
  }

  while (b == null) {
    stdout.write('Enter the second number: ');
    final input = stdin.readLineSync();
    if (input != null) {
      b = num.tryParse(input);
      if (b == null) {
        print('Invalid number, please try again.');
      }
    }
  }

  // Perform the calculation
  num result;
  Operation op = Operation.values.firstWhere(
    (e) => e.symbol == operation,
    orElse: () => throw ArgumentError('Unsupported operation'),
  );

  try {
    result = calculator.calculate(a.toDouble(), op, b.toDouble());
    print('Result: $a $operation $b = $result');
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}
