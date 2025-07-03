import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import '../widgets/lottie_animation_widget.dart';
import '../widgets/common_title_widget.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Uint8List? _imageData;
  String? _classification;
  String? _confidence;
  bool _isLoading = false;
  bool _noBananaDetected = false;

  final Map<String, List<String>> _nutritionalBenefits = {
    'Kadoli': [
      'Gives Quick Energy: Contains natural sugars (like glucose).',
      'Good for Digestion: Has fiber that aids digestion.',
      'Rich in Nutrients: Contains potassium, vitamin C, and B6.',
      'Supports Heart Health: Potassium helps maintain blood pressure.',
      'Helps in Weight Gain: Useful for healthy weight gain.',
    ],
    'Mysuru': [
      'Boosts Immunity: Rich in vitamin C and antioxidants.',
      'Provides Quick Energy: Natural sugars (glucose, fructose).',
      'Supports Digestion: Good fiber for smooth digestion.',
      'Good for Heart Health: Contains potassium for blood pressure control.',
      'Improves Skin Health: Helps maintain healthy, glowing skin.',
    ],
    'Nendra': [
      'Gives High Energy: Rich in carbohydrates.',
      'Very Good for Digestion: High fiber for smooth digestion.',
      'Strengthens Immunity: Contains vitamin A, C, and antioxidants.',
      'Good for Eye Health: Vitamin A maintains good eyesight.',
      'Supports Healthy Weight Gain: Good for healthy weight gain.',
    ],
    'Sambar bale': [
      'Gives Good Energy: Rich in natural carbohydrates.',
      'Good for Digestion: Contains fiber for smooth digestion.',
      'Strengthens Bones and Muscles: Potassium and magnesium help keep bones and muscles strong.',
      'Supports Heart Health: Potassium controls blood pressure.',
      'Rich in Nutrients: Contains vitamins B6, C, and A.',
    ],
    'Chandra bale': [
      'Boosts Immunity: Rich in vitamin C and antioxidants.',
      'Gives Instant Energy: Contains natural sugars for quick energy.',
      'Good for Heart Health: Potassium helps maintain heart health.',
      'Improves Skin Health: Rich in vitamin A and C.',
      'Supports Eye Health: Vitamin A improves eyesight.',
    ],
    'Budi': [
      'Gives Quick Energy: Contains natural sugars.',
      'Easy to Digest: Good fiber for digestion.',
      'Boosts Immunity: Contains vitamin C and antioxidants.',
      'Good for Heart Health: Potassium helps maintain blood pressure.',
      'Supports Healthy Skin: Rich in vitamins A and C.',
    ],
    'Cavendish (green)': [
      'Gives Instant Energy: Rich in natural sugars like glucose.',
      'Helps Digestion: Contains fiber for smooth digestion.',
      'Boosts Immunity: Contains vitamin C and antioxidants.',
      'Good for Heart Health: Potassium controls blood pressure.',
      'Supports Bone Strength: Contains magnesium for strong bones.',
    ],
    'Gali': [
      'Gives Good Energy: Contains natural sugars for long-lasting energy.',
      'Helps Digestion: Good fiber for digestion.',
      'Strengthens Immunity: Rich in vitamin C and antioxidants.',
      'Good for Heart Health: Potassium helps control blood pressure.',
      'Supports Bone and Muscle Health: Contains magnesium and potassium.',
    ],
    'Kayi budi': [
      'Very Good for Digestion: Rich in fiber.',
      'Supports Gut Health: Resistant starch promotes good bacteria.',
      'Helps Control Blood Sugar: Low sugar content helps manage blood sugar.',
      'Good for Weight Loss: Low in calories, high in fiber.',
    ],
  };

  void _pickImage() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) {
        setState(() {
          _imageData = reader.result as Uint8List;
          _classification = null;
          _confidence = null;
          _noBananaDetected = false;
        });
        _uploadImage(file);
      });
    });
  }

  void _uploadImage(html.File file) async {
    setState(() {
      _isLoading = true;
    });

    final formData = html.FormData();
    formData.appendBlob('image', file, file.name);

    final request = html.HttpRequest();
    request.open('POST', 'http://localhost:5000/classify');
    request.responseType = 'json';

    request.onLoadEnd.listen((event) {
      if (request.status == 200 && request.response != null) {
        final response = request.response;
        final classification = response['classification']?.toString();
        final confidence = response['confidence']?.toString();

        setState(() {
          if (classification == null || classification.isEmpty || !_nutritionalBenefits.containsKey(classification)) {
            _noBananaDetected = true;
            _classification = null;
            _confidence = null;
          } else {
            _classification = classification;
            _confidence = confidence;
            _noBananaDetected = false;
          }
        });
      } else {
        setState(() {
          _classification = 'Error';
          _confidence = 'Failed to classify';
          _noBananaDetected = true;
        });
      }

      setState(() {
        _isLoading = false;
      });
    });

    request.send(formData);
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
                  'Upload a banana image',
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
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAED581),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _imageData == null
                              ? LottieAnimationWidget(animationPath: 'assets/choose.json')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(
                                    _imageData!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Choose Image',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isLoading)
                            const CircularProgressIndicator(color: Colors.white),
                          if (_noBananaDetected && !_isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'No banana detected. Please try again with a banana image.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (_classification != null && !_isLoading) ...[
                            Text(
                              'Classification: $_classification',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Confidence: $_confidence%',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            if (_nutritionalBenefits.containsKey(_classification))
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Nutritional Benefits:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._nutritionalBenefits[_classification]!
                                        .map((benefit) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                benefit,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ],
                                ),
                              ),
                          ],
                        ],
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
