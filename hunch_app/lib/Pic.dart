//Maansi Garg
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUp extends StatefulWidget {
//   final Function(String imageUrl) onFileChanged;
//   ImageUp({
//     required this.onFileChanged,
// });

  @override
  State<ImageUp> createState() => _ImageUpState();
}

class _ImageUpState extends State<ImageUp> {
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if(imageUrl==null)
        Icon(Icons.image, size: 60, color: Theme.of(context).primaryColor),
        TextButton(
          onPressed: () => _selectPhoto(),
          child: Text("Upload Pic"),
        ),
        // if(imageUrl!=null)
        //   InkWell(
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //     onTap: ()=> _selectPhoto(),
        //     child: Text("Upload pic")
        //   ),
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
                leading: Icon(Icons.filter),
                title: Text("Pick a file"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                }),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }
    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }
    file = (await compressImage(file.path, 35)) as CroppedFile?;
    await _uploadFile(file!.path);
  }

  Future<XFile?> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    return result;
  }

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('image')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    setState(() {
      imageUrl = fileUrl;
    });
    // widget.onFileChanged(fileUrl);
  }
}
