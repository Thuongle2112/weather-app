import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherRadarPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherRadarPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<WeatherRadarPage> createState() => _WeatherRadarPageState();
}

class _WeatherRadarPageState extends State<WeatherRadarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WebViewController _rainController;
  late WebViewController _windController;
  late WebViewController _cloudController;
  late WebViewController _tempController;

  final Map<int, bool> _loadingStates = {0: true, 1: true, 2: true, 3: true};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeControllers();
  }

  String _buildWindyUrl(String overlay) {
    return 'https://embed.windy.com/embed2.html?lat=${widget.latitude}&lon=${widget.longitude}&zoom=5&overlay=$overlay';
  }

  void _initializeControllers() {
    _rainController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _loadingStates[0] = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _loadingStates[0] = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(_buildWindyUrl('rain')));

    _windController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _loadingStates[1] = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _loadingStates[1] = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(_buildWindyUrl('wind')));

    _cloudController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _loadingStates[2] = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _loadingStates[2] = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(_buildWindyUrl('clouds')));

    _tempController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _loadingStates[3] = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _loadingStates[3] = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(_buildWindyUrl('temp')));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'Rain Radar'),
            Tab(text: 'Wind Map'),
            Tab(text: 'Cloud Radar'),
            Tab(text: 'Temperature Map'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildWebViewTab(_rainController, 0),
          _buildWebViewTab(_windController, 1),
          _buildWebViewTab(_cloudController, 2),
          _buildWebViewTab(_tempController, 3),
        ],
      ),
    );
  }

  Widget _buildWebViewTab(WebViewController controller, int index) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
            Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
            ),
            Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
            Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
          },
        ),
        if (_loadingStates[index] == true)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
