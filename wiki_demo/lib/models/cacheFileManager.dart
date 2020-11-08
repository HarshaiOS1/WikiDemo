import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CacheFileManger {
  Future<String> get _localPath async {
    final cacheDir =  await getTemporaryDirectory();
    return cacheDir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/wikiPage.txt');
  }

  Future<File> writeWikiPage(String wikiPage) async {
    final file = await _localFile;
    return file.writeAsString(wikiPage);
  }

  saveWebpageToCache(String wikiPageLink) async {
    var response = await http.get("");
    if(response.statusCode == 200){
      String htmlToParse = response.body;
      CacheFileManger().writeWikiPage(htmlToParse);
    }
  }

  Future<String> readWikiPage() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "Error Loading cache";
    }
  }
}