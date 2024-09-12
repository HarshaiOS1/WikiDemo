import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiki_demo/network/searchApiClient.dart';

class SearchDetailPage extends StatefulWidget {
  final pageID;

  const SearchDetailPage(this.pageID, {super.key});

  @override
  createState() => _SearchDetailPage(pageID);
}

class _SearchDetailPage extends State<SearchDetailPage> {
  var pageId;
  int _stackToView = 1;
  String url = "";
  double progress = 0;

  _SearchDetailPage(this.pageId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wiki Web"),
      ),
      body: IndexedStack(
        index: _stackToView,
        alignment: Alignment.center,
        children: [
          // WebView(
          //   initialUrl: SearchApiClient.wikiWebURL + pageId.toString(),
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onPageFinished: (String url) {
          //     setState(() {
          //       _stackToView = 0;
          //     });
          //   },
          // ),
          Container(child: const Center(child: ProgressIndicatorWidget())),
        ],
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 65,
            width: 65,
            child: RefreshProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
