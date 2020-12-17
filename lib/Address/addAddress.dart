import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNo = TextEditingController();
  final cFlatNo = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Done'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhoneNo.text,
                state: cState.text.trim(),
                city: cCity.text.trim(),
                pincode: cPinCode.text,
                flatNumber: cFlatNo.text,
              ).toJson();

              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().microsecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                Fluttertoast.showToast(msg: 'New address added successfully');
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });

              Route route = MaterialPageRoute(
                builder: (c) => CartPage(),
              );
              Navigator.pushReplacement(context, route);
            }
            print('add adress');
          },
          backgroundColor: Colors.blueAccent,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hint: 'Name',
                        controller: cName,
                      ),
                      MyTextField(
                        hint: 'Phone No',
                        controller: cPhoneNo,
                      ),
                      MyTextField(
                        hint: 'House No',
                        controller: cFlatNo,
                      ),
                      MyTextField(
                        hint: 'Address Line 1',
                        controller: cCity,
                      ),
                      MyTextField(
                        hint: 'Address Line 2',
                        controller: cState,
                      ),
                      MyTextField(
                        hint: 'Postal Code',
                        controller: cPinCode,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({
    Key key,
    this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? 'Field cannot be empty.' : null,
      ),
    );
  }
}
