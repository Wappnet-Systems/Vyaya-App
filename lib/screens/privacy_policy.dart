import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          title: Text(
            'Privacy Policy',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.secondary)
          ),
          elevation: 5,
        ),
        body: Stack(
          children: [
            // const Center(child:Text("Privacy Policy")),
            InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "https://docs.google.com/document/d/e/2PACX-1vQjb7AixWGbrJI6nDvCIvj_6gQhoq9Bei0IUHhfcUu3FJKe0WlbBOLwueHMh2ctkM07xfV0XM6-rY0d/pub"),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                }),
            _progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.blue,
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}
