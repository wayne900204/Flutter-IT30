import 'dart:async';

import 'package:day_23/controller/requirement_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class TabScanning extends StatefulWidget {
  @override
  _TabScanningState createState() => _TabScanningState();
}

class _TabScanningState extends State<TabScanning> {
///  監聽 RangingResult 的資料，用來管理是否有在監聽。
  StreamSubscription<RangingResult>? _streamRanging;
  /// 用來記錄 beacons 的資料。
  final _regionBeacons = <Region, List<Beacon>>{};
  /// 把 _regionBeacons 的 mpa value 全部存入這個 list
  final _beacons = <Beacon>[];
  final controller = Get.find<RequirementStateController>();

  @override
  void initState() {
    super.initState();
    /// 監聽開啟掃描的 bool stream
    controller.startScanningStream.listen((flag) {
      if (flag == true) {
        initScanBeacon();
      }
    });
    /// 監聽開啟掃描的 bool stream
    controller.pauseScanningStream.listen((flag) {
      if (flag == true) {
        pauseScanBeacon();
      }
    });
  }
  /// 開始掃描。
  initScanBeacon() async {
    /// 初始化 Scanning
    await flutterBeacon.initializeScanning;
    /// 沒權限的話，就停止開始掃描
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      print(
          'RETURNED, authorizationStatusOk=${controller
              .authorizationStatusOk}, '
              'locationServiceEnabled=${controller.locationServiceEnabled}, '
              'bluetoothEnabled=${controller.bluetoothEnabled}');
      return;
    }
    /// 定義要掃描的地區。
    final regions = <Region>[
      Region(
        identifier: 'Cubeacon',
        proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC',
      ),
      Region(
        identifier: 'BeaconType2',
        proximityUUID: '6a84c716-0f2a-1ce9-f210-6a63bd873dd9',
      ),
    ];
    /// 如果他監聽器被暫停了，就恢復它。
    if (_streamRanging != null) {
      if (_streamRanging!.isPaused) {
        _streamRanging?.resume();
        return;
      }
    }
    /// 監聽器開始監聽，並把資料存入變數裡面。
    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
          print(result);
          if (mounted) {
            setState(() {
              _regionBeacons[result.region] = result.beacons;
              _beacons.clear();
              _regionBeacons.values.forEach((list) {
                _beacons.addAll(list);
              });
              _beacons.sort(_compareParameters);
            });
          }
        });
  }
  /// 暫停監聽器、並清空資料。
  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }
  /// Beacon 的排序
  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }
  /// 關病監聽器。
  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _beacons.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: _beacons.map(
                (beacon) {
              return ListTile(
                title: Text(
                  beacon.proximityUUID,
                  style: TextStyle(fontSize: 15.0),
                ),
                subtitle: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Text(
                        'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      flex: 2,
                      fit: FlexFit.tight,
                    )
                  ],
                ),
              );
            },
          ),
        ).toList(),
      ),
    );
  }
}
