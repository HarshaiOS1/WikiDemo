import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wiki_demo/models/searchModel.dart';
import 'package:wiki_demo/network/searchApiClient.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchApiClient searchApiClient;

  SearchBloc({required this.searchApiClient})
      : assert(searchApiClient != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchRequest) {
      yield SearchLoading();
      try {
        var isConnected = await WikiConnectivity().hasConnectivity();
        if (!isConnected) {
          yield NoInternetConnection();
        } else {
          final SearchModel searchModel =
              await searchApiClient.getSearchResult(event.query);
          yield SearchLoaded(searchModel: searchModel);
        }
      } catch (_) {
        yield SearchError();
      }
    } else if (event is CacheLoadRequest) {
      yield SearchLoading();
      try {
        final SearchModel searchModel =
            await searchApiClient.getModelFromCache();
        yield SearchLoaded(searchModel: searchModel);
      } catch (_) {
        yield SearchError();
      }
    }
  }
}
