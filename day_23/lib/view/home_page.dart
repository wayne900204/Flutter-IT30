import 'dart:async';
import 'dart:io';

import 'package:day_23/controller/requirement_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'package:get/get.dart';

import 'app_broadcasting.dart';
import 'app_scanning.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final controller = Get.find<RequirementStateController>();
  ///  監聽 BluetoothState 的狀態。
  StreamSubscription<BluetoothState>? _streamBluetooth;
  int currentIndex = 0;

  @override
  void initState() {
    // 新增觀察者
    WidgetsBinding.instance?.addObserver(this);

    super.initState();

    listeningState();
  }

  // 監聽藍芽狀態。
  listeningState() async {
    /// 下面這一行，是我自己加上去的， initState 的時候，先去檢查權限。
    await checkAllRequirements();
    /// 監聽狀態，狀態改變檢查權限
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      controller.updateBluetoothState(state);
      await checkAllRequirements();
    });
  }

  /// 檢查權限
  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    controller.updateBluetoothState(bluetoothState);
    print('BLUETOOTH $bluetoothState');

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    controller.updateAuthorizationStatus(authorizationStatus);
    print('AUTHORIZATION $authorizationStatus');

    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;
    controller.updateLocationService(locationServiceEnabled);
    print('LOCATION SERVICE $locationServiceEnabled');

    if (controller.bluetoothEnabled &&
        controller.authorizationStatusOk &&
        controller.locationServiceEnabled) {
      print('STATE READY');
      if (currentIndex == 0) {
        print('SCANNING');
        controller.startScanning();
      } else {
        print('BROADCASTING');
        controller.startBroadcasting();
      }
    } else {
      print('STATE NOT READY');
      controller.pauseScanning();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.inactive) {
      // 如果來了個電話，電話會進入前景，因此會觸發此狀態。
    }
    if (state == AppLifecycleState.resumed) {
      // 應用進入前景
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
        }
      }
      await checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {
      // 應用進入背景
      _streamBluetooth?.pause();
    }
  }

  @override
  void dispose() {
    _streamBluetooth?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Beacon'),
        centerTitle: false,
        actions: <Widget>[
          Obx(() {
            if (!controller.locationServiceEnabled)
              return IconButton(
                tooltip: 'Not Determined',
                icon: Icon(Icons.portable_wifi_off),
                color: Colors.grey,
                onPressed: () {},
              );

            if (!controller.authorizationStatusOk)
              return IconButton(
                tooltip: 'Not Authorized',
                icon: Icon(Icons.portable_wifi_off),
                color: Colors.red,
                onPressed: () async {
                  await flutterBeacon.requestAuthorization;
                },
              );

            return IconButton(
              tooltip: 'Authorized',
              icon: Icon(Icons.wifi_tethering),
              color: Colors.blue,
              onPressed: () async {
                await flutterBeacon.requestAuthorization;
              },
            );
          }),
          Obx(() {
            return IconButton(
              tooltip: controller.locationServiceEnabled
                  ? 'Location Service ON'
                  : 'Location Service OFF',
              icon: Icon(
                controller.locationServiceEnabled
                    ? Icons.location_on
                    : Icons.location_off,
              ),
              color:
                  controller.locationServiceEnabled ? Colors.blue : Colors.red,
              onPressed: controller.locationServiceEnabled
                  ? () {}
                  : handleOpenLocationSettings,
            );
          }),
          Obx(() {
            final state = controller.bluetoothState.value;

            if (state == BluetoothState.stateOn) {
              return IconButton(
                tooltip: 'Bluetooth ON',
                icon: Icon(Icons.bluetooth_connected),
                onPressed: () {},
                color: Colors.lightBlueAccent,
              );
            }

            if (state == BluetoothState.stateOff) {
              return IconButton(
                tooltip: 'Bluetooth OFF',
                icon: Icon(Icons.bluetooth),
                onPressed: handleOpenBluetooth,
                color: Colors.red,
              );
            }

            return IconButton(
              icon: Icon(Icons.bluetooth_disabled),
              tooltip: 'Bluetooth State Unknown',
              onPressed: () {},
              color: Colors.grey,
            );
          }),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          // TabScanning(),
          TabScanning(),
          TabBroadcasting(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (currentIndex == 0) {
            controller.startScanning();
          } else {
            controller.pauseScanning();
            controller.startBroadcasting();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_audio),
            label: 'Broadcast',
          ),
        ],
      ),
    );
  }
  /// 開啟定位
  handleOpenLocationSettings() async {
    if (Platform.isAndroid) {
      await flutterBeacon.openLocationSettings;
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Services Off'),
            content: Text(
              'Please enable Location Services on Settings > Privacy > Location Services.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  /// 開啟藍芽
  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bluetooth is Off'),
            content: Text('Please enable Bluetooth on Settings > Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
