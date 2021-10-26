import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;


class OCRRepository{

  // Image Preprocessing for OCR
  Future<img.Image?> processImage(XFile image) async {
    final path = image.path;
    final bytes = await File(path).readAsBytes();
    img.Image? pickImage = img.decodeImage(bytes);
    pickImage = img.grayscale(pickImage!);
    pickImage = img.noise(pickImage, 1);
    pickImage = img.contrast(pickImage, 132);
    return pickImage;
  }

  // Using TesseractOCR to extract name
  Future<String> runOCR(String path) async {
    String name = '';
    String extractText = await FlutterTesseractOcr.extractText(path);
    extractText = extractText.replaceAll("\n", " ");
    name = extractName(extractText);
    return name;
  }

  String extractName(String text){

    return text;
  }

  String cpExtract(String text) {
    List boi = text.split(' ');
    int slashIndex = boi.indexOf('/');
    if (slashIndex >= 0) {
      String beforeSlash = boi[slashIndex - 1];
      String before = '';
      if (boi.contains('/')) {
        before = beforeSlash;
      }
      String string = '';
      final regex = RegExp(r'(?:cp.*)');
      for (String str in boi) {
        bool match = regex.hasMatch(str);
        if (match == true) {
          final regex2 = RegExp(r'(?=.*[0-9])');
          match = regex2.hasMatch(str);
          print('$str');
          string = str;
        }
      }
      print(before);
      return before + ' ' + string;
    }
    return 'Does not exist';
  }



}