import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyWebView(),
  ));
}

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool _isLoading = true;
  int _currentIndex = 0;
  double _progressValue = 0.0;

  final List<String> _urls = [
    "https://oumouexpress.com/",
    "https://oumouexpress.com/cart/",
    "https://oumouexpress.com/my-account/",
    "https://oumouexpress.com/aide/",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: Container(), // Supprime la barre Oumou Express
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: _urls[_currentIndex],
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onProgress: (int progress) {
                setState(() {
                  _progressValue = progress / 100;
                });
              },
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: Colors.green,
                      size: 40.0,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Chargement en cours...',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            if (_progressValue > 0 && _progressValue < 1)
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Color(0xffffffff),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFF6fbb9d),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Mon Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Aide',
          ),
        ],
      ),
    );
  }

  // Fonction pour charger une URL dans le WebView
  void loadUrl(String url) async {
    final controller = await _controller.future;
    controller.loadUrl(url);
  }

  // Fonction pour changer d'onglet
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _isLoading = true;
    });
    loadUrl(_urls[index]);
  }
}
