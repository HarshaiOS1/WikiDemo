import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_demo/bloc/search_bloc.dart';
import 'package:wiki_demo/models/searchModel.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wiki Search'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          searchField(context),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return resultWidget(state.searchModel);
                } else if (state is SearchError) {
                  return Center(
                      child: Text(
                    'Sorry no result found',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget resultWidget(SearchModel searchModel) {
    return ListView.builder(
      itemCount: searchModel.query.pages.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${index + 1}.',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: InkWell(
                child: Center(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.start,

                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              searchModel.query.pages[index].title,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            searchModel
                                .query.pages[index].terms.description.first,
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  print(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Please enter search text here',
          ),
          onChanged: (query) {
            if (query.length > 2) {
              print(query);
              BlocProvider.of<SearchBloc>(context).add(
                SearchRequest(query: query),
              );
            }
          }),
    );
  }
}
