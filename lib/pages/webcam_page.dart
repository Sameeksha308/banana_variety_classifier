import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../widgets/background_widget.dart';
import '../widgets/common_title_widget.dart';

class WebcamPage extends StatefulWidget {
  const WebcamPage({super.key});

  @override
  State<WebcamPage> createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  final String _webcamUrl = 'http://localhost:5000/video_feed';

  @override
  void initState() {
    super.initState();

    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'webcam-iframe',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = _webcamUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CommonTitleWidget(),
        backgroundColor: const Color(0xFF8BC34A), // Greenish background
        elevation: 0,
        centerTitle: true,
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              const Center(
                child: Text(
                  'Webcam Feed',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 600,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.greenAccent.shade400,
                            width: 2.5,
                          ),
                        ),
                        child: const HtmlElementView(viewType: 'webcam-iframe'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
