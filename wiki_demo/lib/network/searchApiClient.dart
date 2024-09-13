import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_demo/models/searchModel.dart';

class SearchApiClient {
  static const baseUrl =
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10';
  static const wikiWebURL = 'https://en.wikipedia.org/?curid=';
  final http.Client client;
  final LocalStorage localStorage = LocalStorage('wiki_search_app');

  SearchApiClient({required this.client});

  Future<SearchModel> getSearchResult(String query) async {
    final searchUrl = Uri.parse('$baseUrl&gpssearch=$query');
    final searchResponse = await client.get(searchUrl);
    if (searchResponse.statusCode != 200) {
      throw Exception("Error calling search API");
    }
    final json = jsonDecode(searchResponse.body);

    // Save latest search result list to cache
    await saveModel(json);
    return SearchModel.fromJson(json);
  }

  Future<void> saveModel(dynamic cacheModel) async {
    await initLocalStorage();
    localStorage.setItem("cacheModel", json.encode(cacheModel));
  }

  Future<void> initLocalStorage() async {
    await localStorage.ready;
  }

  Future<SearchModel> getModelFromCache() async {
    await initLocalStorage();
    String? data = localStorage.getItem('cacheModel') as String?;
    if (data == null) throw Exception('No cached data found');
    Map<String, dynamic> jsonData = jsonDecode(data);
    return SearchModel.fromJson(jsonData);
  }
}

class WikiConnectivity {
  Future<bool> hasConnectivity() async {
    var check = await Connectivity().checkConnectivity();
    return check.first == ConnectivityResult.mobile || check.first == ConnectivityResult.wifi;
  }
}