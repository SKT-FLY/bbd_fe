package com.example.bbd_project_fe

import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import android.Manifest
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_retriever"
    private val smsList = mutableListOf<String>()  // 최신 10개의 메세지를 저장할 리스트
    private val SMS_PERMISSION_CODE = 101  // SMS 권한 요청 코드

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS), SMS_PERMISSION_CODE)
        } else {
            loadInitialSms()  // 권한이 이미 부여된 경우 SMS 로드
        }

        intent?.let { handleSmsIntent(it) }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                loadInitialSms()  // 권한이 부여되면 SMS 로드
            } else {
                Toast.makeText(this, "SMS 권한이 필요합니다.", Toast.LENGTH_LONG).show()
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getLatestSms" -> {
                    result.success(smsList)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "onNewIntent called with intent: $intent")
        handleSmsIntent(intent)
    }

    private fun handleSmsIntent(intent: Intent) {
        val sender = intent.getStringExtra("sms_sender")
        val body = intent.getStringExtra("sms_body")

        if (sender != null && body != null) {
            val smsMessage = "From: $sender\nMessage: $body"
            updateSmsList(smsMessage)
            Log.d("MainActivity", "SMS received and added to list: $smsMessage")

            flutterEngine?.let {
                MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("newSmsReceived", null)
                Log.d("MainActivity", "Dart side notified about new SMS")
            }
        } else {
            Log.e("MainActivity", "SMS data is missing in the intent")
        }
    }

    private fun updateSmsList(newMessage: String) {
        if (smsList.size >= 10) {
            smsList.removeAt(0)
        }
        smsList.add(newMessage)
    }

    private fun loadInitialSms() {
        try {
            val uri = Telephony.Sms.Inbox.CONTENT_URI
            val projection = arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE)
            val sortOrder = "${Telephony.Sms.DATE} DESC LIMIT 10"
            val cursor = contentResolver.query(uri, projection, null, null, sortOrder)

            cursor?.use {
                val addressIndex = it.getColumnIndex(Telephony.Sms.ADDRESS)
                val bodyIndex = it.getColumnIndex(Telephony.Sms.BODY)

                while (it.moveToNext()) {
                    val address = it.getString(addressIndex)
                    val body = it.getString(bodyIndex)
                    val smsMessage = "From: $address\nMessage: $body"
                    smsList.add(0, smsMessage)  // 역순으로 추가하여 최신 메시지가 리스트의 앞에 위치
                }
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to load initial SMS: ${e.message}")
        }
    }
}
