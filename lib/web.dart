// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'dart:async';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// class Myweb extends StatefulWidget {
 
//   YtubeState createState() => YtubeState();
 
// }
 
// class YtubeState extends State<Myweb>{
//   var link;
 
//   num position = 1 ;
 
//   final key = UniqueKey();
 
//   doneLoading(String A) {
//     setState(() {
//       position = 0;
//     });
//   }
 
//   startLoading(String A){
//     setState(() {
//       position = 1;
//     });
//   }

//   @override
//   void initState() { 
//     super.initState();
//     var box = Hive.box("football");
//      link = box.get('vidlink').toString();
//      print ("my link is " + link);
//   }
 
//   @override
//   Widget build(BuildContext context) {

//   return Scaffold(
//      appBar: AppBar(
//         title: Text('FACEBOOK')),
//       body: IndexedStack(
//       index: position,
//       children: <Widget>[
 
//       WebView(
//         initialUrl: link,
//         javascriptMode: JavascriptMode.unrestricted,
//         key: key ,
//         onPageFinished: doneLoading,
//         onPageStarted: startLoading,
//         navigationDelegate: (NavigationRequest request) {
//             if (request.url.startsWith('http://www.hesgoal.com')) {
//               print('blocking navigation to $request}');
              
//             }
//             else{
//             return NavigationDecision.prevent;
//             WebViewController controller;
//             controller.reload();
//             }
//         },
//         ),
 
//        Container(
//         color: Colors.white,
//         child: Center(
//           child: CircularProgressIndicator()),
//         ),
        
//       ])
//   );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView Example'),
        ),
        body: Container(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl: "https://flutter.dev/",
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                    )
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop: (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goBack();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goForward();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.reload();
                    }
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

J
