import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/group/controller/create_group_controller.dart';
import 'package:get/get.dart';

import '../../../core/supabase/groups_crud.dart';
import '../../../models/group_model.dart';

class DoorController extends GetxController {
  final groupController=Get.put(CreateGroupController());
  final authController=Get.find<AuthController>();
  final items = ['Indoor', 'Outdoor'].obs;
  var selectedType = 'Indoor'.obs;
RxString localImagePath=''.obs;
  var selectedGroup = Rxn<GroupModel>();
  final groups = <GroupModel>[].obs;
  void setSelected(String value) {
    selectedType.value = value;
    selectedGroup.value = null;
    loadGroups();
  }
  Future<void> loadGroups() async {
    final fetchedGroups = await GroupCrud.fetchGroupsByType(selectedType.value,authController.userModel.value.id );
    groups.assignAll(fetchedGroups);
    print('Loaded groups: $groups');


  }
@override
  void onInit() {
  loadGroups();
    // TODO: implement onInit
    super.onInit();
  }
}
