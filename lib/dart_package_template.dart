library;

/// Enum of supported [Calculator] operations.
enum Operation {
  add('+'),
  subtract('-'),
  multiply('*'),
  divide('/');

  final String symbol;
  const Operation(this.symbol);
}

/// A simple [Calculator] with basic arithmetic operations.
class Calculator {
  /// Creates a new [Calculator] instance.
  const Calculator();

  /// Returns the sum of [a] and [b].
  double add(double a, double b) => a + b;

  /// Returns the result of subtracting [b] from [a].
  double subtract(double a, double b) => a - b;

  /// Returns the product of [a] and [b].
  double multiply(double a, double b) => a * b;

  /// Returns the result of dividing [a] by [b].
  ///
  /// Throws an [ArgumentError] if [b] is zero.
  double divide(double a, double b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }
    return a / b;
  }

  /// Performs the specified [operation] on [a] and [b].
  double calculate(double a, Operation operation, double b) {
    switch (operation) {
      case Operation.add:
        return add(a, b);
      case Operation.subtract:
        return subtract(a, b);
      case Operation.multiply:
        return multiply(a, b);
      case Operation.divide:
        return divide(a, b);
    }
  }
}
