import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../widgets/no_internet_dialog.dart';

class ConnectionStatusListener {
  static final _singleton = ConnectionStatusListener._internal();

  ConnectionStatusListener._internal();

  bool hasShownNoInternet = false;
  static bool isOnHomePage = true;
  final Connectivity _connectivity = Connectivity();
  static ConnectionStatusListener getInstance() => _singleton;

  bool hasConnection = false;
  StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();

  Stream<bool> get connectionChange => connectionChangeController.stream;

  // Update the connection state when connectivity changes
  void _connectionChange(List<ConnectivityResult> resultList) {
    // You may want to check multiple results to determine the final status
    if (resultList.isNotEmpty) {
      checkConnection();
    }
  }

  // Checks if there is an active internet connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection || isOnHomePage );
    }

    return hasConnection;
  }

  // Initialize the listener for connectivity changes
  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange); // Listen for changes
    await checkConnection();
  }

  // Close the stream when done
  void dispose() {
    connectionChangeController.close();
  }
}

void updateConnectivity(
    bool hasConnection,
    ConnectionStatusListener connectionStatus,
    ) {
  if (!hasConnection && !ConnectionStatusListener.isOnHomePage) {
    if (!connectionStatus.hasShownNoInternet) {
      connectionStatus.hasShownNoInternet = true;
      Get.dialog(
        NoInternetDialog(
          onPress: () async {
            bool isConnected = await connectionStatus.checkConnection();
            if (isConnected) {
              connectionStatus.hasShownNoInternet = false;
              Get.back(); // Close the dialog if connected
            }
          },
        ),
        barrierDismissible: false,
      );
    }
  } else {
    // Close the dialog when connection is back
    if (connectionStatus.hasShownNoInternet) {
      connectionStatus.hasShownNoInternet = false;
      Get.back();
    }
  }
}


// Function to initialize the internet connection listener
void initNoInternetListener() async {
  var connectionStatus = ConnectionStatusListener.getInstance();
  await connectionStatus.initialize();

  // Check initial connection status
  if (!connectionStatus.hasConnection) {
    updateConnectivity(false, connectionStatus);
  }

  // Listen to the connection changes and update the dialog state
  connectionStatus.connectionChange.listen((hasConnection) {
    updateConnectivity(hasConnection, connectionStatus);
  });
}
