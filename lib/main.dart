import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'spelling_controller.dart';

void main() {
  runApp(const SpellingBeeApp());
}

class SpellingBeeApp extends StatelessWidget {
  const SpellingBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spelling Bee App',
      debugShowCheckedModeBanner: false,
      home: SpellingBeeHome(),
    );
  }
}

class SpellingBeeHome extends StatelessWidget {
  final SpellingController spellingController = Get.put(SpellingController());

  SpellingBeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spelling Bee'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  spellingController.getNextWord();
                },
                child: const Text('Start game')),
            Obx(() => Text(
                  'Current Word: ${spellingController.currentWord.value}',
                  style: const TextStyle(fontSize: 24),
                )),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'Points: ${spellingController.points.value}',
                  style: const TextStyle(fontSize: 24),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: spellingController.startListening,
              child: const Text('Spell word'),
            ),
            Obx(() => Text(spellingController.userSpelling.value))
          ],
        ),
      ),
    );
  }
}
