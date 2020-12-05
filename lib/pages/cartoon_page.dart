import 'dart:typed_data';

import 'package:cartoongan/services/file_picker_service.dart';
import 'package:cartoongan/services/ml_service.dart';
import 'package:flutter/material.dart';

class CartoonPage extends StatefulWidget {
  @override
  _CartoonPageState createState() => _CartoonPageState();
}

class _CartoonPageState extends State<CartoonPage> {
  MLService _mlService = MLService();
  FilePickerService _filePickerService = FilePickerService();

  Uint8List defaultImage;
  Uint8List cartoonImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CartoonGAN'),
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: selectImage,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoadingImage(defaultImage),
            Icon(
              Icons.keyboard_arrow_down,
              size: 50,
            ),
            LoadingImage(cartoonImage),
          ],
        ),
      ),
    );
  }

  Widget LoadingImage(Uint8List imageData) {
    if (imageData == null) {
      return Center(
        child: Container(
          child: Text(
            'No Image',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    } else if (imageData.length == 0) {
      return Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 5,
            ),
            Text('Loading'),
          ],
        ),
      );
    } else {
      return Image.memory(
        imageData,
        fit: BoxFit.fitWidth,
      );
    }
  }

  void selectImage() async {
    setState(() {
      defaultImage = Uint8List(0);
      cartoonImage = Uint8List(0);
    });

    var imageData = await _filePickerService.imageFilePickAsBytes();

    if (imageData != null) {
      setState(() {
        defaultImage = imageData;
      });

      var cartoonImageData = await _mlService.convertCartoonImage(imageData);

      setState(() {
        if (cartoonImageData == null) {
          cartoonImage = null;
        } else {
          cartoonImage = cartoonImageData;
        }
      });
    } else {
      setState(() {
        defaultImage = null;
        cartoonImage = null;
      });
    }
  }
}
