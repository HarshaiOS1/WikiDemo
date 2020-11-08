part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchRequest extends SearchEvent {
  final String query;

  const SearchRequest({@required this.query}) : assert(query != null);

  @override
  List<Object> get props => [query];
}

class CacheLoadRequest extends SearchEvent {
  const CacheLoadRequest();
  
  @override
  List<Object> get props => [];
}
