import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "안녕하세요.\n필요하신 것이 있다면\n저에게 말씀해주세요.";
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _listen() async {
    if (_isListening) {
      _stopListening();
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (_isListening && val == 'done') {
            _restartListening();
          }
        },
        onError: (val) {
          if (val.errorMsg == "error_busy" || val.errorMsg == "error_client") {
            Future.delayed(const Duration(seconds: 2), () {
              _restartListening();
            });
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _text = " ";
        });

        await Future.delayed(const Duration(milliseconds: 500));
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _restartListening() async {
    if (_isListening) {
      _speech.stop();
      await Future.delayed(const Duration(milliseconds: 200));
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const Spacer(flex: 2),
            Expanded(
              flex: 30,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    _text.isEmpty ? 'Listening...' : _text,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight * 0.22,
                      child: Image.asset(
                        'assets/images/yellow_character.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight * 0.1,
                      color: CupertinoColors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.go('/loading'); // 문자 네비게이션 버튼 클릭 시 이동
                                  },
                                  child: Container(
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemYellow,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '문자',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 13,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: GestureDetector(
                                  onTap: _listen,
                                  child: Container(
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: CupertinoColors.systemOrange,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _isListening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                                        color: CupertinoColors.systemOrange,
                                        size: screenWidth * 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // 일정 버튼 클릭 시 이동할 페이지로의 네비게이션 설정
                                  },
                                  child: Container(
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemYellow,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '일정',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

