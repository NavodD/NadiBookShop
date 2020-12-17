import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _cpasswordEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _imageUrl = '';
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    //double _deviceheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _deviceWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: _deviceWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameEditingController,
                    hintText: 'Name',
                    data: Icons.person,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailEditingController,
                    hintText: 'Email',
                    data: Icons.email,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordEditingController,
                    hintText: 'Password',
                    data: Icons.lock,
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordEditingController,
                    hintText: 'Confirm Password',
                    data: Icons.lock,
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _uploadAndSaveImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                width: _deviceWidth * 0.5,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              color: Colors.blue,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4,
              width: _deviceWidth * 0.8,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Future _selectAndPickImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = image;
    });
  }

  saveToTheStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registering please wait....',
          );
        });

    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      _imageUrl = urlImage;
      _register();
    });
  }

  Future<void> _uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'Please select an image.',
            );
          });
    } else {
      _passwordEditingController.text == _cpasswordEditingController.text
          ? _nameEditingController.text.isNotEmpty &&
                  _emailEditingController.text.isNotEmpty &&
                  _passwordEditingController.text.isNotEmpty &&
                  _cpasswordEditingController.text.isNotEmpty
              ? saveToTheStorage()
              : showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(
                      message: 'Fill all the fields',
                    );
                  })
          : showDialog(
              context: context,
              builder: (c) {
                return ErrorAlertDialog(
                  message: 'Password does not match',
                );
              });
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _register() async {
    FirebaseUser firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: e.messege.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection('users').document(fUser.uid).setData({
      'uid': fUser.uid,
      'email': fUser.email,
      'name': _nameEditingController.text.trim(),
      'url': _imageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString('uid', fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, _imageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
