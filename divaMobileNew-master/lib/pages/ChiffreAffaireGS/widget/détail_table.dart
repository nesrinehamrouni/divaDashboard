
import '../../../Models/M_ChiffreAffaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants.dart';


class Detail_tableCA  {


 static showDialog(BuildContext context, M_ChiffreAffaire C_affaire){
   return showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("détaille chiffre d'affaire grande surface",style: TextStyle(color: Colors.black54),),
        content: Container(
          padding: EdgeInsets.fromLTRB(10,10,10,0),
          height: 375.h,
          width: double.maxFinite,
          child:  SingleChildScrollView(
            child: Column(
              children: [
                createCard("Date", C_affaire.PIDT!),
                createCard("CA Brut", C_affaire.CA_Brut!),
                createCard("CAB+FOD", C_affaire.CAB_FOD!),
                createCard("TxRem", C_affaire.T_Rem!),
                createCard("Mt Rem", C_affaire.MT_Rem!),
                createCard("Net+FOD", C_affaire.NET_FOD!),
                createCard("CA TTC", C_affaire.CA_TTC!),
              ],
            ),
          ),

        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("OK",style: TextStyle(color: Colors.blue),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ],
      ),
    );
 }
}


Widget createCard(String label , String value){
  return Card(
    color: Constants.greyLight,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      width: double.infinity,
      child: ListTile(
        //leading: Icon(Icons.shopping_basket),
        title: Text(
          label,
          style: TextStyle(color: primaryColor,fontSize: 15.sp),
        ),
        // subtitle: Text(
        //   "18% of Products Sold",
        //   style: TextStyle(color: Constants.TextColor),
        // ),
        trailing: Chip(
          label: Text(
            value,
            style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 16.sp),
          ),
        ),
      ),
    ),
  );
}





