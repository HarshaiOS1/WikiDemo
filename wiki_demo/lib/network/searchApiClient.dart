import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wiki_demo/models/searchModel.dart';

class SearchApiClient {
  static const baseUrl =
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10';
  final http.Client client;

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
    return SearchModel.fromJson(json);
  }
}
