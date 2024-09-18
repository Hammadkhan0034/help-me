import 'package:get/get.dart';

class DoorController extends GetxController {
  final items = ['Indoor', 'Outdoor'].obs;
  var selectedItem = 'Indoor'.obs;

  void setSelected(String value) {
    selectedItem.value = value;
  }
}
