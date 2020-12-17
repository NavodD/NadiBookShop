import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Colors.blueAccent,
      flexibleSpace: Container(
        child: SizedBox(
          height: 5,
        ),
      ),
      title: Text(
        'Nadi-BookShop',
        style: TextStyle(fontSize: 24),
      ),
      centerTitle: true,
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(
                    builder: (c) => CartPage(),
                  );
                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
              child: Stack(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.brightness_1,
                    color: Colors.white,
                    size: 20,
                  ),
                  Positioned(
                    top: 2,
                    bottom: 3,
                    left: 5,
                    child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                      return Text(
                        (EcommerceApp.sharedPreferences
                                    .getStringList(EcommerceApp.userCartList)
                                    .length -
                                1)
                            .toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
