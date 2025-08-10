import '../shared_pref.dart';

mixin AuthMixin {
  Future<String?> getToken() async {
    final String token = CacheHelper.getDataFromSharedPrefrence('access_token');
    return token;
  }
}