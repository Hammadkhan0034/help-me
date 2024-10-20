import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MySupabaseStorage{

  // static Future<String?> uploadImage(File image) async {
  //   try {
  //     String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}${path.basename(image.path)}';
  //     Reference ref =   FirebaseStorage.instance.ref().child(fileName);
  //     UploadTask uploadTask = ref.putFile(image);
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadURL = await snapshot.ref.getDownloadURL();
  //     print('Image uploaded successfully. Download URL: $downloadURL');
  //
  //     return downloadURL;
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }
static   SupabaseClient supabaseClient=Supabase.instance.client;
  static Future<String?> uploadImage(File imageFile) async {
     // Get the file name from the file path using basename
     final fileName = basename(imageFile.path);

     // Upload the image file to the 'images' storage bucket
     final response = await supabaseClient.storage
         .from('images')
         .upload('public/$fileName', imageFile);

     if (response.isEmpty) {
       print('Error uploading image: ${response}');
       return null;
     }

     // Get the public URL for the uploaded image
     final String imageUrl = supabaseClient.storage
         .from('images')
         .getPublicUrl('public/$fileName');

     return imageUrl;
   }
}