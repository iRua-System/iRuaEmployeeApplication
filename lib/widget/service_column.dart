import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceColumn extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final String? price;
  final Icon? icon;
  final Function? onPressedIcon;
  ServiceColumn(
      {this.price, this.title, this.onTap, this.icon, this.onPressedIcon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 4),
                  blurRadius: 7,
                )
              ]),
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250,
                child: Text(
                  title!,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Spacer(),
              Text(
                "\$" + MoneyFormat.formatMoney(price!.split(".")[0]),
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Spacer(),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class MoneyFormat {
  static String formatMoney(String money) {
    final formatter = new NumberFormat("#,###");
    int temp = num.tryParse(money)!.toInt();
    String alo = formatter.format(temp).toString();
    return alo;
  }
}
