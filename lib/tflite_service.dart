import 'package:tflite/tflite.dart';

class TFLiteService {
  // Load model from assets
  static Future<String?> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/fruit_classifier_model.tflite", // Path to your model
      labels: "assets/labels.txt",  // Optional: Path to your labels file
    );
    return res;
  }

  // Run inference on an image
  static Future<String?> runModel(String imagePath) async {
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 2, // Adjust based on your model
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 255.0,
    );

    if (output != null && output.isNotEmpty) {
      // Assuming output format is: [{'label': 'banana', 'confidence': 0.99}, ...]
      var result = output[0];  // Get the highest probability result
      return result['label'];  // Return the predicted fruit name
    }
    return 'Unknown';
  }

  // Close the TFLite interpreter
  static Future<void> close() async {
    await Tflite.close();
  }
}
