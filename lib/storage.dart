import 'package:random_chat/models/identity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static const String _ALIAS_KEY = "alias";
  static const String _PROFILE_PICTURE_URL_KEY = "profile_picture_url";

  Future<void> saveIdentity(Identity identity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    await prefs.setString(_ALIAS_KEY, identity.alias);
    await prefs.setString(_PROFILE_PICTURE_URL_KEY, identity.profilePictureUrl);
    return;
  }

  Future<Identity> getIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String alias = await prefs.getString(_ALIAS_KEY);
    String profilePictureUrl = await prefs.getString(_PROFILE_PICTURE_URL_KEY);

    if(alias == null || profilePictureUrl == null) {
      return null;
    } else {
      return Identity(alias: alias, profilePictureUrl: profilePictureUrl);
    }
  }
}