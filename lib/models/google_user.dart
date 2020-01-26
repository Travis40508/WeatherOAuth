
class GoogleUser {

  final String _displayName;
  final String _email;

  GoogleUser(this._displayName, this._email);

  String get email => _email;

  String get displayName => _displayName;
}