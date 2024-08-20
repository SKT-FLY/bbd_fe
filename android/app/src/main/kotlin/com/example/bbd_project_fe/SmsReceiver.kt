package com.example.bbd_project_fe

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("SmsReceiver", "SMS received")

        if (intent != null && intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            try {
                val bundle = intent.extras
                val pdus = bundle?.get("pdus") as? Array<*>
                val messages: MutableList<SmsMessage> = ArrayList()

                pdus?.forEach { pdu ->
                    messages.add(SmsMessage.createFromPdu(pdu as ByteArray))
                }

                messages.forEach { message ->
                    val sender = message.displayOriginatingAddress
                    val body = message.messageBody
                    Log.d("SmsReceiver", "SMS from $sender: $body")

                    // MainActivity로 SMS 데이터를 전달하는 intent 생성
                    val smsIntent = Intent(context, MainActivity::class.java).apply {
                        putExtra("sms_sender", sender)
                        putExtra("sms_body", body)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    }
                    Log.d("SmsReceiver", "Sending SMS data to MainActivity")
                    context?.startActivity(smsIntent)
                }
            } catch (e: Exception) {
                Log.e("SmsReceiver", "Error processing SMS: ${e.message}")
            }
        } else {
            Log.e("SmsReceiver", "Intent action not matched or null")
        }
    }
}
