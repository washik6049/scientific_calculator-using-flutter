import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State {
  String _output = "0";
  String _expression = "";
  bool _calculatorOn = true; // Variable to control calculator state

  void _toggleCalculator() {
    setState(() {
      _calculatorOn = !_calculatorOn;
    });
  }

  void _onButtonPressed(String text) {
    if (!_calculatorOn) return; // If calculator is off, do nothing

    setState(() {
      if (text == "C") {
        _output = "0";
        _expression = "";
      } else if (text == "=") {
        try {
          _output = evalExpression(_expression).toString();
        } catch (e) {
          _output = "Error";
        }
        _expression = "";
      } else if (text == "sin" || text == "cos" || text == "tan" || text == "sqrt") {
        if (_output != "0") {
          try {
            double value = double.parse(_output);
            switch (text) {
              case "sin":
                _output = sin(value * pi / 180).toString(); 
                break;
              case "cos":
                _output = cos(value * pi / 180).toString(); 
                break;
              case "tan":
                _output = tan(value * pi / 180).toString(); 
                break;
              case "sqrt":
                _output = sqrt(value).toString();
                break;
            }
          } catch (e) {
            _output = "Error";
          }
        }
      } else {
        if (_output == "0") {
          _output = text;
        } else {
          _output += text;
        }
        _expression += text;
      }
    });
  }

  double evalExpression(String expression) {
    if (expression == "sin" || expression == "cos" || expression == "tan" || expression == "sqrt") {
      return double.parse(_output);
    } else {
      List<String> operands = expression.split(new RegExp(r'[-+*/]'));
      String operator = expression.replaceAll(RegExp(r'[0-9.]'), '');

      if (operands.length == 2 && operator.isNotEmpty) {
        double num1 = double.parse(operands[0]);
        double num2 = double.parse(operands[1]);

        switch (operator) {
          case '+':
            return num1 + num2;
          case '-':
            return num1 - num2;
          case '*':
            return num1 * num2;
          case '/':
            if (num2 != 0) {
              return num1 / num2;
            } else {
              throw Exception("Division by zero");
            }
          default:
            throw Exception("Invalid operator");
        }
      } else {
        return double.parse(expression);
      }
    }
  }

  Widget buildButton(String text) {
    return Expanded(
      child: OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.all(24.0),
          ),
          backgroundColor: _calculatorOn ? null : MaterialStateProperty.resolveWith((states) => Colors.grey.withOpacity(0.5)), // Disable button when calculator is off
        ),
        onPressed: () => _onButtonPressed(text),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        actions: [
          IconButton(
            icon: Icon(_calculatorOn ? Icons.power_settings_new : Icons.power_off),
            onPressed: _toggleCalculator,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(height: 0.0),
          Row(
            children: <Widget>[
              buildButton("sin"),
              buildButton("cos"),
              buildButton("tan"),
              buildButton("sqrt"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("/"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("*"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("0"),
              buildButton("C"),
              buildButton("="),
              buildButton("+"),
            ],
          ),
        ],
      ),
    );
  }
}