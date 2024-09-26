import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class MyFirebaseStorage{

  static Future<String?> uploadImage(File image) async {
    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}${path.basename(image.path)}';
      Reference ref =   FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadURL');

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}