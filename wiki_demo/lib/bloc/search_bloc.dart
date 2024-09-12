import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wiki_demo/models/searchModel.dart';
import 'package:wiki_demo/network/searchApiClient.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchApiClient searchApiClient;

  SearchBloc({required this.searchApiClient})
      : super(SearchInitial()) {
    on<SearchRequest>(_onSearchRequest);
    on<CacheLoadRequest>(_onCacheLoadRequest);
  }

  Future<void> _onSearchRequest(
      SearchRequest event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      var isConnected = await WikiConnectivity().hasConnectivity();
      if (!isConnected) {
        emit(NoInternetConnection());
      } else {
        final SearchModel searchModel =
            await searchApiClient.getSearchResult(event.query);
        emit(SearchLoaded(searchModel: searchModel));
      }
    } catch (_) {
      emit(SearchError());
    }
  }

  Future<void> _onCacheLoadRequest(
      CacheLoadRequest event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final SearchModel searchModel = await searchApiClient.getModelFromCache();
      emit(SearchLoaded(searchModel: searchModel));
    } catch (_) {
      emit(SearchError());
    }
  }
}
