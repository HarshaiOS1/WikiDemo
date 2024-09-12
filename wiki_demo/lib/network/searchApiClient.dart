import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:wiki_demo/models/searchModel.dart';

class SearchApiClient {
  static const baseUrl =
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10';
  static const wikiWebURL = 'https://en.wikipedia.org/?curid=';
  final http.Client client;

  SearchApiClient({
    required this.client,
  }) : assert(client != null);

  Future<SearchModel> getSearchResult(String query) async {

    final searchUrl = '$baseUrl&gpssearch=$query';
    final searchResponse = await client.get(searchUrl as Uri);
    if (searchResponse.statusCode != 200) {
      throw Exception("Error calling search API");
    }
    final json = jsonDecode(searchResponse.body);
    //Save latest search result list to cache
    saveModel(json);
    return SearchModel.fromJson(json);
  }

  void saveModel(dynamic cacheModel) async {
    await initLocalStorage();
    print(cacheModel);
    localStorage.setItem("cacheModel", cacheModel);
  }

  Future<SearchModel> getModelFromCache() async {
    await initLocalStorage();
    Map<String, dynamic> data = localStorage.getItem('cacheModel') as Map<String, dynamic>;
    SearchModel model = SearchModel.fromJson(data);
    return model;
  }
}

class WikiConnectivity {
  Future<bool> hasConnectivity() async {
    var check = await Connectivity().checkConnectivity();
    if (check == ConnectivityResult.mobile ||
        check == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
