// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Nadi-BookShop',
            style: TextStyle(fontSize: 29),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIdEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _deviceheight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          children: [
            Container(
              height: _deviceheight * 0.35,
              width: _deviceWidth,
              child: Image.asset('images/login.jpg'),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Admin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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
                    controller: _adminIdEditingController,
                    hintText: 'Admin Id',
                    data: Icons.person,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordEditingController,
                    hintText: 'Password',
                    data: Icons.lock,
                    isObsecure: true,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _adminIdEditingController.text.isNotEmpty &&
                              _passwordEditingController.text.isNotEmpty
                          ? loginAdmin()
                          : showDialog(
                              context: context,
                              builder: (c) {
                                return ErrorAlertDialog(
                                  message: 'Enter email and password',
                                );
                              });
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
                        'Log In',
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
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (c) => AuthenticScreen(),
                      );
                      Navigator.pushReplacement(context, route);
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    label: Text('I am not an admin'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection('admins').getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminIdEditingController.text.trim()) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Your id is not valid')));
        } else if (result.data['password'] !=
            _passwordEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Your password is incorrect')));
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Welcome Admin' + result.data['name'])));

          setState(() {
            _adminIdEditingController.text = '';
            _passwordEditingController.text = '';
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
