import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchaseUtils extends GetxController {
  InAppPurchaseUtils._();
  static final InAppPurchaseUtils _instance = InAppPurchaseUtils._();
  static InAppPurchaseUtils get inAppPurchaseUtilsInstance => _instance;
  RxBool isSubscriptionActive = false.obs;
  Package? package;

  List<StoreProduct> products = [];

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_yLdoTCpJhHKXedcGbHjwHWNPxIk");
    } else {
      configuration =
          PurchasesConfiguration("appl_zAbxAzsURVvsOWqLzsraDzdIUzH");
    }
    await Purchases.configure(configuration);
  }

  Future fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffer = offerings.current;
      products.clear();
      if (currentOffer != null && currentOffer.availablePackages.isNotEmpty) {
        products = offerings.current!.availablePackages
            .map((pkg) => pkg.storeProduct)
            .toList();
        package = currentOffer.annual;
      }
      if (products.isEmpty) {
        Get.snackbar("Plans", "No Plans Found");
        return;
      }
    } catch (e, st) {
      log("Fetch offers", error: e, stackTrace: st);
    }
  }

  Future<void> purchaseProduct() async {
    try {
      await fetchOffers();
      final purchaserInfo = await Purchases.purchasePackage(package!);
      if (purchaserInfo.entitlements.active.containsKey('premium_annual')) {
        await checkSubscription();
      }
    } on PurchasesErrorCode catch (e) {
      debugPrint('Error purchasing product: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      if (purchaserInfo.entitlements.active.containsKey('premium_annual')) {
        debugPrint('Restoration successful!');
      }
    } on PurchasesErrorCode catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  Future<void> checkSubscription() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      if (purchaserInfo.entitlements.active.containsKey('premium_annual')) {
        isSubscriptionActive.value = true;
        print("letssssssssssssssssss gooooooooooooooooooooooooooooooooo");
      } else {
        isSubscriptionActive.value = false;
      }
    } catch (e) {
      debugPrint('Error checking subscription: $e');
    }
  }

  Future initInApp() async {
    try {
      await initPlatformState();
      await fetchOffers();
      await checkSubscription();
    } catch (e, st) {
      log("", error: e, stackTrace: st);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
