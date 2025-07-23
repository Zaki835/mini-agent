import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyBrowserApp());
}

class MyBrowserApp extends StatelessWidget {
  const MyBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Agent Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const BrowserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final TextEditingController _urlController = TextEditingController();
  late WebViewController _webViewController;
  int _currentTabIndex = 0;
  final List<TabModel> _tabs = [
    TabModel(
      id: '1',
      title: 'New Tab',
      url: 'https://www.google.com',
    )
  ];

  @override
  void initState() {
    super.initState();
    _urlController.text = _tabs[_currentTabIndex].url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.blue),
              onPressed: _showAIModal,
            ),
            Expanded(
              child: TextField(
                controller: _urlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter URL',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (url) => _loadUrl(url),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showMenu,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _switchTab(index),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _currentTabIndex == index
                          ? Colors.blue[800]
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _tabs[index].title,
                          style: TextStyle(
                            color: _currentTabIndex == index
                                ? Colors.white
                                : Colors.grey[400],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          color: Colors.grey[400],
                          onPressed: () => _closeTab(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: WebView(
              initialUrl: _tabs[_currentTabIndex].url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
          Container(
            color: Colors.grey[850],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: _goBack,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.white,
                  onPressed: _goForward,
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  onPressed: _goHome,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  color: Colors.white,
                  onPressed: _reloadPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    setState(() {
      _tabs[_currentTabIndex].url = url;
      _urlController.text = url;
    });
    _webViewController.loadUrl(url);
  }

  void _switchTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _urlController.text = _tabs[index].url;
    });
  }

  void _closeTab(int index) {
    setState(() {
      _tabs.removeAt(index);
      if (_tabs.isEmpty) {
        _tabs.add(TabModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Tab',
          url: 'https://www.google.com',
        ));
      }
      _currentTabIndex = _currentTabIndex >= _tabs.length ? _tabs.length - 1 : _currentTabIndex;
    });
  }

  void _goBack() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    }
  }

  void _goForward() async {
    if (await _webViewController.canGoForward()) {
      await _webViewController.goForward();
    }
  }

  void _goHome() {
    _loadUrl('https://www.google.com');
  }

  void _reloadPage() {
    _webViewController.reload();
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[850],
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add, color: Colors.blue),
              title: const Text('New Tab', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _addNewTab();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to history screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Downloads', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to downloads screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.nightlight_round, color: Colors.blue),
              title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Toggle dark mode
              },
            ),
          ],
        );
      },
    );
  }

  void _showAIModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[850],
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'API Key',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      color: Colors.grey[400],
                      onPressed: () {},
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Task',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task completed (simulation)'),
                      ),
                    );
                  },
                  child: const Text('Run Task'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNewTab() {
    setState(() {
      _tabs.add(TabModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Tab',
        url: 'https://www.google.com',
      ));
      _currentTabIndex = _tabs.length - 1;
      _urlController.text = _tabs[_currentTabIndex].url;
    });
  }
}

class TabModel {
  final String id;
  String title;
  String url;

  TabModel({
    required this.id,
    required this.title,
    required this.url,
  });
}
