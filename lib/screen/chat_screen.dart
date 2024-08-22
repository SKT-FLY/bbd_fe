import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bbd_project_fe/widgets/cloud_spinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bbd_project_fe/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "안녕하세요.\n필요하신 것이 있다면\n저에게 말씀해주세요."; // 사용자가 말한 음성 데이터
  final FlutterTts _flutterTts = FlutterTts();
  bool _showSpinner = false;
  bool _showCloudSpinner = false;
  String _responseText = ''; // LLM 모델의 응답을 저장할 변수
  bool _showOptions = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService _apiService = ApiService();
  int? _resultCode; // 서버에서 받은 result 값을 저장할 변수

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
      _speech.stop();
      setState(() {
        _isListening = false; // 음성 인식이 중지될 때 _isListening을 false로 설정
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            _speech.stop(); // 음성 인식이 종료될 때 stopListening을 호출
            setState(() {
              _isListening = false; // 음성 인식이 완료되면 _isListening을 false로 설정
            });
          }
        },
        onError: (val) {
          print('onError: $val');
          setState(() {
            _isListening = false; // 오류가 발생해도 _isListening을 false로 설정
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _text = "";
          _showSpinner = true;
          _showCloudSpinner = false;
        });

        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              if (val.finalResult) {
                _isListening = false; // 음성 인식이 완료되면 _isListening을 false로 설정
                if (_text.isNotEmpty) {
                  _sendToServer(_text); // 음성 인식이 종료될 때 서버에 전송
                }
              }
            });
          },
          listenMode: stt.ListenMode.dictation,
          cancelOnError: true,
          partialResults: true,
        );
      }
    }
  }

  Future<void> _sendToServer(String userText) async {
    final response = await _apiService.processCommandApi(userText);

    if (response.containsKey('error')) {
      setState(() {
        _text = response['error'];
      });
      print('Error: ${response['exception']}');
    } else {
      print("서버 통신");
      // 서버에서 받은 메시지를 화면에 표시
      setState(() {
        _text = response['message'];
        _resultCode = int.tryParse(response['result'] ?? '');
        _showOptions = true;
      });

      // 서버에서 받은 오디오 URL 재생
      if (response['url'] != null) {
        var url = "http://172.23.241.36:8000/" + response['url'];
        try {
          print("Button clicked, attempting to play audio...");
          await _audioPlayer.play(UrlSource(url));
          print("오디오 재생 시도가 완료되었습니다.");
        } catch (e) {
          print('Error occurred: $e');
        }
      }
      if (_resultCode != null) {
        print("page routing");
        //routeBasedOnResult(context, _resultCode!);
      }
    }
  }

  void routeBasedOnResult(BuildContext context, int result) {
    if (result >= 1 && result <= 9) {
      context.go('/tmap');
    } else {
      switch (result) {
        case 10:
          context.go('/smsAnalysis');
          break;
        case 11:
          context.go('/futureSchedule');
          break;
        case 12:
          context.go('/todaySchedule');
          break;
        case 13:
          context.go('/noAnswer');
          break;
        default:
          print('Unknown result: $result');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    const Color activeOrange = Color(0xFFFFA500);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Spacer(flex: 4),
                Expanded(
                  flex: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        _text.isEmpty ? 'Listening...' : _text, // 음성 데이터만 표시
                        style: TextStyle(
                          fontSize: 26.0,
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -15,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: _showSpinner || _showCloudSpinner ? 0.3 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            height: screenHeight * 0.3,
                            child: Image.asset(
                              'assets/images/yellow_character_full.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      if (_showSpinner)
                        Positioned(
                          bottom: screenHeight * 0.23,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: SpinKitWave(
                              color: activeOrange,
                              size: 70.0,
                              itemCount: 4,
                            ),
                          ),
                        ),
                      if (_showCloudSpinner)
                        Positioned(
                          bottom: screenHeight * 0.23,
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: CupertinoCloudSpinner(),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  context.go('/smsListScreen');
                                },
                                child: Container(
                                  width: screenWidth * 0.22,
                                  height: screenWidth * 0.22,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.systemYellow,
                                        activeOrange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.solidEnvelope,
                                      color: Colors.black,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _listen,
                                child: Container(
                                  width: screenWidth * 0.32,
                                  height: screenWidth * 0.32,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        CupertinoColors.white,
                                        activeOrange.withOpacity(0.5),
                                      ],
                                      radius: 0.85,
                                      center: Alignment.center,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: activeOrange,
                                      width: 6.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      _isListening
                                          ? FontAwesomeIcons.microphoneAlt
                                          : FontAwesomeIcons.microphone,
                                      color: _isListening
                                          ? activeOrange
                                          : CupertinoColors.black,
                                      size: screenWidth * 0.18,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/monthly-calendar');
                                },
                                child: Container(
                                  width: screenWidth * 0.22,
                                  height: screenWidth * 0.22,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.systemYellow,
                                        activeOrange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.solidCalendarAlt,
                                      color: Colors.black,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
            if (_showOptions)
              Container(
                color: Colors.black.withOpacity(0.8), // 화면 전체를 어둡게 (투명도를 더 높임)
                child: Center(
                  child: Container(
                    width: screenWidth * 0.85, // 메시지 박스 크기를 크게 조정
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _text,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _text = "예를 선택하셨습니다."; // 예를 선택하면 예 텍스트 유지
                                  _showOptions = false;
                                  routeBasedOnResult(context, _resultCode!);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CupertinoColors.activeGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text(
                                '예',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _text = "안녕하세요.\n필요하신 것이 있다면\n저에게 말씀해주세요."; // 아니오 선택시 초기 메시지로 돌아감
                                  _showOptions = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CupertinoColors.destructiveRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text(
                                '아니오',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}