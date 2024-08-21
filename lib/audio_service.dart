import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudioFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        //Uint8List audioBytes = response.bodyBytes;
        await _audioPlayer.play(UrlSource(url));
        print("Audio playing started.");
      } else {
        throw Exception('Failed to load audio file: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      rethrow; // 다시 던져서 onTap에서 캐치하도록 함
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }
}
