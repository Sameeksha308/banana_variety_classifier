import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import '../widgets/common_title_widget.dart';
import '../widgets/lottie_animation_widget.dart';

class CaptureAndPredictPage extends StatefulWidget {
  const CaptureAndPredictPage({super.key});

  @override
  State<CaptureAndPredictPage> createState() => _CaptureAndPredictPageState();
}

class _CaptureAndPredictPageState extends State<CaptureAndPredictPage> {
  html.VideoElement? _videoElement;
  html.CanvasElement? _canvasElement;
  String? _prediction;
  String? _confidence;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '90%'
      ..style.objectFit = 'cover';

    html.window.navigator.mediaDevices?.getUserMedia({'video': true}).then((mediaStream) {
      _videoElement?.srcObject = mediaStream;
    });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('videoElement', (int viewId) => _videoElement!);

    _canvasElement = html.CanvasElement(width: 640, height: 480);
  }

  Future<void> _captureImageAndPredict() async {
    if (_videoElement != null && _canvasElement != null) {
      final ctx = _canvasElement!.getContext('2d') as html.CanvasRenderingContext2D;
      ctx.drawImage(_videoElement!, 0, 0);

      final blob = await _canvasElement!.toBlob();
      if (blob != null) {
        final formData = html.FormData();
        formData.appendBlob('image', blob, 'captured_image.png');

        final request = html.HttpRequest();
        request.open('POST', 'http://localhost:5000/classify');
        request.responseType = 'json';

        setState(() {
          _isLoading = true;
        });

        request.onLoadEnd.listen((event) {
          if (request.status == 200 && request.response != null) {
            final response = request.response;
            final classification = response['classification']?.toString();
            final confidence = response['confidence']?.toString();

            if (classification == null || classification == "No banana detected") {
              setState(() {
                _prediction = 'No banana detected';
                _confidence = '';
              });
            } else {
              setState(() {
                _prediction = classification;
                _confidence = confidence ?? 'Unknown';
              });
            }
          } else {
            setState(() {
              _prediction = 'Error';
              _confidence = 'Failed to classify';
            });
          }
          setState(() {
            _isLoading = false;
          });
        });

        request.send(formData);
      }
    }
  }

  @override
  void dispose() {
    _videoElement?.srcObject = null;
    super.dispose();
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
        backgroundColor: const Color(0xFF8BC34A),
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
                  'Capture and Classify Banana',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.greenAccent.shade400,
                            width: 2.5,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 400,
                                child: _videoElement != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: HtmlElementView(viewType: 'videoElement'),
                                      )
                                    : const LottieAnimationWidget(animationPath: 'assets/choose.json'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _captureImageAndPredict,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Capture and Classify',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white),
              if (_prediction != null && !_isLoading) ...[
                const SizedBox(height: 16),
                if (_prediction == 'No banana detected')
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No banana detected in the frame. Please try again!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    'Classification: $_prediction',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_confidence != null && _confidence!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: $_confidence%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
