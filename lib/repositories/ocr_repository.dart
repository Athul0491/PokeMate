import 'dart:io';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image/image.dart' as img;

class OCRRepository {
  // Image Preprocessing for OCR
  static Future<File> processImage(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? pickImage = img.decodeImage(bytes);
    pickImage = img.grayscale(pickImage!);
    pickImage = img.noise(pickImage, 1);
    pickImage = img.contrast(pickImage, 132);
    File file = File(path);
    if (pickImage != null) {
      // Write the processed image to original file path
      file.writeAsBytesSync(img.encodePng(pickImage));
    }
    return file;
  }

  // Using TesseractOCR to extract name for PVP Rater
  Future<String> extractPokemonName(String path) async {
    // Run OCR on image
    String extractTexted = await FlutterTesseractOcr.extractText(path);
    extractTexted = extractTexted.replaceAll("\n", " ");
    var list = extractTexted.split(' ');
    String name = list[list.indexOf('This') + 1];
    return name;
  }

  // Using TesseractOCR to extract name and CP for Wild Pokemon
  Future<Map<String, dynamic>> extractNameAndCP(String path) async {
    // Run OCR on image
    String extractedText = await FlutterTesseractOcr.extractText(path);
    extractedText = extractedText.replaceAll("\n", " ");
    print(extractedText);
    return extractNameAndCPFromText(extractedText);
  }

  Map<String, dynamic> extractNameAndCPFromText(String text) {
    List textList = text.split(' ');
    // Look for cp in text
    final cpRegex = RegExp(r'(?:cp.*)');
    for (String str in textList) {
      if (cpRegex.hasMatch(str)) {
        // Check if the rest is numbers
        final numRegex = RegExp(r'(?=.*[0-9])');
        if (numRegex.hasMatch(str)) {
          Map<String, dynamic> data = {
            // Remove 'cp' so that only actual value(int) is left
            'cp': str.substring(2),
            // Eg: Pikachu / cp259
            // So name is 2 indices before cp
            'name': textList[textList.indexOf(str) - 2],
          };
          return data;
        }
      }
    }
    return {};
  }
}
