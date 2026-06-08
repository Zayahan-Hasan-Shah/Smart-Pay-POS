import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:pos/core/utils/app_logger.dart';

class BluetoothServerService {
  static const MethodChannel _methodChannel = MethodChannel('com.example.pos/bluetooth_server_method');
  static const EventChannel _eventChannel = EventChannel('com.example.pos/bluetooth_server_event');

  final StreamController<dynamic> _eventStreamController = StreamController<dynamic>.broadcast();
  StreamSubscription? _eventSubscription;

  BluetoothServerService() {
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      _eventStreamController.add(event);
    }, onError: (error) {
      AppLogger.error("Bluetooth Server Event Error: $error");
    });
  }

  Stream<dynamic> get events => _eventStreamController.stream;

  Future<bool> startServer() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool>('startServer');
      return result ?? false;
    } on PlatformException catch (e) {
      AppLogger.error("Failed to start Bluetooth server: ${e.message}");
      return false;
    }
  }

  Future<void> stopServer() async {
    try {
      await _methodChannel.invokeMethod('stopServer');
    } on PlatformException catch (e) {
      AppLogger.error("Failed to stop Bluetooth server: ${e.message}");
    }
  }

  Future<bool> sendData(Uint8List data) async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool>('sendData', {'data': data});
      return result ?? false;
    } on PlatformException catch (e) {
      AppLogger.error("Failed to send data via Bluetooth server: ${e.message}");
      return false;
    }
  }

  void dispose() {
    _eventSubscription?.cancel();
    _eventStreamController.close();
    stopServer();
  }
}
