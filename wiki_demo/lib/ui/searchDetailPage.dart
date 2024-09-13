import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../network/searchApiClient.dart';

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

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _controller = WebViewController.fromPlatformCreationParams(params);
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          setState(() {
            this.progress = progress / 100;
          });
          debugPrint('WebView is loading (progress : $progress%)');
        }, onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        }, onPageFinished: (String url) {
          setState(() {
            progress = 0;
          });
          debugPrint('Page finished loading: $url');
        }, onWebResourceError: (WebResourceError error) {
          debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
        }, onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            debugPrint('blocking navigation to ${request.url}');
            return NavigationDecision.prevent;
          }
          debugPrint('allowing navigation to ${request.url}');
          return NavigationDecision.navigate;
        }, onHttpError: (HttpResponseError error) {
          debugPrint('Error occurred on page: ${error.response?.statusCode}');
        }),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      _controller.setBackgroundColor(const Color(0x80000000));
    }

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller
        .loadRequest(Uri.parse(SearchApiClient.wikiWebURL + pageId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wiki Web"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (progress < 1.0)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
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
