import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'offline_screen.dart';

const String homeUrl = 'https://dijitaltahta.com/#login';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Layer 3: Environment guard — verify URL configuration before launch
  assert(homeUrl.isNotEmpty, 'homeUrl must not be empty');
  assert(
    Uri.tryParse(homeUrl) != null,
    'homeUrl must be a valid URI: $homeUrl',
  );
  runApp(const MegakentApp());
}

class MegakentApp extends StatelessWidget {
  const MegakentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Megakent Danışman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0f172a),
        primaryColor: const Color(0xFF0f766e),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0f766e),
          secondary: Color(0xFF14b8a6),
          surface: Color(0xFF0f172a),
        ),
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> with WidgetsBindingObserver {
  bool _isOnline = true;
  bool _showOffline = false;
  bool _isLoadingWeb = true;

  // KiraPrint restartApp benzeri yeniden başlatma
  void _restartApp() {
    // WebView'i yeniden yükle ve offline kapat
    setState(() {
      _showOffline = false;
      _isLoadingWeb = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((resultsList) {
      final hasConnection = resultsList.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = hasConnection;
        if (hasConnection) {
          _showOffline = false;
        }
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final isConnected = results.any((r) => r != ConnectivityResult.none);
    setState(() {
      _isOnline = isConnected;
      if (!_isOnline) _showOffline = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showOffline) {
      return OfflineScreen(onRetry: _restartApp);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(homeUrl)),
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                applicationNameForUserAgent: 'KiraMobilApp/1.0',
                preferredContentMode: UserPreferredContentMode.RECOMMENDED,
              ),
              onLoadStart: (controller, url) {
                // Layer 4: Debug instrumentation — log navigation attempts
                // ignore: avoid_print
                print('DEBUG WEBVIEW onLoadStart: url=$url');
                setState(() => _isLoadingWeb = true);
              },
              onLoadStop: (controller, url) {
                // Layer 4: Debug instrumentation
                // ignore: avoid_print
                print('DEBUG WEBVIEW onLoadStop: url=$url');
                setState(() => _isLoadingWeb = false);
              },
              onWebViewCreated: (controller) {},
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // Layer 2: Business logic validation — enforce allowed domain rules
                final rawUrl = navigationAction.request.url;
                if (rawUrl == null) {
                  // ignore: avoid_print
                  print('DEBUG WEBVIEW blocked: null URL');
                  return NavigationActionPolicy.CANCEL;
                }
                final uri = rawUrl;
                const allowedDomains = [
                  'megakentemlak.com',
                  'www.megakentemlak.com',
                  'dijitaltahta.com',
                  'www.dijitaltahta.com',
                    ];
                final host = uri.host.toLowerCase();
                final isAllowed = allowedDomains.any((d) => host.contains(d)) || host == 'localhost';
                if (!isAllowed) {
                  final urlStr = uri.toString();
                  if (urlStr.isNotEmpty) {
                    try {
                      final urlUri = Uri.parse(urlStr);
                      if (await canLaunchUrl(urlUri)) {
                        await launchUrl(urlUri, mode: LaunchMode.externalApplication);
                      }
                    } catch (_) {}
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
            if (_isLoadingWeb)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0xFF0f172a),
                  child: Center(
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
