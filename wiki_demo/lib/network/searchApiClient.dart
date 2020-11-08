import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:wiki_demo/models/searchModel.dart';

class SearchApiClient {
  static const baseUrl =
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10';
  static const wikiWebURL = 'https://en.wikipedia.org/?curid=';
  final http.Client client;
  static LocalStorage storage = new LocalStorage('post');

  SearchApiClient({
    @required this.client,
  }) : assert(client != null);

  Future<SearchModel> getSearchResult(String query) async {
    final searchUrl = '$baseUrl&gpssearch=$query';
    final searchResponse = await this.client.get(searchUrl);
    if (searchResponse.statusCode != 200) {
      throw Exception("Error calling search API");
    }
    final json = jsonDecode(searchResponse.body);
    //Save latest search result list to cache
    saveModel(json);
    return SearchModel.fromJson(json);
  }

  void saveModel(dynamic cacheModel) async {
    await storage.ready;
    print(cacheModel);
    storage.setItem("cacheModel", cacheModel);
  }

  Future<SearchModel> getModelFromCache() async {
    await storage.ready;
    Map<String, dynamic> data = storage.getItem('cacheModel');
    if (data == null) {
      throw Exception("No Cache Data Found");
    }
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
