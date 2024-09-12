import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:wiki_demo/ui/homePage.dart';
import 'bloc/search_bloc.dart';
import 'network/searchApiClient.dart';

void main() {
  SearchApiClient searchApiClient = SearchApiClient(client: Client());
  runApp(MyApp(
    searchApiClient: searchApiClient
  ));
}

class MyApp extends StatelessWidget {
  final SearchApiClient searchApiClient;

  const MyApp({super.key, required this.searchApiClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Search',
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => SearchBloc(searchApiClient: searchApiClient),
        child: MyHomePage(),
      ),
    );
  }
}
