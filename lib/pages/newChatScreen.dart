import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';


import 'package:kchat/services/file_upload_function.dart';

class NewChatUpload extends StatefulWidget {
  const NewChatUpload({super.key});

  @override
  State<NewChatUpload> createState() => _NewChatUploadState();
}

class _NewChatUploadState extends State<NewChatUpload> {
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;

  void _pickFile(String ext) async {
   FilePickerResult? result = (await FilePicker.platform.pickFiles(allowedExtensions: [ext]));

    if (result != null) {
      print(result.files);
      setState(() {
        _pickedFileBytes = result.files.first.bytes;
        _pickedFileName = result.files.first.name;
      });
    } else {
      // User canceled the picker
    }
  }

  // void _uploadFile() async {
  //   String uploadUrl = 'your_upload_endpoint_url'; // Replace with your server endpoint
  //   await uploadFile(_file, uploadUrl);
  // }
  @override
  Widget build(BuildContext context) {
    bool screenChecker = MediaQuery.of(context).size.shortestSide < 600;
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenChecker ? 2 : 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            childAspectRatio: 1),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                _pickFile('PDF');
              },
              child: Container(
                height: 20,
                width: 20,  
                // height: MediaQuery.of(context).size.height*0.1,
                // width: MediaQuery.of(context).size.height*0.1,
            
                // color: Colors.blue,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: const Color.fromARGB(255, 88, 139, 185), width: 0.7),
                ),
            
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridTile(
                    header: Text(
                    'Upload you ${index} file , file size should be less than 15 mb',
                    style:const  TextStyle(color: Colors.amber),
                  ),
                    child: IconButton(onPressed: () {
                      
                    },icon:const Icon(Icons.upload_file,color: Colors.amber,)),)
                  
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
