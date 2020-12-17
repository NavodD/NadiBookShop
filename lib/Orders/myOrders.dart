import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .snapshots(),
            builder: (c, snapShot) {
              return snapShot.hasData
                  ? ListView.builder(
                      itemCount: snapShot.data.documents.length,
                      itemBuilder: (c, index) {
                        return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection('items')
                              .where('shortInfo',
                                  whereIn: snapShot.data.documents[index]
                                      .data[EcommerceApp.productID])
                              .getDocuments(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? OrderCard(
                                    itemCount: snap.data.documents.length,
                                    data: snap.data.documents,
                                    orderId: snapShot
                                        .data.documents[index].documentID,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        );
                      },
                    )
                  : Center(
                      child: circularProgress(),
                    );
            }),
      ),
    );
  }
}
