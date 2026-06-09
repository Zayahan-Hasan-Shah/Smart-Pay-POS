import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/bluetooth_server_service.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../view/components/common/custom_appbar.dart';
import '../../../../view/components/common/fractionally_elevated_button.dart';
import '../../../../core/utils/app_logger.dart';

enum ConnectionMode { usb, wifi, bluetooth }

class PaymentScreen extends StatefulWidget {
  final dynamic paymentData; // Map containing amount, billId, consumerNumber
  const PaymentScreen({super.key, this.paymentData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Common State
  ConnectionMode _currentMode = ConnectionMode.usb;
  String _status = "Idle";
  bool _isProcessing = false;

  // USB State
  UsbPort? _port;
  StreamSubscription<String>? _usbSubscription;
  StreamSubscription<UsbEvent>? _usbEventSubscription;
  Transaction<String>? _usbTransaction;
  UsbDevice? _usbDevice;

  // WiFi State
  Socket? _wifiSocket;
  String _savedIp = "192.168.1.100";
  int _savedPort = 8080;

  // Bluetooth State
  BluetoothServerService? _bluetoothServerService;
  bool _isBtConnected = false;

  // POS Parsed Data
  Map<String, String> _posReceiptData = {};

  @override
  void initState() {
    super.initState();
    AppLogger.info('PaymentScreen initialized', tag: 'LIFECYCLE');
    _loadSettings();
    _initUsbListener();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedIp = prefs.getString('wifi_ip') ?? "192.168.1.100";
      _savedPort = prefs.getInt('wifi_port') ?? 8080;
      final modeIndex = prefs.getInt('connection_mode') ?? 0;
      if (modeIndex >= ConnectionMode.values.length) {
        _currentMode = ConnectionMode.usb;
      } else {
        _currentMode = ConnectionMode.values[modeIndex];
      }
      _status = "Ready (${_currentMode.name})";
    });
    _handleModeChange();
  }

  Future<void> _saveSettings(ConnectionMode mode, String ip, int port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('connection_mode', mode.index);
    await prefs.setString('wifi_ip', ip);
    await prefs.setInt('wifi_port', port);

    setState(() {
      _currentMode = mode;
      _savedIp = ip;
      _savedPort = port;
      _status = "Ready (${_currentMode.name})";
    });
    _handleModeChange();
  }

  void _handleModeChange() {
    if (_currentMode == ConnectionMode.bluetooth) {
      _startBluetoothServer();
    } else {
      _bluetoothServerService?.dispose();
      _bluetoothServerService = null;
      _isBtConnected = false;
    }
  }

  Future<void> _startBluetoothServer() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.location.request();

    if (_bluetoothServerService == null) {
      _bluetoothServerService = BluetoothServerService();
      _bluetoothServerService!.events.listen((event) {
        if (event == "CONNECTED") {
          AppLogger.success(
            "Bluetooth Server: POS Connected!",
            tag: "BT_SERVER",
          );
          if (mounted)
            setState(() {
              _status = "POS Connected via Bluetooth!";
              _isBtConnected = true;
            });
        } else if (event == "DISCONNECTED") {
          AppLogger.info(
            "Bluetooth Server: POS Disconnected",
            tag: "BT_SERVER",
          );
          if (mounted)
            setState(() {
              _status = "Listening for POS connection...";
              _isBtConnected = false;
            });
        } else if (event is Uint8List) {
          String respStr = utf8.decode(event);
          AppLogger.info(
            'Received data from POS (BT): $respStr',
            tag: 'BT_DATA',
          );
          _handleResponse(respStr);
        }
      });
    }

