part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class NoInternetConnection extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchModel searchModel;

  const SearchLoaded({@required this.searchModel})
      : assert(searchModel != null);

  @override
  List<Object> get props => [searchModel];
}

class SearchError extends SearchState {}
