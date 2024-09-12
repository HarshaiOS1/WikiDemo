import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_demo/bloc/search_bloc.dart';
import 'package:wiki_demo/models/searchModel.dart';
import 'package:wiki_demo/network/searchApiClient.dart';
import 'package:wiki_demo/ui/searchDetailPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiki Search'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          searchField(context),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return resultWidget(state.searchModel);
                } else if (state is SearchError) {
                  return const Center(
                      child: Text(
                    'Sorry no result found',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ));
                } else if (state is NoInternetConnection) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        const Text("No Internet Connection"),
                        ElevatedButton(
                          child: const Text("Load History",
                              style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            BlocProvider.of<SearchBloc>(context)
                                .add(CacheLoadRequest());
                          },
                        ),
                      ],
                    ),
                  );
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
      itemBuilder: (context, index) => SizedBox(
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('${index + 1}.',
                    style:
                        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: InkWell(
                  child: Center(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                searchModel.query.pages[index].title,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              searchModel
                                  .query.pages[index].terms.description.first,
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    loadWebContent(
                        context, searchModel.query.pages[index].pageid ?? 000);
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 50.0,
                    child: (searchModel.query.pages[index].thumbnail != null)
                        ? Image.network(
                            searchModel.query.pages[index].thumbnail!.source)
                        : const Icon(
                            Icons.image,
                            size: 40.0,
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  loadWebContent(BuildContext context, int pageId) async {
    print(SearchApiClient.wikiWebURL + pageId.toString());
    var isConnected = await WikiConnectivity().hasConnectivity();
    if (isConnected) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchDetailPage(pageId)));
    } else {
      showWikiSnackbar(context);
    }
  }

  showWikiSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("No Internet Connection..!"),
        backgroundColor: Colors.red[500],
      ),
    );
  }

  Widget searchField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: const InputDecoration(
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
