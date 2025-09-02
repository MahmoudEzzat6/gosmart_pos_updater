package com.example.gosmart_pos

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_NOT_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbManager
import android.os.Bundle
import android.util.Log
import com.hoho.android.usbserial.driver.UsbSerialDriver
import com.hoho.android.usbserial.driver.UsbSerialPort
import com.hoho.android.usbserial.driver.UsbSerialProber
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity : FlutterActivity() {

    private val CHANNEL = "vfd.serial/connection"
    private val ACTION_USB_PERMISSION = "com.example.vfd.USB_PERMISSION"

    private var usbPort: UsbSerialPort? = null
    private var pendingMessage: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "sendToVFD") {
                val message = call.argument<String>("text") ?: ""
                val sent = trySendToSerial(message)
                if (sent) {
                    result.success("Message sent to VFD")
                } else {
                    result.error("SEND_FAILED", "Could not send to serial", null)
                }
            }
        }
    }

    private fun trySendToSerial(message: String): Boolean {
        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        val drivers = UsbSerialProber.getDefaultProber().findAllDrivers(usbManager)
        if (drivers.isEmpty()) {
            Log.e("VFD", "No USB drivers found")
            return false
        }

        val driver = drivers[0]
        val device = driver.device

        if (!usbManager.hasPermission(device)) {
            val permissionIntent = PendingIntent.getBroadcast(this, 0, Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE)
            registerReceiver(usbPermissionReceiver, IntentFilter(ACTION_USB_PERMISSION), RECEIVER_NOT_EXPORTED)
            pendingMessage = message
            usbManager.requestPermission(device, permissionIntent)
            return false
        }

        return openAndSend(usbManager, driver, message)
    }

    private fun openAndSend(usbManager: UsbManager, driver: UsbSerialDriver, message: String): Boolean {
        val connection: UsbDeviceConnection = usbManager.openDevice(driver.device) ?: return false
        val port = driver.ports[0]

        return try {
            port.open(connection)
            port.setParameters(9600, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE)

            Thread.sleep(100)

            // ✅ Step 1: Clear VFD screen
            port.write(byteArrayOf(0x0C), 1000)
            Thread.sleep(100)

            // ✅ Step 2: Send message with line break
            val fullMessage = "$message\r\n"
            port.write(fullMessage.toByteArray(Charsets.US_ASCII), 1000)

            Thread.sleep(100)
            port.close()
            Log.d("VFD", "Sent: $fullMessage")
            true
        } catch (e: IOException) {
            Log.e("VFD", "Serial error", e)
            false
        }
    }

    private val usbPermissionReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == ACTION_USB_PERMISSION) {
                synchronized(this) {
                    val device: UsbDevice? = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE)
                    if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false) && device != null) {
                        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
                        val drivers = UsbSerialProber.getDefaultProber().findAllDrivers(usbManager)
                        val driver = drivers.find { it.device.deviceId == device.deviceId }
                        if (driver != null && pendingMessage != null) {
                            openAndSend(usbManager, driver, pendingMessage!!)
                            pendingMessage = null
                        }
                    } else {
                        Log.e("VFD", "USB permission denied")
                    }
                    unregisterReceiver(this)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(usbPermissionReceiver)
        } catch (_: Exception) {}
    }
}
