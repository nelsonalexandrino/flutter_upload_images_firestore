import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future _uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit profile'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xFF476CFB),
                child: ClipOval(
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: _image != null
                        ? Image.file(_image, fit: BoxFit.fill)
                        : Image.network(
                            'https://pixabay.com/get/57e3d7434253ac14f6d1867dda6d49214b6ac3e456577040772b78d091/woman-1320810_1920.jpg',
                            fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
                onPressed: () {
                  _getImage();
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _uploadPic(context);
        },
        child: Icon(Icons.cloud_upload),
      ),
    );
  }
}
