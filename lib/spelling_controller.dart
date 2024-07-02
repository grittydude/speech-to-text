import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'dart:async';

class SpellingController extends GetxController {
  var currentWord = ''.obs;
  var points = 0.obs;
  stt.SpeechToText speech = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  List<String> words = ['Safe', 'Test', 'Go', 'Play'];
  final Random random = Random();
  RxString userSpelling = ''.obs;
  String recognizedString = '';
  Timer? _timer;

  void getNextWord() {
    currentWord.value = words[random.nextInt(words.length)];
    userSpelling.value = '';
    recognizedString = '';
    _speak(currentWord.value);
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      _timer?.cancel();
      userSpelling.value = ''; // Clear previous spelling
      recognizedString = ''; // Clear previous recognized letters
      _timer = Timer(const Duration(seconds: 10), () {
        speech.stop();
        checkSpelling(userSpelling.value);
      });

      speech.listen(onResult: (val) {
        if (val.recognizedWords.isNotEmpty) {
          String recognizedSegment = val.recognizedWords.trim().toLowerCase();
          if (recognizedSegment.length > recognizedString.length) {
            // Append only new letters and remove spaces
            String newLetters = recognizedSegment
                .substring(recognizedString.length)
                .replaceAll(' ', '');
            recognizedString = recognizedSegment;
            userSpelling.value += newLetters;
            //print(userSpelling.value);
          }
        }
      });
    } else {
      Get.snackbar('Permission denied',
          'The user has denied the use of speech recognition.');
    }
  }

  void checkSpelling(String userSpelling) {
    if (userSpelling.toLowerCase() == currentWord.value.toLowerCase()) {
      points.value += 1;
      Get.snackbar('You got it',
          '${userSpelling.toLowerCase()} is the same as ${currentWord.value.toLowerCase()}!!! Yayyyyyy!!!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('You missed it',
          '${userSpelling.toLowerCase()} is the not the same as ${currentWord.value.toLowerCase()}!!! Sorryyy!!!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    getNextWord();
  }
}
