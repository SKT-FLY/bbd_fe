package com.example.bbd_project_fe

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_retriever"
    private val smsList = mutableListOf<String>()  // 최신 10개의 메세지를 저장할 리스트

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 액티비티가 처음 생성되었을 때 인텐트 처리
        intent?.let { handleSmsIntent(it) }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getLatestSms" -> {
                    result.success(smsList)  // 현재 저장된 최신 10개의 메세지 반환
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleSmsIntent(intent)
    }

    private fun handleSmsIntent(intent: Intent) {
        val sender = intent.getStringExtra("sms_sender")
        val body = intent.getStringExtra("sms_body")

        if (sender != null && body != null) {
            val smsMessage = "From: $sender\nMessage: $body"
            updateSmsList(smsMessage)

            // 새로운 SMS 수신 시 Dart 측에 신호를 보냄
            flutterEngine?.let {
                MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("newSmsReceived", null)
            }
        }
    }

    private fun updateSmsList(newMessage: String) {
        if (smsList.size >= 10) {
            smsList.removeAt(0)  // 가장 오래된 메세지 제거
        }
        smsList.add(newMessage)  // 새 메세지 추가
    }
}
