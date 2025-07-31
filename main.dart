import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MiniAgentApp());

class MiniAgentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Agent',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF121212),
        canvasColor: Color(0xFF1E1E1E),
      ),
      home: BrowserHome(),
    );
  }
}

class BrowserHome extends StatefulWidget {
  @override
  _BrowserHomeState createState() => _BrowserHomeState();
}

class _BrowserHomeState extends State<BrowserHome> {
  List<TabData> tabs = [];
  int current = 0;
  String apiKey = "";

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _addTab("https://example.com");
  }

  Future _loadApiKey() async {
    final sp = await SharedPreferences.getInstance();
    apiKey = sp.getString("apiKey") ?? "";
    setState(() {});
  }

  Future _saveApiKey(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString("apiKey", key);
    apiKey = key;
    setState(() {});
  }

  void _addTab(String url) {
    tabs.add(TabData(url));
    current = tabs.length -1;
    setState(() {});
  }

  void _closeTab(int idx) {
    tabs.removeAt(idx);
    if (current >= tabs.length) current = tabs.length -1;
    setState(() {});
  }

  void _openSettingsMenu() {
    showModalBottomSheet(
      backgroundColor: Color(0xFF1E1E1E), 
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: Icon(Icons.history), title: Text("History"), onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage()))),
          ListTile(leading: Icon(Icons.download), title: Text("Downloads"), onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => DownloadsPage()))),
          ListTile(leading: Icon(Icons.lock), title: Text("Password Save"), onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordsPage()))),
        ],
      )
    );
  }

  void _showAiDialog() {
    final ctrl = TextEditingController(text: apiKey);
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Color(0xFF1E1E1E),
      title: Text("My AI", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: ctrl, obscureText: true, style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: "API Key", labelStyle: TextStyle(color: Colors.grey))),
          SizedBox(height: 12),
          ElevatedButton(onPressed: (){
            _saveApiKey(ctrl.text);
            Navigator.pop(context);
          }, child: Text("Save"))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Agent"),
        actions: [
          IconButton(icon: Icon(Icons.add), tooltip: "New Tab", onPressed: ()=> _addTab("https://example.com")),
          IconButton(icon: Icon(Icons.person), tooltip: "My AI", onPressed: _showAiDialog),
          IconButton(icon: Icon(Icons.settings), tooltip: "Settings", onPressed: _openSettingsMenu),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(36),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
            children: List.generate(tabs.length, (i) => GestureDetector(
              onTap: ()=> setState(() => current = i),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal:4, vertical:6),
                padding: EdgeInsets.symmetric(horizontal:8, vertical:4),
                decoration: BoxDecoration(
                  color: i==current? Colors.blue : Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(children:[
                  Text("Tab ${i+1}", style: TextStyle(color: Colors.white)),
                  SizedBox(width:4),
                  GestureDetector(onTap: ()=> _closeTab(i), child: Icon(Icons.close, size:16, color: Colors.red)),
                ]),
              ),
            )),
          )),
        ),
      ),
      body: tabs.isEmpty ? Center(child: Text("No tabs", style: TextStyle(color: Colors.white))) :
        WebView(
          initialUrl: tabs[current].url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (c)=> tabs[current].controller = c,
        ),
    );
  }
}

class TabData {
  final String url;
  WebViewController? controller;
  TabData(this.url);
}

/// Placeholder pages

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // لاحقاً أمكننا إضافة logic لتسجيل وتخزين سجل التصفح
    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: Center(child: Text("History list here...", style: TextStyle(color: Colors.white))),
    );
  }
}

class DownloadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: Center(child: Text("Downloads list here...", style: TextStyle(color: Colors.white))),
    );
  }
}

class PasswordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passwords")),
      body: Center(child: Text("Password manager here...", style: TextStyle(color: Colors.white))),
    );
  }
}
