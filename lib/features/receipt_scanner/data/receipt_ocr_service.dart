import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOcrService {
  ReceiptOcrService({TextRecognizer? recognizer})
      : _recognizer = recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;

  Future<String> recognizeTextFromPath(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _recognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Future<void> dispose() async {
    await _recognizer.close();
  }
}
