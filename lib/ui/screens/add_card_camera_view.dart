import 'package:bettermint/business_logic/providers/add_card_camera_provider.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class AddCardCameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Scanner'),
      ),
      body: BaseView<AddCardCameraProvider>(
        onModelReady: (model) async => await model.initCamera(),
        onModelDispose: (model) => model.disposeCamera(),
        builder: (context, model, child) => model
                .getCameraController()
                .value
                .isInitialized
            ? Stack(
                children: [
                  CameraPreview(model.getCameraController()),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        child: Icon(Icons.photo_camera),
                        onPressed: () async => await model.takePicture(context),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
