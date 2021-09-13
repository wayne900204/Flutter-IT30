import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class RequirementStateController extends GetxController {
  /// 藍芽的狀態
  var bluetoothState = BluetoothState.stateOff.obs;
  /// 藍芽授權狀態
  var authorizationStatus = AuthorizationStatus.notDetermined.obs;
  /// 定位開啟狀態
  var locationService = false.obs;
  /// 是否開始 broadcasting
  var _startBroadcasting = false.obs;
  /// 是否開始掃描
  var _startScanning = false.obs;
  /// 是否暫停掃描
  var _pauseScanning = false.obs;
  /// 藍夜是否開啟
  bool get bluetoothEnabled => bluetoothState.value == BluetoothState.stateOn;
  /// 藍夜是否開啟
  bool get authorizationStatusOk =>
      authorizationStatus.value == AuthorizationStatus.allowed ||
      authorizationStatus.value == AuthorizationStatus.always;
  /// 是否有開啟定位
  bool get locationServiceEnabled => locationService.value;
  /// 更新藍芽的狀態
  updateBluetoothState(BluetoothState state) {
    bluetoothState.value = state;
  }
  /// 更新藍芽的登入狀態
  updateAuthorizationStatus(AuthorizationStatus status) {
    authorizationStatus.value = status;
  }
  /// 更新 Location 的狀態
  updateLocationService(bool flag) {
    locationService.value = flag;
  }
  /// 更新藍芽的登入狀態
  startBroadcasting() {
    _startBroadcasting.value = true;
  }
  /// 停止 Broadcasting
  stopBroadcasting() {
    _startBroadcasting.value = false;
  }
  /// 停止 Scanning
  startScanning() {
    _startScanning.value = true;
    _pauseScanning.value = false;
  }
  /// 暫停 Scanning
  pauseScanning() {
    _startScanning.value = false;
    _pauseScanning.value = true;
  }
  /// get開始 BroadCastStream
  Stream<bool> get startBroadcastStream {
    return _startBroadcasting.stream;
  }
  /// get StartScanningStream
  Stream<bool> get startScanningStream {
    return _startScanning.stream;
  }
  /// pause scanningString
  Stream<bool> get pauseScanningStream {
    return _pauseScanning.stream;
  }
}
