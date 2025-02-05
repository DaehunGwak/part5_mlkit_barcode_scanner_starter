import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class GalleryView extends StatefulWidget {
  GalleryView({
    Key? key,
    required this.title,
    this.text,
    required this.onImage,
    required this.onDetectorViewModeChanged,
  }) : super(key: key);

  final String title;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: widget.onDetectorViewModeChanged,
            icon: Icon(
              Icons.camera,
            ),
          )
        ],
      ),
      body: _galleryBody(),
    );
  }

  Widget _galleryBody() {
    return ListView(
      shrinkWrap: true,
      children: [
        _image != null
            ? SizedBox(
                width: 400,
                height: 400,
                child: Image.file(_image!),
              )
            : Center(
                child: Container(
                  width: 240,
                  height: 240,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Text('바코드를 불러와주세요'),
                ),
              ),
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _getImage(ImageSource.gallery),
            child: Text('갤러리 이미지 가져오기'),
          ),
        ),
        if (_image != null) Text(widget.text ?? 'null'),
      ],
    );
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
    });
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }
}
