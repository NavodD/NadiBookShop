import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(80),
                  ),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(top: 1),
            child: Column(
              children: [
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => StoreHome(),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'My Orders',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => MyOrders(),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'My Cart',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => CartPage(),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Search',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => SearchProduct(),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Add new Address',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => AddAddress(),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((c) {
                      Route route = MaterialPageRoute(
                        builder: (c) => AuthenticScreen(),
                      );
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 2,
                  color: Colors.blueAccent,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
