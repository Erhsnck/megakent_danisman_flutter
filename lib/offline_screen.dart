import 'package:flutter/material.dart';

class OfflineScreen extends StatefulWidget {
  final VoidCallback onRetry;
  const OfflineScreen({super.key, required this.onRetry});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _loading = false;

  void _handleRetry() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
      widget.onRetry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: const Color(0xFF111c33),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1e293b)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF134e4a),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.signal_wifi_statusbar_4_bar_rounded,
                        size: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Sisteme bağlanılamadı',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'İnternet bağlantınızı kontrol edin. '
                    'Sorun sürerse sistem bakımda olabilir; '
                    'biraz sonra tekrar deneyin.',
                    style: TextStyle(
                      color: Color(0xFF94a3b8),
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _handleRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0f766e),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Tekrar Dene',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
