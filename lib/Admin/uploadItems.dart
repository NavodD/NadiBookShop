import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController shortTitleEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayUploadScreenForm();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.border_color),
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (c) => AdminShiftOrders(),
              );
              Navigator.pushReplacement(context, route);
            }),
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (c) => SplashScreen(),
              );
              Navigator.pushReplacement(context, route);
            },
            child: Text('Log Out'),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shop_two,
                size: 200,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onPressed: () {
                    takeImage(context);
                  },
                  child: Text(
                    'Add new item',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              'Item Image',
            ),
            children: [
              SimpleDialogOption(
                child: Text('Capture with camera'),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text('Capture with gallery'),
                onPressed: getImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    setState(() {
      file = imageFile;
    });
  }

  getImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      file = imageFile;
    });
  }

  displayUploadScreenForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: clearForm),
        title: Text(
          'New Product',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.blueAccent),
                controller: shortTitleEditingController,
                decoration: InputDecoration(
                  hintText: 'Short info',
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.blueAccent),
                controller: titleEditingController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.blueAccent),
                controller: descriptionEditingController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent,
          ),
          ListTile(
            leading: Icon(
              Icons.monetization_on,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.blueAccent),
                controller: priceEditingController,
                decoration: InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  clearForm() {
    setState(() {
      file = null;
      descriptionEditingController.clear();
      titleEditingController.clear();
      shortTitleEditingController.clear();
      priceEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Items');
    StorageUploadTask uploadTask =
        storageReference.child('product_$productId.jpg').putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection('items');
    itemsRef.document(productId).setData({
      'shortInfo': shortTitleEditingController.text.trim(),
      'publishedDate': DateTime.now(),
      'longDescription': descriptionEditingController.text.trim(),
      'status': 'Available',
      'thumbnailUrl': downloadUrl,
      'title': titleEditingController.text.trim(),
      'price': int.parse(
        priceEditingController.text,
      ),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      descriptionEditingController.clear();
      titleEditingController.clear();
      priceEditingController.clear();
      shortTitleEditingController.clear();
    });
  }
}
