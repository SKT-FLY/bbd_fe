package com.example.bbd_project_fe

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_retriever"
    private val mmsList = mutableListOf<String>()  // 최신 10개의 MMS 메시지를 저장할 리스트
    private val SMS_PERMISSION_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // MMS 읽기 권한 요청
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS), SMS_PERMISSION_CODE)
        } else {
            loadMmsFromInbox()  // 권한이 이미 허용된 경우 MMS 로드
        }

        // 액티비티가 처음 생성되었을 때 인텐트 처리
        intent?.let { handleSmsIntent(it) }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                loadMmsFromInbox()  // 권한이 허용되면 MMS 로드
            } else {
                // 권한이 거부된 경우 처리
            }
        }
    }

    private fun loadMmsFromInbox() {
        println("LOAD MMS =============================")
        val mmsCursor = contentResolver.query(
            Uri.parse("content://mms/inbox"),
            arrayOf("_id", "sub", "date"),
            null,
            null,
            "date DESC"
        )

        mmsCursor?.let {
            val idIndex = mmsCursor.getColumnIndex("_id")
            val subjectIndex = mmsCursor.getColumnIndex("sub")

            while (mmsCursor.moveToNext() && mmsList.size < 10) {
                val id = mmsCursor.getString(idIndex)
                val subject = mmsCursor.getString(subjectIndex) ?: "No Subject"
                val mmsMessage = "MMS with subject: $subject\nMessage: ${getMmsText(id)}"
                mmsList.add(mmsMessage)
            }
            mmsCursor.close()
        }

        // 최신 10개까지만 유지
        while (mmsList.size > 10) {
            mmsList.removeAt(0)
        }
    }

    private fun getMmsText(id: String): String {
        var message = ""
        val uri = Uri.parse("content://mms/part")
        val selection = "mid=$id"
        val cursor: Cursor? = contentResolver.query(uri, null, selection, null, null)

        cursor?.let {
            while (cursor.moveToNext()) {
                val partId = cursor.getString(cursor.getColumnIndex("_id"))
                val type = cursor.getString(cursor.getColumnIndex("ct"))

                if ("text/plain" == type) {
                    val data = cursor.getString(cursor.getColumnIndex("_data"))
                    message += if (data != null) {
                        getMmsTextFromPart(partId)
                    } else {
                        cursor.getString(cursor.getColumnIndex("text"))
                    }
                }
            }
            cursor.close()
        }

        return message
    }

    private fun getMmsTextFromPart(partId: String): String {
        val partUri = Uri.parse("content://mms/part/$partId")
        val sb = StringBuilder()
        val inputStream = contentResolver.openInputStream(partUri)
        inputStream?.let {
            val reader = it.bufferedReader()
            var line: String?

            while (reader.readLine().also { line = it } != null) {
                sb.append(line)
            }

            inputStream.close()
        }
        return sb.toString()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getLatestMessage" -> {
                    loadMmsFromInbox()  // MMS를 업데이트
                    result.success(mmsList)  // 최신 MMS 메시지 반환
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
            val mmsMessage = "From: $sender\nMessage: $body"
            updateMmsList(mmsMessage)

            flutterEngine?.let {
                MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("newSmsReceived", null)
            }
        }
    }

    private fun updateMmsList(newMessage: String) {
        if (mmsList.size >= 10) {
            mmsList.removeAt(0)
        }
        mmsList.add(newMessage)
    }
}