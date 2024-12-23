import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io'; // File handling for non-web
import 'tflite_service.dart';

class TFLitePage extends StatefulWidget {
  @override
  _TFLitePageState createState() => _TFLitePageState();
}

class _TFLitePageState extends State<TFLitePage> {
  String _result = '';
  late ImagePicker _picker;
  String? _imagePath;
  String? _webImageData;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    loadModel();
  }

  // Load the model asynchronously
  Future<void> loadModel() async {
    await TFLiteService.loadModel();
  }

  // Pick an image using the image picker
  Future<void> pickImage() async {
    if (kIsWeb) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageData = 'data:image/png;base64,' + base64Encode(bytes);
        });
        runInference();
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        runInference();
      }
    }
  }

  // Run inference on the selected image
  Future<void> runInference() async {
    if (_imagePath != null || _webImageData != null) {
      final path = kIsWeb ? _webImageData : _imagePath;
      String? result = await TFLiteService.runModel(path!);
      setState(() {
        _result = result ?? 'No result';
      });
    }
  }

  @override
  void dispose() {
    TFLiteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TensorFlow Lite Inference'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _webImageData == null && _imagePath == null
                ? Text('No image selected')
                : kIsWeb
                ? Image.network(_webImageData!)
                : Image.file(File(_imagePath!)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            Text(
              'Inference Result: $_result',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
