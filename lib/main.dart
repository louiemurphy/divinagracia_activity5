import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        _pickImage(source);
      } else {
        print("Permission to access storage was denied.");
      }
    } else if (status == PermissionStatus.granted) {
      _pickImage(source);
    } else {
      print("Permission to access storage was denied.");
    }
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("Messenger"),
              backgroundColor: Colors.indigoAccent.shade400,
              centerTitle: true,
              elevation: 0.0,
            ),
            backgroundColor: Colors.indigo[50],
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null
                            ? Container()
                            : Image.file(_image!, height: 300, width: 300),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.photo_library,
                              color: Colors.indigoAccent.shade700,
                              size: 25,
                            ),
                            onPressed: () => _getImage(ImageSource.gallery),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.indigoAccent.shade700,
                              size: 25,
                            ),
                            onPressed: () => _getImage(ImageSource.camera),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.mic,
                              color: Colors.indigoAccent.shade700,
                              size: 25,
                            ),
                            onPressed: () {
                              //on press mic logic
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Message",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.stop,
                              color: Colors.transparent,
                              size: 25,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
         )
      );
    }
  }
