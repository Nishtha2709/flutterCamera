import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

void main() => runApp(DemoPageState());

class DemoPageState extends StatefulWidget {
  @override
  _DemoPageStateState createState() => _DemoPageStateState();
}

class _DemoPageStateState extends State<DemoPageState> {
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();

  Future choiceImage()async{
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
  }
  Future uploadImage()async{
    final uri=Uri.parse("");
    var request= http.MultipartRequest('POST',uri);
    request.fields['name']= nameController.text;
    var pic =await http.MultipartFile.fromPath("image",_image.path);
    request.files.add(pic);
    var response= await request.send();

    if(response.statusCode == 200){
      print("Image uploaded");
    }else{
      print('Image not uploaded'); 

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(


      appBar: AppBar(
        title: Text(
          'Upload Image',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            IconButton(icon: Icon(Icons.camera), onPressed: () {
              choiceImage();
            }),
            Container(
              child: _image == null ? Text('No Image Selected'): Image.file(_image),
            ),
            SizedBox(height: 10),
            RaisedButton(
              child: Text('Upload Image'),
                onPressed: (){
                uploadImage();
                })
          ],
        ),
      ),
      ),
    );
  }
}
