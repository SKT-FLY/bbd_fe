import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bbd_project_fe/setting/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:bbd_project_fe/setting/config.dart';
import '../widgets/cloud_spinner.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "안녕하세요.\n필요하신 것을 \n 말씀해주세요.";
  String _userSpeechText = ""; // 사용자 발화 텍스트를 위한 변수 추가
  bool _showSpinner = false;
  bool _showCloudSpinner = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService _apiService = ApiService();
  int? _resultCode;
  bool _isPlayingGif = false; // GIF 재생 상태를 관리할 변수

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
    _playInitialSound(); // 초기 사운드 재생 함수 호출
  }

  @override
  void didChangeDependencies() {
    print("화면전환 인식");
    super.didChangeDependencies();
    _resetScreen(); // 화면이 전환될 때 초기화 작업 수행

  }

  Future<void> _resetScreen() async {
    print("화면전환 함수 진입");
    setState(() {
      _text = "안녕하세요.\n필요하신 것을 \n 말씀해주세요."; // 텍스트 초기화
    });
    await _playInitialSound(); // starting_voice.wav 재생
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _stopSpinnerWithDelay() async {
    await Future.delayed(Duration(seconds: 5)); // 5초 딜레이
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _playInitialSound() async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId; // UserId 확인
    String audioFilePath;

    // 유저 아이디가 1이면 다른 경로를 설정
    if (userId == 1) {
      audioFilePath = 'voice/start_shw.wav'; // 유저 아이디가 1일 때 경로
    } else {
      audioFilePath = 'voice/starting_voice.wav'; // 기본 경로'assets/voice/start_shw.wav'
    }

    try {
      await Future.wait([
        _playGif(), // GIF 재생 시작
        _audioPlayer.play(AssetSource(audioFilePath)), // 음성 파일 재생 시작
      ]);
    } catch (e) {
      print('오디오 파일 재생 중 오류 발생: $e');
    }
  }


  Future<void> _playGif() async {
    setState(() {
      _isPlayingGif = true; // GIF 재생 시작
    });

    await Future.delayed(Duration(seconds: 3)); // 3초 대기

    setState(() {
      _isPlayingGif = false; // GIF 재생 종료 후 이미지로 전환
    });
  }

  Future<void> _listen() async {
    HapticFeedback.heavyImpact();

    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _userSpeechText = _text; // 사용자 발화 텍스트 저장
        _showSpinner = false; // 스피너를 멈춤
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            _speech.stop();
            setState(() {
              _isListening = false;
              _userSpeechText = _text; // 사용자 발화 텍스트 저장
              _stopSpinnerWithDelay();
              _showSpinner = false; // 스피너를 멈춤
            });
          }
        },
        onError: (val) {
          setState(() {
            _isListening = false;
            _userSpeechText = _text; // 사용자 발화 텍스트 저장
            _stopSpinnerWithDelay();
            _showSpinner = false; // 스피너를 멈춤
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _userSpeechText = ""; // 사용자 발화 텍스트 초기화
          _showSpinner = true; // 스피너를 켬
          _showCloudSpinner = false;
        });

        _speech.listen(
          onResult: (val) {
            setState(() {
              _userSpeechText = val.recognizedWords; // 사용자 발화 텍스트 저장
              _text = _userSpeechText; // 사용자에게 보여주는 텍스트 업데이트
              if (val.finalResult) {
                _isListening = false;
                _userSpeechText = _text; // 사용자 발화 텍스트 저장
                _stopSpinnerWithDelay();
                _showSpinner = false; // 발화가 끝나면 스피너를 멈춤
                if (_userSpeechText.isNotEmpty) {
                  _sendToServer(_userSpeechText); // 사용자 발화 텍스트를 서버로 보냄
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
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    final response = await _apiService.processCommandApi(userText, userId);

    if (response.containsKey('error')) {
      setState(() {
        _text = response['error'];
      });
    } else {
      setState(() {
        _resultCode = int.tryParse(response['result'] ?? '');
        _text = _userSpeechText; // 서버 응답이 오더라도 사용자 발화 텍스트 유지
      });

      if (_resultCode == null || _resultCode == 13) {
        await Future.delayed(Duration(seconds: 2)); // 2초 딜레이 후
        setState(() {
          _text = response['message'] != null && response['message'] != 'result message not found'
              ? response['message']
              : "다시 말씀해주세요."; // 응답 텍스트 업데이트 또는 기본 메시지
        });
      }

      if (response['url'] != null) {
        var url = '$kimhome/' + response['url'];

        // URL 유효성 검사
        if (Uri.tryParse(url)?.hasAbsolutePath ?? false) {
          try {
            await _audioPlayer.play(UrlSource(url));
          } catch (e) {
            print('오류 발생: $e');
          }
        } else {
          print('Invalid URL: $url');
        }
      }

      _navigateToYesNoScreen(response['message']);
    }
  }

  void _navigateToYesNoScreen(String str) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (_resultCode != null && _resultCode != 13) {
      context.push(
        '/yesno',
        extra: {
          'message': str, // 검색 확인 문구
          'resultCode': _resultCode!, // 티맵 검색 코드
          'userId': userId,
        },
      );
    } else if (_resultCode == 13) {
      // 13번 코드일 경우 다른 동작을 추가로 넣고 싶으면 여기에 작성
    } else {
      print("Error: resultCode is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<UserProvider>(context).userId; // userId를 Provider에서 가져옴
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
                  flex: 75,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Text(
                        _text.isEmpty ? '' : _text,
                        style: TextStyle(
                          fontSize: 32.0,
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
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
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: _showSpinner || _showCloudSpinner
                              ? 0.3
                              : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            height: screenHeight * 0.3,
                            child: _isPlayingGif
                                ? Image.asset(
                                'assets/yellow_nom.gif', fit: BoxFit.contain)
                                : Image.asset(
                                'assets/images/yellow_character_full.png',
                                fit: BoxFit.contain),
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
                                  context.push('/smsListScreen');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orangeAccent.withOpacity(
                                            0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/message.png',
                                      width: screenWidth * 0.18,
                                      height: screenWidth * 0.18,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector( // 음성녹음 버튼
                                onTap: _listen, // 클릭 시 듣기 시작
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
                                        color: CupertinoColors.black
                                            .withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: activeOrange,
                                      width: 2.0,
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
                                  context.push(
                                      '/monthly-calendar', extra: userId);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orangeAccent.withOpacity(
                                            0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/schedule.png',
                                      width: screenWidth * 0.18,
                                      height: screenWidth * 0.18,
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
          ],
        ),
      ),
    );
  }
}
