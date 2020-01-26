import 'package:flutter/material.dart';

class TemperatureTile extends StatelessWidget {

  final String _temperature;
  final Color _color;

  TemperatureTile(this._temperature, this._color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text(
          _temperature,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        color: _color,
        height: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}


