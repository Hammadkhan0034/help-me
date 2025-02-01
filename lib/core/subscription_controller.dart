import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:alarm_app/widgets/no_notifications_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchaseUtils extends GetxController {
  InAppPurchaseUtils._();
  static final InAppPurchaseUtils _instance = InAppPurchaseUtils._();
  static InAppPurchaseUtils get inAppPurchaseUtilsInstance => _instance;
  RxBool isSubscriptionActive = false.obs;
  Package? package;
  Timer? timer;
  final authController = Get.find<AuthController>();
  bool isSubscribed() {
    bool isManuallySubscribed = false;
    print(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${authController.userModel.value.subscriptionExpiryDate?.toIso8601String()}");
    if (authController.userModel.value.subscriptionExpiryDate == null) {
      isManuallySubscribed = false;
    } else {
      final dateNow = DateTime.now();
      isManuallySubscribed = dateNow
          .isBefore(authController.userModel.value.subscriptionExpiryDate!);
    }

    return isSubscriptionActive.value || isManuallySubscribed;
  }

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
    if (Platform.isAndroid) return;
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
      Get.snackbar("Plans", "Couldn't fetch products from the app store.");

      log("Fetch offers", error: e, stackTrace: st);
    }
  }

  Future purchaseProductIOS() async {
    try {
      products.clear();
      products = await Purchases.getProducts(["premium_annual"]);

      if (products.isEmpty) {
        Get.snackbar("Plans", "No Plans Found");
        return;
      }

      final purchaserInfo =
          await Purchases.purchaseStoreProduct(products.first);
      if (purchaserInfo.entitlements.active.containsKey('premium_annual')) {
        await checkSubscription();
      }
    } catch (e, st) {
      log("Fetch fetchOffersIos", error: e, stackTrace: st);
    }
  }

  performPurchase() async {
    if (isSubscribed()) {
      Utils.showSuccessSnackBar(
        title: 'Already Subscribed',
        description: 'You are already subscribed to the premium plan.',
      );
      return;
    }
    if(Platform.isAndroid){
      Get.dialog(SubscriptionDialog());
      return;
    }

     purchaseProduct();
  }

  Future<void> purchaseProduct() async {
    if (isSubscriptionActive.value) {
      return;
    }
    Get.showOverlay(
        asyncFunction: () async {
          try {
            await fetchOffers();
            final purchaserInfo = await Purchases.purchasePackage(package!);
            if (purchaserInfo.entitlements.active
                .containsKey('premium_annual')) {
              await checkSubscription();
            }
          } catch (e, st) {
            log('Error purchasing product', error: e, stackTrace: st);
          }
        },
        loadingWidget: Center(
          child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ));
  }

  Future<void> restorePurchases() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      if (purchaserInfo.entitlements.active.containsKey('premium_annual')) {
        await checkSubscription();
      }
      if (purchaserInfo.activeSubscriptions.isEmpty) {
        Utils.showSuccessSnackBar(
            title: "Restore Subscription",
            description: "No subscription active.");
      } else {
        Utils.showSuccessSnackBar(
            title: "Restore Purchase",
            description: "Purchase successfully restored.");
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
      if (Platform.isIOS) {
        await fetchOffers();
      }
      await checkSubscription();
    } catch (e, st) {
      log("", error: e, stackTrace: st);
    }
  }

  @override
  void onInit() {
    timer = Timer.periodic(Duration(minutes: 1), (val) {
      checkSubscription();
    });
    // TODO: implement onInit
    super.onInit();
  }
}
