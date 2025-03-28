import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PictureHandler {
  CameraController controller;

  PictureHandler({@required this.controller});

  Future<String> takePicture() async {
    //Checking whether the controller is initialized
    if (!controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    //
    // //Formatting Date and Time
    // String dateTime = DateFormat.yMMMd()
    //     .addPattern('-')
    //     .add_Hms()
    //     .format(DateTime.now())
    //     .toString();
    //
    // String formattedDateTime = dateTime.replaceAll(' ', '');
    // print("Formatted: $formattedDateTime");
    //
    // //Retrieving the path for saving an image
    // final Directory appDocDir = await getApplicationDocumentsDirectory();
    // final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    // await Directory(visionDir).create(recursive: true);
    // final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    /* Checking whether the picture is being taken
    *  to prevent execution of the function again
    *  if previous execution has not ended
    */
    if (controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    XFile imagePath;
    try {
      // Captures the image and saves it to the provided path
      imagePath = await controller.takePicture();
      print(imagePath.path);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath.path;
  }
}
