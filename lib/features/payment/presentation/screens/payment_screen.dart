import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../view/components/common/custom_appbar.dart';
import '../../../../view/components/common/fractionally_elevated_button.dart';
import '../../../../view/components/common/title_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';


class PaymentScreen extends StatefulWidget {
  final amount; // Define amount as a double
  const PaymentScreen({super.key, this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _serialData = [];
  bool success = false;

  StreamSubscription<String>? _subscription;
  StreamSubscription<UsbEvent>? _usbEventSubscription;
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
      if (mounted) {
        setState(() {
          _status = "Disconnected";
        });
      }
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      if (mounted) {
        setState(() {
          _status = "Failed to open port";
        });
      }
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
      if (mounted) {
        setState(() {
          _serialData.add(Text(line));
          if (_serialData.length > 20) {
            _serialData.removeAt(0);
          }
        });
      }

      // Check transaction
      if (line.contains("Decline")) {
        print(">>>");
        checkTransactionFailed(line);
        context.go(RouteNames.homeScreen);
      }
      if (line.contains("APPROVED")) {
        checkTransactionSuccess(line);
        context.go(RouteNames.homeScreen);
      }
    });

    if (mounted) {
      setState(() {
        _status = "Connected";
      });
    }
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
    if (!mounted) return;
    SnackbarService.showError("Transaction Failed", "Card not issued");
  }

  void checkTransactionSuccess(String line) {
    if (!mounted) return;
    SnackbarService.showSuccess("Transaction Successfull", "Card Accepted");
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
    _usbEventSubscription = UsbSerial.usbEventStream!.listen((UsbEvent event) {
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
    _usbEventSubscription?.cancel();
    _subscription?.cancel();
    _transaction?.dispose();
    _port?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
        appBar: CustomAppBar(),
        // AppBar(
        //   backgroundColor: AppColors.primaryColor,
        //   title: Text(
        //     'PAYMENT',
        //     style: TextStyle(
        //       color: AppColors.white,
        //       fontSize: 22,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        //   centerTitle: false,
        // ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 12.h),
            Center(
              child: Image.asset(
                AssetsPath.appLogo,
                width: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            SizedBox(height: 4.h),
            FractionallyElevatedButton(
              onTap:
                  _port == null
                      ? null
                      : () async {
                        await _sendISO8583Message();
                      },
              title: 'Proceed',
              // TitleText(
              //   title: "PROCEED",
              //   color: AppColors.white,
              //   fontSize: 13,
              //   weight: FontWeight.w700,
              // ),
            ),
            SizedBox(height: 2.h),

            Text('Status: $_status', style: TextStyle(color: Colors.black54)),
            SizedBox(height: 2.h),
            Text("Result Data", style: Theme.of(context).textTheme.titleLarge),
            // ..._serialData,
          ],
        ),
      
    );
  }
}
