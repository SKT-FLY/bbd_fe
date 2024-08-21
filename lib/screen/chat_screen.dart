import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bbd_project_fe/api_service.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _listen() async {
    HapticFeedback.heavyImpact();

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
            onResult: (val) async {
              setState(() {
                _text = val.recognizedWords;
              });

              // 음성 인식된 텍스트를 서버로 전송
              if (_text.isNotEmpty) {
                await _sendToServer(_text);
              };
            }
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

  Future<void> _sendToServer(String userText) async {
    final response = await _apiService.processCommandApi(userText);

    if (response.containsKey('error')) {
      setState(() {
        _text = response['error'];
      });
      print('Error: ${response['exception']}');
    } else {
      // 서버에서 받은 메시지를 화면에 표시
      setState(() {
        _text = response['standarized_command'];
      });

      // 서버에서 받은 오디오 URL 재생
      if (response['url'] != null) {
        await _playAudio(response['url']);
      }
    }
  }
  Future<void> _playAudio(String url) async {
    try {
      print("Button clicked, attempting to play audio...");
      await _audioPlayer.play(UrlSource(url));
      print("오디오 재생 시도가 완료되었습니다.");
    } catch (e) {
      print('Error occurred: $e');
    }
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
            Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                context.go('/guardian-calendar');
              },
              child: Container(
                alignment: Alignment.center,
                width: screenWidth * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  '보호자 일정 확인',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 30,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
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
                  // 캐릭터 이미지
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
                  // 네비게이션 바
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
                                    context.go('/loading');
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
                                          fontSize: 30,
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
                                    context.go('/monthly-calendar');
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
                                          fontSize: 30,
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
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
