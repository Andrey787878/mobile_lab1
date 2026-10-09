class CalculatorLogic {
  static const int maxDigits = 12;
  static const Set<String> operators = {'+', '-', 'x', '/'};

  String _input = '0';
  String _expression = '0';
  double _value = 0;
  bool _startNewNumber = false;
  double _firstNumber = 0;
  String _currentOperator = '';

  String get display => _input.isEmpty ? formatNumber(_value) : _input;
  String get expression => _expression;
  bool get _hasError => !_value.isFinite;

  void onButtonPressed(String value) {
    switch (value) {
      case 'AC':
        clearCalculator();
      case '=':
        calculateResult();
      case '⌫':
        deleteLastDigit();
      case '.':
        handleInput(value);
      case '+/-':
        changeSign();
      case '!':
        calculateFactorial();
      default:
        if (operators.contains(value)) {
          selectOperator(value);
        } else if (value.length == 1 && int.tryParse(value) != null) {
          handleInput(value);
        }
    }
  }

  void clearCalculator() {
    _input = '0';
    _expression = '0';
    _value = 0;
    _firstNumber = 0;
    _currentOperator = '';
    _startNewNumber = false;
  }

  void handleInput(String value) {
    _prepareInput();
    final int digitCount = _input
        .replaceAll('-', '')
        .replaceAll('.', '')
        .length;
    if (digitCount >= maxDigits || (value == '.' && _input.contains('.'))) {
      return;
    }
    if (value == '.') {
      _input += value;
    } else if (_input == '0') {
      _input = value;
    } else if (_input == '-0') {
      _input = '-$value';
    } else {
      _input += value;
    }
    _value = double.parse(_input);
    _updateExpression();
  }

  void deleteLastDigit() {
    if (_startNewNumber) {
      return;
    }
    _input = _input.substring(0, _input.length - 1);
    if (_input.isEmpty || _input == '-') {
      _input = '0';
    }
    _value = double.parse(_input);
    _updateExpression();
  }

  void changeSign() {
    if (_hasError) {
      return;
    }
    if (_input.isEmpty || (_startNewNumber && _value == 0)) {
      _prepareInput();
    }
    _value = -_value;
    _input = _input.startsWith('-') ? _input.substring(1) : '-$_input';
    _updateExpression();
  }

  void calculateFactorial() {
    if (_hasError) {
      return;
    }
    _expression = _currentOperator.isEmpty
        ? '$display!'
        : '${formatNumber(_firstNumber)} $_currentOperator $display!';
    if (_value < 0 || _value > 170 || _value != _value.truncateToDouble()) {
      _setResult(double.nan);
      return;
    }
    double result = 1;
    final int number = _value.toInt();
    for (int i = 2; i <= number; i++) {
      result *= i;
    }
    _setResult(result);
  }

  void selectOperator(String operator) {
    if (_hasError) {
      return;
    }
    if (_currentOperator.isNotEmpty && _input.isNotEmpty) {
      calculateResult();
      if (_hasError) {
        return;
      }
    }
    _firstNumber = _value;
    _currentOperator = operator;
    _input = '';
    _startNewNumber = true;
    _expression = '${formatNumber(_value)} $operator';
  }

  void calculateResult() {
    if (_hasError) {
      return;
    }
    if (_currentOperator.isEmpty) {
      _startNewNumber = true;
      return;
    }
    _expression =
        '${formatNumber(_firstNumber)} $_currentOperator ${formatNumber(_value)} =';
    final double result = switch (_currentOperator) {
      '+' => _firstNumber + _value,
      '-' => _firstNumber - _value,
      'x' => _firstNumber * _value,
      '/' => _value == 0 ? double.nan : _firstNumber / _value,
      _ => double.nan,
    };
    _setResult(result);
    _firstNumber = 0;
    _currentOperator = '';
  }

  void _prepareInput() {
    if (_hasError) {
      clearCalculator();
    }
    if (!_startNewNumber) {
      return;
    }
    _input = '0';
    _value = 0;
    _startNewNumber = false;
  }

  void _updateExpression() {
    _expression = _currentOperator.isEmpty
        ? _input
        : '${formatNumber(_firstNumber)} $_currentOperator $_input';
  }

  void _setResult(double value) {
    _value = value;
    _input = formatNumber(value);
    _startNewNumber = true;
    if (_hasError) {
      _firstNumber = 0;
      _currentOperator = '';
    }
  }

  String formatNumber(double value) {
    if (!value.isFinite) {
      return 'Error';
    }
    if (value == 0) {
      return '0';
    }
    final List<String> parts = value.toStringAsPrecision(maxDigits).split('e');
    String number = parts.first;
    if (number.contains('.')) {
      while (number.endsWith('0')) {
        number = number.substring(0, number.length - 1);
      }
      if (number.endsWith('.')) {
        number = number.substring(0, number.length - 1);
      }
    }
    return parts.length == 1 ? number : '${number}e${parts.last}';
  }
}
