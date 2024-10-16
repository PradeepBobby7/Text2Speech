import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();
  Map<String, String> languagesMap = {
    'ta-IN': 'Tamil',
    'en-US': 'English',
    'jp-JP': 'Japanese',
    'hi-IN': 'Hindi',
    'sp-ES': 'Spanish',
    'fr-FN': 'French',
    'ko-KR': 'Korean',
    'de-DE': 'German',
    'tl-IN': 'Telugu',
    'ml-IN': 'Malayalam',
    'ka-IN': 'Kanada'
  };
  List<String> languages = [];
  String? selectedLanguage;
  double pitch = 1.0;
  double speechRate = 0.5;
  double volume = 0.8;

  @override
  void initState() {
    initTts();
    super.initState();
  }

  Future<void> initTts() async {
    List<dynamic> availableLanguages = await flutterTts.getLanguages;
    languages = availableLanguages
        .where((languages) => languagesMap.keys.contains(languages))
        .map((languages) => languages as String)
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? 'en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(text);
  }

  Future<void> save(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? 'en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speechRate);

    //generate random name for each audio file
    String timeStamp = DateTime.now().microsecondsSinceEpoch.toString();

    //generate autio and save in phone storage
    await flutterTts.synthesizeToFile(text, 'tts_audio_$timeStamp.mp3');
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> pause() async {
    await flutterTts.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Center(
            child: Text(
          "Text 2 Speech",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    hintText: "Enter the text to Convert Speech...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)))),
                maxLines: 10,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await speak(textController.text);
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 30,
                          color: Colors.lightBlue,
                        )),
                    const Text(
                      "Play",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await pause();
                        },
                        icon: const Icon(
                          Icons.pause,
                          size: 30,
                          color: Colors.blueGrey,
                        )),
                    const Text(
                      "Pause",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await stop();
                        },
                        icon: const Icon(
                          Icons.stop_rounded,
                          size: 30,
                          color: Colors.redAccent,
                        )),
                    const Text(
                      "Stop",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      hint: const Text("Select Language"),
                      value: selectedLanguage,
                      items: languages
                          .map((language) => DropdownMenuItem<String>(
                                value: language,
                                child: Text(languagesMap[language]!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Volume:  ${volume.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Slider(
                activeColor: Colors.grey,
                value: volume,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Pitch:  ${pitch.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Slider(
                activeColor: Colors.grey,
                min: 0.5,
                max: 2.0,
                value: pitch,
                onChanged: (value) {
                  setState(() {
                    pitch = value;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Speech rate:  ${speechRate.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Slider(
                activeColor: Colors.grey,
                value: speechRate,
                onChanged: (value) {
                  setState(() {
                    speechRate = value;
                  });
                }),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent),
                  onPressed: () async {
                    await save(textController.text);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
