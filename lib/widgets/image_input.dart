import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final File? selectedImage;

  const ImageInput(this.onSelectImage, {this.selectedImage, Key? key})
      : super(key: key);

  @override
  State<ImageInput> createState() =>
      // ignore: no_logic_in_create_state
      _ImageInputState(selectedImage: selectedImage);
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _ImageInputState({File? selectedImage}) : _storedImage = selectedImage;

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: source, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    final receivedImageFile = File(imageFile.path);
    setState(() {
      _storedImage = receivedImageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await receivedImageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  Future<void> _selectFromGallery() async {
    _takePicture(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () => _takePicture(ImageSource.camera),
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          ),
          TextButton.icon(
            onPressed: _selectFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Select from Gallery'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: _storedImage != null
            ? Image.file(
                _storedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Text(
                'No Image Taken',
                textAlign: TextAlign.center,
              ),
      ),
    ]);
  }
}
