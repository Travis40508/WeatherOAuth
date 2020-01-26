import 'package:flutter/material.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';

class CustomLoadingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).appBarTheme.color,
        elevation: Constants.defaultElevation,
        child: Container(
          height: Constants.defaultLoadingTileHeight,
          width: SizeConfig.getPercentageOfScreenWidth(Constants.defaultLoadingTileWidthPercentage, context),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      ),
    );
  }
}
