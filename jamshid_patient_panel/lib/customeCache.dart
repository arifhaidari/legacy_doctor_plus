import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart';
class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._() : super(key,
      maxAgeCacheObject: Duration(days: 30),
      maxNrOfCacheObjects: 100);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
  Future<Response> getData(String url, Map<String, String> headers) async {
    var file = await DefaultCacheManager().getSingleFile(url, headers: headers);
    if (file != null && await file.exists()) {
      var res = await file.readAsString();
      return Response(res, 200);
    }
    return Response(null, 404);
  }
}