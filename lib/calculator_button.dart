import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFunction = false,
    this.isOperator = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isFunction;
  final bool isOperator;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    if (isOperator) {
      backgroundColor = Colors.amber.shade700;
    } else if (isFunction) {
      backgroundColor = Colors.grey;
    } else {
      backgroundColor = Colors.grey[850]!;
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: backgroundColor,
        foregroundColor: isFunction ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: label == '⌫'
            ? const Icon(Icons.backspace_outlined, size: 35, semanticLabel: '⌫')
            : Text(label, style: const TextStyle(fontSize: 35)),
      ),
    );
  }
}
