import 'package:flutter/material.dart';

class ItemCounter extends StatefulWidget {
  @override
  _ItemCounterState createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: IconButton(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                icon: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (itemCount > 0) {
                    setState(() {
                      itemCount--;
                    });
                  }
                }),
          ),
          SizedBox(
            width: 20,
          ),
          Text(itemCount.toString()),
          SizedBox(
            width: 20,
          ),
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: IconButton(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  itemCount++;
                });
              },
            ),
          ),
          SizedBox(
            width: 45,
          )
        ],
      ),
    );
  }
}
