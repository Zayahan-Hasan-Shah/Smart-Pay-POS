package com.example.pos

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream
import java.io.OutputStream
import java.util.UUID
import kotlin.concurrent.thread

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.pos/bluetooth_server_method"
    private val EVENT_CHANNEL = "com.example.pos/bluetooth_server_event"
    private val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

    private var serverSocket: BluetoothServerSocket? = null
    private var clientSocket: BluetoothSocket? = null
    private var inputStream: InputStream? = null
    private var outputStream: OutputStream? = null

    private var eventSink: EventChannel.EventSink? = null
    private var isListening = false
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startServer" -> {
                    startBluetoothServer(result)
                }
                "stopServer" -> {
                    stopBluetoothServer()
                    result.success(null)
                }
                "sendData" -> {
                    val data = call.argument<ByteArray>("data")
                    if (data != null) {
                        sendData(data, result)
                    } else {
                        result.error("INVALID_DATA", "Data cannot be null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    private fun startBluetoothServer(result: MethodChannel.Result) {
        if (isListening) {
            result.success(true)
            return
        }

        val adapter = BluetoothAdapter.getDefaultAdapter()
        if (adapter == null) {
            result.error("NO_BLUETOOTH", "Bluetooth is not supported", null)
            return
        }

        try {
            serverSocket = adapter.listenUsingRfcommWithServiceRecord("POS_App", SPP_UUID)
            isListening = true
            result.success(true)

            thread {
                var localSocket: BluetoothSocket? = null
                while (isListening) {
                    try {
                        localSocket = serverSocket?.accept()
                    } catch (e: Exception) {
                        break
                    }
                    if (localSocket != null) {
                        // Connection accepted
                        clientSocket = localSocket
                        inputStream = localSocket.inputStream
                        outputStream = localSocket.outputStream
                        
                        mainHandler.post {
                            eventSink?.success("CONNECTED")
                        }

                        // Start reading data
                        val buffer = ByteArray(1024)
                        var bytes: Int
                        while (true) {
                            try {
                                bytes = inputStream!!.read(buffer)
                                val readBuffer = buffer.copyOf(bytes)
                                mainHandler.post {
                                    eventSink?.success(readBuffer)
                                }
                            } catch (e: Exception) {
                                mainHandler.post {
                                    eventSink?.success("DISCONNECTED")
                                }
                                break
                            }
                        }
                    }
                }
            }
        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", "Missing Bluetooth permissions", null)
        } catch (e: Exception) {
            result.error("SERVER_ERROR", e.message, null)
        }
    }

    private fun stopBluetoothServer() {
        isListening = false
        try {
            serverSocket?.close()
            clientSocket?.close()
        } catch (e: Exception) { }
        serverSocket = null
        clientSocket = null
        inputStream = null
        outputStream = null
    }

    private fun sendData(data: ByteArray, result: MethodChannel.Result) {
        if (outputStream == null) {
            result.error("NOT_CONNECTED", "No active connection", null)
            return
        }
        thread {
            try {
                outputStream?.write(data)
                outputStream?.flush()
                mainHandler.post { result.success(true) }
            } catch (e: Exception) {
                mainHandler.post { result.error("SEND_ERROR", e.message, null) }
            }
        }
    }
}