    if (mounted) setState(() => _status = "Starting Bluetooth Server...");
    bool started = await _bluetoothServerService!.startServer();
    if (started) {
      if (mounted) setState(() => _status = "Listening for POS connection...");
    } else {
      if (mounted) setState(() => _status = "Failed to start Bluetooth Server");
    }
  }

  void _initUsbListener() {
    _usbEventSubscription = UsbSerial.usbEventStream!.listen((UsbEvent event) {
      AppLogger.info('USB Event triggered: ${event.event}', tag: 'USB_EVENT');
      if (event.event == UsbEvent.ACTION_USB_ATTACHED) {
        _getUsbPorts();
      } else if (event.event == UsbEvent.ACTION_USB_DETACHED) {
        _connectToUsb(null);
      }
    });
    _getUsbPorts();
  }

  void _getUsbPorts() async {
    AppLogger.action('Scanning for attached USB devices...', tag: 'USB_SCAN');
    List<UsbDevice> devices = await UsbSerial.listDevices();
    AppLogger.info('Found ${devices.length} USB device(s)', tag: 'USB_SCAN');

    if (devices.isNotEmpty) {
      if (_usbDevice == null) {
        // Try all devices/interfaces until one connects successfully
        for (var device in devices) {
          AppLogger.info(
            'Trying device: ${device.deviceName}',
            tag: 'USB_SCAN',
          );
          bool success = await _connectToUsb(device);
          if (success) {
            AppLogger.success(
              'Successfully connected to ${device.deviceName}',
              tag: 'USB_SCAN',
            );
            break;
          }
        }
      }
    } else {
      _connectToUsb(null);
    }
  }

  Future<bool> _connectToUsb(UsbDevice? device) async {
    if (_usbSubscription != null) {
      await _usbSubscription!.cancel();
      _usbSubscription = null;
    }
    if (_usbTransaction != null) {
      _usbTransaction!.dispose();
      _usbTransaction = null;
    }
    if (_port != null) {
      await _port!.close();
      _port = null;
    }

    if (device == null) {
      _usbDevice = null;
      if (mounted && _currentMode == ConnectionMode.usb) {
        setState(() => _status = "USB Disconnected");
      }
      return true;
    }

    AppLogger.info('Creating port for device...', tag: 'USB_CONNECT');
    try {
      _port = await device.create();
    } catch (e) {
      AppLogger.error(
        'Device is not a valid Serial port: $e',
        tag: 'USB_CONNECT',
      );
      if (mounted && _currentMode == ConnectionMode.usb) {
        setState(() => _status = "Error: Not a Serial Device");
        SnackbarService.showError(
          "Connection Failed",
          "The connected device is not recognized as a Serial POS.",
        );
      }
      return false;
    }

    AppLogger.info('Opening port...', tag: 'USB_CONNECT');
    if (await (_port!.open()) != true) {
      AppLogger.error('Failed to open port for device', tag: 'USB_CONNECT');
      if (mounted && _currentMode == ConnectionMode.usb) {
        setState(() => _status = "Failed to open USB port");
      }
      return false;
    }
    _usbDevice = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _usbTransaction = Transaction.stringTerminated(
      _port!.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]),
    );

    _usbSubscription = _usbTransaction!.stream.listen((String line) {
      AppLogger.info('Received data from POS (USB): $line', tag: 'USB_DATA');
      _handleResponse(line);
    });

    if (mounted && _currentMode == ConnectionMode.usb) {
      setState(() => _status = "USB Connected");
    }
    return true;
  }

  void _handleResponse(String line) {
    if (line.contains("=")) {
      var parts = line.split("=");
      if (parts.length >= 2) {
        String key = parts[0].trim();
        String value = parts.sublist(1).join("=").trim();
        _posReceiptData[key] = value;
      }
    }

    if (line.contains("Decline")) {
      if (!mounted) return;
      SnackbarService.showError("Transaction Failed", "Card declined by POS");
      context.go(RouteNames.homeScreen);
    }

    if (line.contains("---END---")) {
      if (!mounted) return;

      if (_posReceiptData["RESPONSE"] == "APPROVED" ||
          _posReceiptData.values.any((v) => v.contains("APPROVED")) ||
          line.contains("APPROVED")) {
        final receiptPayload = {
          "paymentData": widget.paymentData,
          "posData": Map<String, String>.from(_posReceiptData),
        };
        context.go(RouteNames.transactionReceiptScreen, extra: receiptPayload);
      } else {
        SnackbarService.showError(
          "Transaction Failed",
          "Transaction was not approved.",
        );
        context.go(RouteNames.homeScreen);
      }
    }
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _posReceiptData.clear();
    });

    String amountStr = "0";
    if (widget.paymentData is Map) {
      amountStr = (widget.paymentData["amount"]?.toString() ?? "0").padLeft(
        10,
        '0',
      );
    } else {
      amountStr = widget.paymentData.toString().padLeft(10, '0');
    }

    String message = "0200${amountStr}00";
    Uint8List data = Uint8List.fromList(message.codeUnits);
    AppLogger.action(
      'Proceed button tapped. Mode: ${_currentMode.name}',
      tag: 'PAYMENT',
    );

    try {
      if (_currentMode == ConnectionMode.usb) {
        if (_port == null) throw Exception("USB Port not connected");
        AppLogger.info('Writing data to USB port...', tag: 'PAYMENT');
        await _port!.write(data);
        AppLogger.success('Sent payload via USB: $message', tag: 'PAYMENT');
        setState(() => _status = "Sent via USB. Waiting...");
      } else if (_currentMode == ConnectionMode.wifi) {
        setState(() => _status = "Connecting to WiFi POS...");
        AppLogger.info(
          'Connecting to WiFi Socket $_savedIp:$_savedPort',
          tag: 'WIFI_CONNECT',
        );
        _wifiSocket = await Socket.connect(
          _savedIp,
          _savedPort,
          timeout: const Duration(seconds: 5),
        );

        _wifiSocket!.listen(
          (Uint8List response) {
            String respStr = utf8.decode(response);
            AppLogger.info(
              'Received data from POS (WiFi): $respStr',
              tag: 'WIFI_DATA',
            );
            _handleResponse(respStr);
          },
          onError: (error) {
            AppLogger.error('WiFi Socket Error: $error', tag: 'WIFI_ERROR');
            if (mounted) setState(() => _status = "WiFi Error");
          },
          onDone: () {
            _wifiSocket?.destroy();
            _wifiSocket = null;
            // context.go(RouteNames.homeScreen);
          },
        );

        _wifiSocket!.add(data);
        AppLogger.success('Sent payload via WiFi: $message', tag: 'PAYMENT');
        setState(() => _status = "Sent via WiFi. Waiting...");
      } else if (_currentMode == ConnectionMode.bluetooth) {
        if (!_isBtConnected)
          throw Exception(
            "POS is not connected. Wait for POS to connect to the app first.",
          );

        AppLogger.info(
          'Sending payload via Bluetooth Server...',
          tag: 'PAYMENT',
        );
        bool sent = await _bluetoothServerService?.sendData(data) ?? false;
        if (sent) {
          AppLogger.success(
            'Sent payload via Bluetooth: $message',
            tag: 'PAYMENT',
          );
          setState(() => _status = "Sent via Bluetooth. Waiting...");
        } else {
          throw Exception("Failed to send data to POS.");
        }
      }
    } catch (e) {
      AppLogger.error('Payment Error', error: e, tag: 'PAYMENT_ERR');
      if (mounted) {
        setState(() => _status = "Error: $e");
        SnackbarService.showError("Connection Error", e.toString());
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSettingsDialog() async {
    TextEditingController ipController = TextEditingController(text: _savedIp);
    TextEditingController portController = TextEditingController(
      text: _savedPort.toString(),
    );
    ConnectionMode tempMode = _currentMode;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('POS Connection Settings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<ConnectionMode>(
                      value: tempMode,
                      isExpanded: true,
                      items:
                          ConnectionMode.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          tempMode = val!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (tempMode == ConnectionMode.wifi) ...[
                      TextField(
                        controller: ipController,
                        decoration: const InputDecoration(
                          labelText: 'POS IP Address',
                        ),
                      ),
                      TextField(
                        controller: portController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'POS Port',
                        ),
                      ),
                    ],
                    if (tempMode == ConnectionMode.bluetooth)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Please manually find your mobile's MAC address in Android Settings > About Phone, and enter it into the POS ECR menu.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveSettings(
                      tempMode,
                      ipController.text,
                      int.tryParse(portController.text) ?? 8080,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _usbEventSubscription?.cancel();
    _usbSubscription?.cancel();
    _usbTransaction?.dispose();
    _port?.close();
    _wifiSocket?.destroy();
    _bluetoothServerService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsDialog,
        backgroundColor: Colors.white,
        child: const Icon(Icons.settings, color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 12.h),
          Center(
            child: Image.asset(
              AssetsPath.appLogo,
              width: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Mode: ${_currentMode.name.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 2.h),
          FractionallyElevatedButton(
            onTap: _isProcessing ? () {} : _processPayment,
            title: _isProcessing ? 'Processing...' : 'Proceed',
          ),
          SizedBox(height: 2.h),
          Text(
            'Status: $_status',
            style: const TextStyle(color: Colors.black54),
          ),
          if (_currentMode == ConnectionMode.bluetooth)
            const Padding(
              padding: EdgeInsets.only(top: 12.0, left: 24, right: 24),
              child: Text(
                "Please enter your mobile's MAC address into the POS machine to pair.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
