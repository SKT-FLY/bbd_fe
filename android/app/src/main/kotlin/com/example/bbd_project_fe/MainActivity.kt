package com.example.bbd_project_fe

import android.content.ContentResolver
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.provider.Telephony
import android.util.Log  // Log 클래스를 import
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sms_retriever"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAllSms" -> {
                    Log.d("MainActivity", "getAllSms method called")
                    val smsList = getAllSms()
                    result.success(smsList)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getAllSms(): List<String> {
        val smsList = mutableListOf<String>()
        val uri: Uri = Telephony.Sms.Inbox.CONTENT_URI
        val projection = arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE)
        val sortOrder = "${Telephony.Sms.DATE} DESC"
        val cursor: Cursor? = contentResolver.query(uri, projection, null, null, sortOrder)

        cursor?.use {
            val addressIndex = it.getColumnIndex(Telephony.Sms.ADDRESS)
            val bodyIndex = it.getColumnIndex(Telephony.Sms.BODY)

            while (it.moveToNext()) {
                val address = it.getString(addressIndex)
                val body = it.getString(bodyIndex)
                Log.d("MainActivity", "SMS from $address: $body")
                smsList.add("From: $address\nMessage: $body")
            }
        }

        return smsList
    }
}
