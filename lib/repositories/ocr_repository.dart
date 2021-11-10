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
      file.writeAsBytesSync(img.encodePng(pickImage));
    }
    return file;
  }

  void writeImage(File file) {}

  // Using TesseractOCR to extract name for PVP Rater
  Future<String> extractPokemonName(String path) async {
    String extractText = await FlutterTesseractOcr.extractText(path);
    extractText = extractText.replaceAll("\n", " ");
    var list = extractText.split(' ');
    String name = list[list.indexOf('This') + 1];
    return name;
  }

  // Using TesseractOCR to extract name and CP for Wild Pokemon
  Future<Map<String, dynamic>> extractNameAndCP(String path) async {
    String extractText = await FlutterTesseractOcr.extractText(path);
    extractText = extractText.replaceAll("\n", " ");
    print(extractText);
    return extractNameAndCPFromText(extractText);
  }

  Map<String, dynamic> extractNameAndCPFromText(String text) {
    List textList = text.split(' ');
    final cpRegex = RegExp(r'(?:cp.*)');
    for (String str in textList) {
      if (cpRegex.hasMatch(str)) {
        final numRegex = RegExp(r'(?=.*[0-9])');
        if (numRegex.hasMatch(str)) {
          Map<String, dynamic> data = {
            'cp': str.substring(2),
            'name': textList[textList.indexOf(str) - 2],
          };
          return data;
        }
      }
    }
    return {};
  }

  String extractCPFromTextOld(String text) {
    List textList = text.split(' ');
    if (textList.contains('/')) {
      int slashIndex = textList.indexOf('/');
      if (slashIndex > 0) {
        String name = textList[slashIndex - 1];
        String cp = '';
        final cpRegex = RegExp(r'(?:cp.*)');
        for (String str in textList) {
          if (cpRegex.hasMatch(str)) {
            final numRegex = RegExp(r'(?=.*[0-9])');
            if (numRegex.hasMatch(str)) {
              cp = str;
            }
          }
        }
        print(name);
        return name + ' ' + cp;
      }
    }
    return 'Does not exist';
  }
}
