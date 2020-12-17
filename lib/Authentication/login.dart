import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _deviceheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
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
                'Log In to your Account',
                style: TextStyle(
                  fontSize: 20,
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
                  RaisedButton(
                    onPressed: () {
                      _emailEditingController.text.isNotEmpty &&
                              _passwordEditingController.text.isNotEmpty
                          ? loginUser()
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
                        builder: (c) => AdminSignInPage(),
                      );
                      Navigator.pushReplacement(context, route);
                    },
                    icon: Icon(
                      Icons.nature_people,
                      color: Colors.blueAccent,
                    ),
                    label: Text('I am an admin'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Login please wait....',
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailEditingController.text.trim(),
      password: _passwordEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection('users')
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString('uid', dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
