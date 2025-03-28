import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/main.dart';
import 'package:bettermint/ui/screens/add_card_view.dart';
import 'package:bettermint/ui/utils/picture_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AddCardCameraProvider extends BaseProvider {
  CameraController _controller;
  PictureHandler _pictureHandler;

  initCamera() async {
    setState(ViewState.BUSY);
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    _controller.initialize().then(
      (_) {
        setState(ViewState.IDLE);
      },
    );
    _pictureHandler = PictureHandler(controller: _controller);
  }

  takePicture(BuildContext context) async {
    await _pictureHandler.takePicture().then(
      (String path) {
        if (path != null) {
          print("Photo taken");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCardView(imagePath: path)));
        }
      },
    );
  }

  getCameraController() {
    return _controller;
  }

  getPictureHandler() {
    return _pictureHandler;
  }

  disposeCamera() {
    _controller.dispose();
  }
}
