import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/core/app_names.dart';
import 'package:pos/view/components/common/custom_appbar.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../../core/utils/app_colors.dart';
import '../../components/common/fractionally_elevated_button.dart';
import '../../components/common/title_text.dart';

class PaymentScreen extends StatefulWidget {
  var amount; // Define amount as a double
  PaymentScreen({Key? key, this.amount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _serialData = [];
  bool success = false;

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(UsbDevice? device) async {
    _serialData.clear();

    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      await _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _transaction = Transaction.stringTerminated(
      _port!.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]),
    );

    _subscription = _transaction!.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });

      // Check transaction
      if (line.contains("Decline")) {
        print(">>>");
        checkTransactionFailed(line);
        Get.toNamed(RouteNames.homeScreen);
      }
      if (line.contains("APPROVED")) {
        checkTransactionSuccess(line);
        Get.toNamed(RouteNames.homeScreen);
      }
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isNotEmpty) {
      // Automatically connect to the first available device
      if (_device == null) {
        _connectTo(devices.first);
      }
    } else {
      // No devices found, ensure disconnection
      _connectTo(null);
    }
  }

  void checkTransactionFailed(String line) {
    setState(() {
      Get.snackbar(
        "Transaction Failed",
        "Card not issued",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void checkTransactionSuccess(String line) {
    setState(() {
      Get.snackbar(
        "Transaction Successfull",
        "Card Accepted",
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> _sendISO8583Message() async {
    if (_port == null) return;

    // Ensure the amount is a string and pad with leading zeros
    String amountStr = widget.amount.toString().padLeft(10, '0');

    // Construct the ISO 8583 message
    String message = "0200${amountStr}00";

    // Convert the message to a Uint8List to send it over USB
    Uint8List data = Uint8List.fromList(message.codeUnits);

    // Send the message
    await _port!.write(data);
    print("Sent: $message");

    // Optionally, clear the text field after sending
    _textController.text = "";
  }

  @override
  void initState() {
    super.initState();

    // Listen for USB events
    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      if (event.event == UsbEvent.ACTION_USB_ATTACHED) {
        _getPorts();
      } else if (event.event == UsbEvent.ACTION_USB_DETACHED) {
        _connectTo(null);
      }
    });

    // Check for available devices initially
    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          text: "Payment Screen",
          backgroundColor: AppColors.primaryMagentaGreenColor,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Center(
                child: FractionallyElevatedButton(
                  onTap:
                      _port == null
                          ? null
                          : () async {
                            await _sendISO8583Message();
                          },
                  child: TitleText(
                    title: "Proceed",
                    color: AppColors.white,
                    fontSize: 20,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              Text('Status: $_status'),
              Text(
                "Result Data",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // ..._serialData,
            ],
          ),
        ),
      ),
    );
  }
}
