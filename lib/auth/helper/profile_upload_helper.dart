import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

/// Profile Upload Provider
///
/// **Dependencies** - `image_picker`  `firebase_core`  `firebase_storage`
class ProfileUploader {
  /// Ready Made Picture Widget with one easy line
  static Widget getProfilePicture(BuildContext context, String imageLink,
      {double? radius}) {
    final picture = GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => _profilePictureScreen(imageLink)));
      },
      child: Hero(
        tag: "user-profile",
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageLink),
          backgroundColor: Colors.black12,
          radius: radius ?? 100,
        ),
      ),
    );
    return picture;
  }

  /// Upload user picked file (mime-type/images) to firebase storage.
  ///
  /// Return a download URL if upload task is completed.
  ///
  /// - *filename* is optional parameter.If not provided,it will generate random name.
  /// - *onProgress* is to handle uploading progress.
  ///
  /// ```dart
  /// await ProfileUploader.upload(filename: "myfile", onProgress: (current,total) {});
  /// ```
  static Future<String?> upload(
      {String? filename,
      Function(int current, int total)? onProgress,
      Function(Object e)? onError,
      bool? deleteAlreadyExist
      }) async {
    // pick image
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Filename Generate
        String fileType = _getFileExtension(imageFile.path);
        String generatedFilename =
            "${filename != null && filename.isNotEmpty ? filename : _generateRandomChar(20)}.$fileType";

        // Upload to server
        Reference profileFolderRef =
            FirebaseStorage.instance.ref().child("user-profiles");

        // Check Profile Already Exist
        if (filename != null) {
          profileFolderRef.listAll().then((profileList) async {
            await Future.forEach<Reference>(profileList.items, (element) async {
              if (element.name.contains(filename)) {
                await element.delete();
              }
            });
          });
        }

        Reference profileRef = profileFolderRef.child(generatedFilename);

        UploadTask uploadTask = profileRef.putFile(imageFile);

        // Progress Listen
        if (onProgress != null) {
          uploadTask.snapshotEvents.listen((event) {
            onProgress(event.bytesTransferred, event.totalBytes);
          });
        }

        // Getting URL
        TaskSnapshot storageTaskSnapshot =
            await uploadTask.whenComplete(() => null);
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      if (onError != null) onError(e);
      return null;
    }
    return null;
  }

  // Getting file extension
  static String _getFileExtension(String filePath) {
    return filePath.split(".").last;
  }

  // Generate file name
  static String _generateRandomChar(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          Random().nextInt(chars.length),
        ),
      ),
    );
  }

  // Profile Screen Abstraction
  static Widget _profilePictureScreen(String imageUrl) {
    final screen = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: "user-profile",
          child: Image.network(imageUrl),
        ),
      ),
    );

    return screen;
  }
}
