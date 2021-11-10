import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class TensorflowRepository {
  Future loadModel() async {
    Tflite.close();
    try {
      String res = await Tflite.loadModel(
        model: "assets/model-pranav.tflite",
        labels: "assets/labels.txt",
      ) ??
          'Failed';
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future<List<dynamic>?> predictImage(File image) async {
    try {
      var recognitions = await ssdMobNet(image) ?? [];
      print(recognitions);
      return recognitions;
    } on Exception catch (e) {
      print(e);
      Tflite.close();
    }
  }

  // Perform inference using SSDMobNet model
  Future<List<dynamic>?> ssdMobNet(File image) async {
    int startTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "SSDMobileNet",
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.2,
      numResultsPerClass: 1,
      asynch: false,
    );
    int endTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
    Tflite.close();
    return recognitions;
  }
}