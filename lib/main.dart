import 'package:flutter/material.dart';

import 'calculator_button.dart';
import 'calculator_logic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorLogic calculator = CalculatorLogic();
  final List<List<String>> buttons = [
    ['⌫', 'AC', '!', '/'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['+/-', '0', '.', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            calculator.expression,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 140,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            calculator.display,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                            ),
                          ),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final row in buttons)
                            for (final label in row)
                              CalculatorButton(
                                label: label,
                                isFunction: const [
                                  '⌫',
                                  'AC',
                                  '!',
                                ].contains(label),
                                isOperator:
                                    CalculatorLogic.operators.contains(label) ||
                                    label == '=',
                                onPressed: () {
                                  setState(
                                    () => calculator.onButtonPressed(label),
                                  );
                                },
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
