package com.example.bbd_project_fe

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_retriever"
    private val smsList = mutableListOf<String>()  // 최신 10개의 메세지를 저장할 리스트
    private val SMS_PERMISSION_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // SMS 읽기 권한 요청
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS), SMS_PERMISSION_CODE)
        } else {
            loadSmsFromInbox()  // 권한이 이미 허용된 경우 SMS 로드
        }

        // 액티비티가 처음 생성되었을 때 인텐트 처리
        intent?.let { handleSmsIntent(it) }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                loadSmsFromInbox()  // 권한이 허용되면 SMS 로드
            } else {
                // 권한이 거부된 경우 처리
            }
        }
    }

    private fun loadSmsFromInbox() {
        // SMS 인박스에서 메시지를 읽어와 smsList에 최신 10개 메시지를 추가하는 로직
        val cursor = contentResolver.query(
            Uri.parse("content://sms/inbox"),
            arrayOf("address", "body"),  // 읽어올 열 지정
            null,
            null,
            "date DESC"  // 날짜 순서로 내림차순 정렬
        )

        cursor?.let {
            val bodyIndex = cursor.getColumnIndex("body")
            val addressIndex = cursor.getColumnIndex("address")

            while (cursor.moveToNext() && smsList.size < 10) {
                val body = cursor.getString(bodyIndex)
                val address = cursor.getString(addressIndex)
                val smsMessage = "From: $address\nMessage: $body"
                smsList.add(smsMessage)
            }
            cursor.close()
        }
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
