import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/tab_model.dart';
import '../widgets/tab_widget.dart';
import '../widgets/url_bar.dart';
import 'ai_modal.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late WebViewController _webViewController;
  final List<TabModel> _tabs = [
    TabModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Tab',
      url: 'https://www.google.com',
    )
  ];
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UrlBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBarWidget(
            tabs: _tabs,
            currentIndex: _currentTabIndex,
            onTabChanged: _switchTab,
            onTabClosed: _closeTab,
            onNewTab: _addNewTab,
          ),
          Expanded(
            child: WebView(
              initialUrl: _tabs[_currentTabIndex].url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) => _webViewController = controller,
              onPageStarted: (url) => _updateTabLoading(true),
              onPageFinished: (url) => _updateTabLoading(false),
            ),
          ),
          const NavigationBarWidget(),
        ],
      ),
    );
  }

  void _switchTab(int index) {
    setState(() => _currentTabIndex = index);
  }

  void _closeTab(int index) {
    setState(() {
      _tabs.removeAt(index);
      if (_tabs.isEmpty) _addNewTab();
      _currentTabIndex = _currentTabIndex >= _tabs.length ? _tabs.length - 1 : _currentTabIndex;
    });
  }

  void _addNewTab() {
    setState(() {
      _tabs.add(TabModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Tab',
        url: 'https://www.google.com',
      ));
      _currentTabIndex = _tabs.length - 1;
    });
  }

  void _updateTabLoading(bool isLoading) {
    setState(() {
      _tabs[_currentTabIndex] = _tabs[_currentTabIndex].copyWith(isLoading: isLoading);
    });
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Tab'),
            onTap: () {
              Navigator.pop(context);
              _addNewTab();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
