import 'package:bettermint/business_logic/providers/add_card_provider.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/widgets/found_code_card.dart';
import 'package:bettermint/ui/widgets/missing_code_card.dart';
import 'package:bettermint/ui/widgets/picture_preview.dart';
import 'package:flutter/material.dart';

class AddCardView extends StatelessWidget {
  final String imagePath;

  AddCardView({@required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Scanned Card'),
      ),
      body: BaseView<AddCardProvider>(
        onModelReady: (provider) async => await provider.refresh(imagePath),
        builder: (context, provider, child) => provider.imageSize != null
            ? Stack(
                children: [
                  PicturePreview(imagePath: imagePath, provider: provider),
                  provider.recognizedText == "Loading ..."
                      ? Center(child: CircularProgressIndicator())
                      : provider.recognizedText.isNotEmpty
                          ? FoundCodeCard(provider: provider)
                          : MissingCodeCard()
                ],
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
