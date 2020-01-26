import 'package:flutter/material.dart';
import 'package:weather_oauth/utils/constants.dart';

class NoForecastsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Icon(Icons.wb_sunny),
            ),
            Text(
              Constants.addTileLabel,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}
