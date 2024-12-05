
import 'package:get/get.dart';






class PaymentController extends GetxController {
  // Observable variables to control plan visibility
  RxBool showBasicPlan = false.obs;
  RxBool showDailyPlan = false.obs;
  RxBool showMonthlyPlan = false.obs;
  RxBool showYearlyPlan = false.obs;

  // late Map<String, dynamic> paymentIntentData; // Ensures non-null intent data
  //
  // // Method to initiate payment process
  // Future<void> makePayment(String amount) async {
  //   try {
  //     paymentIntentData = await createPaymentIntent(amount, 'MYR');
  //
  //     await Stripe.instance.initPaymentSheet(
  //
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentData['client_secret'],
  //         applePay: PaymentSheetApplePay(merchantCountryCode: "MY"),
  //         googlePay: const PaymentSheetGooglePay(
  //           label: 'Yearly Subscription',
  //
  //           // testEnv: true,
  //           currencyCode: "MYR",
  //           merchantCountryCode: "MY",
  //         ),
  //         merchantDisplayName: "HELP ME",
  //         // setupIntentClientSecret:
  //       ),
  //
  //     );
  //     await displayPaymentSheet();
  //   } catch (e) {
  //     debugPrint('Payment Error: $e');
  //     Get.snackbar('Payment Failed', 'An error occurred. Please try again.');
  //   }
  // }
  //
  // // Method to present the payment sheet
  // Future<void> displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet(); // Show the payment UI
  //     paymentIntentData = {}; // Reset after success
  //     update();
  //     Get.snackbar('Payment Success', 'Your payment was successful!');
  //   } on StripeException catch (e) {
  //     debugPrint('StripeException: $e');
  //     Get.snackbar('Payment Failed', 'An error occurred. Please try again.');
  //   } catch (e) {
  //     // Handle any other generic exceptions
  //     debugPrint('Exception: $e');
  //     Get.snackbar('Payment Error', 'Unexpected error occurred.');
  //   }
  // }
  //
  // // Method to create a payment intent on Stripe's server
  // Future<Map<String, dynamic>> createPaymentIntent(
  //     String amount, String currency) async {
  //   try {
  //     // Prepare the request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       // 'payment_method_types[]': 'card',
  //       'payment_method_types[]': 'fpx',
  //     };
  //
  //     // Make HTTP request to Stripe's API
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       body: body,
  //       headers: {
  //         // 'Authorization': 'Bearer sk_test_51QEvMCBfCAqQpLYDWWycbzKonXvpAOiw9sz0STnBSAny9orPUuKHHbbb3NQCUCdnV3vE5Wm9KDn5fNHI1K5gorlN001z4uH7X3',
  //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_TEST']}',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //     );
  //     debugPrint(response.body);
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     debugPrint('Payment Intent Error: $e');
  //     rethrow; // Propagate the error to the calling method
  //   }
  // }
  //
  // // Utility to calculate amount in the smallest currency unit (cents)
  // String calculateAmount(String amount) {
  //   final price = (double.parse(amount) * 100).toInt(); // Handle decimals safely
  //   return price.toString();
  // }
}
