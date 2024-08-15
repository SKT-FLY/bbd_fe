import 'dart:async';
import 'package:flutter/cupertino.dart';
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
  bool _isListening = false; // 버튼 클릭 시 음성 입력 상태를 관리하는 변수
  String _text = "여기에 채팅 내용이 표시됩니다.";
  //double _confidence = 1.0;
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
          print('onError: $val');
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
              _text = val.recognizedWords; // 실시간으로 텍스트를 갱신
              """""if (val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
              }""";
            });
          },
        );
      }
    }
  }

  void _restartListening() async {
    if (_isListening) {
      _speech.stop();
      await Future.delayed(const Duration(milliseconds: 200)); // 짧은 대기 시간 추가
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords; // 실시간으로 텍스트를 갱신
            //if (val.hasConfidenceRating && val.confidence > 0) {
              //_confidence = val.confidence;
            //}
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('채팅'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 채팅 내용을 보여주는 큰 위젯
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    _text.isEmpty ? 'Listening...' : _text,
                    style: const TextStyle(fontSize: 22.0, color: CupertinoColors.black),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          _speak(_text); // 문자 네비게이션 버튼 클릭 시 TTS 사용
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Text(
                              '문자',
                              style: TextStyle(color: Colors.white),
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
                      child: CupertinoButton(
                        onPressed: _listen, // 음성 입력 버튼 클릭 시 상태를 토글하고 listen 실행
                        child: Container(
                          width: 48.0,
                          height: 68.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isListening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                            color: Colors.white,
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
                          // 일정 네비게이션 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Text(
                              '일정',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}