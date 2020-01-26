import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/models/local_forecast.dart';

abstract class Repository {

  ///signs the user into the app - returning a GoogleUser if successful
  Stream<GoogleUser> authenticateUser(final bool signInSilently);

  ///Fetches weather data for a specific location - where userEmail is the email of the Google Account
  ///And location is the location they wish to know more about
  Stream<LocalForecast> fetchWeatherDataForLocation(final String userEmail, String location);

  ///Fetches all saved locations for a specific email account registered to a GoogleUser
  ///This will allow more than one Google user to use the app and to have their own custom set of forecast locations
  Stream<List<LocalForecast>> fetchAllWeatherData(final String userEmail);

  ///Removes a location from the cache with the GoogleUser email address acting as the key - returning a bool regarding its success
  Future<bool> removeLocation(final String userEmail, final String location);

  ///Saves a new location to the cache with the GoogleUser email address acting as the key
  void saveNewLocation(final String userEmail, final String location);

  ///Signs user out of the app
  Future<void> signUserOut();
}