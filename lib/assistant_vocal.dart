import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'consts.dart'; // Import the Gemini AI function
import 'drawer.dart';

class AssistantVocal extends StatefulWidget {
  const AssistantVocal({super.key});

  @override
  State<AssistantVocal> createState() => _AssistantVocalState();
}

class _AssistantVocalState extends State<AssistantVocal> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcription = '';
  String _geminiResponse = '';
  bool _isProcessing = false; // Flag to show if the Gemini response is being processed
  bool _hasSpoken = false; // Flag to check if speech was processed already

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcription = result.recognizedWords;
          });

          // Automatically process with Gemini AI once transcription is complete
          if (_transcription.isNotEmpty && !_hasSpoken) {
            _hasSpoken = true; // Mark as spoken to prevent repeated response generation
            _processWithGeminiAI(_transcription);
          }
        },
      );
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _hasSpoken = false; // Reset the flag when the mic is stopped
    });
    _speech.stop();
  }

  // Method to call Gemini API and get a response based on the transcribed text
  void _processWithGeminiAI(String prompt) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final response = await requestGeminiAI(prompt); // Call Gemini AI function
      setState(() {
        _geminiResponse = response ?? 'No response from Gemini AI.';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _geminiResponse = 'Error: Unable to get Gemini response.';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Vocal'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/robot.jpeg'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Tap to Talk',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              // Transcription display
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  _transcription.isEmpty ? 'Speak now' : _transcription,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Gemini AI response display
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    _geminiResponse.isEmpty
                        ? 'Gemini response will appear here'
                        : _geminiResponse,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
