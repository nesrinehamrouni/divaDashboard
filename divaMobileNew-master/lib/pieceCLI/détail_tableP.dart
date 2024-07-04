
import '../Models/M_PieceCLI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants.dart';
import 'lignePiece.dart';


class Detail_tablePCLI  {


 static showDialog(BuildContext context, M_PieceCLI PieceCLI){
   return showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
       //  title: Center(child: const Text("Détails Piece ",style: TextStyle(color: kPrimaryColor),)),
        content: Container(
          padding: EdgeInsets.fromLTRB(0,10,0,0),
          constraints: BoxConstraints(
              minHeight: 150, minWidth: MediaQuery.of(context).size.width-20, maxHeight: MediaQuery.of(context).size.height-50),
          child: DefaultTabController(
            initialIndex: 1,  //optional, starts from 0, select the tab by default
            length:2,
            child: Scaffold(
              appBar : AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                bottom:TabBar(
                onTap: (int index) {
                  //  print('Tab $index is tapped');
                  // ajouter_qui=index.toString();
                },
                //isScrollable: true,
                indicatorColor: kPrimaryColor,
                labelColor: kPrimaryColor,
                labelStyle: TextStyle(fontSize: 14.5,fontWeight: FontWeight.bold),
                indicatorWeight: 5,
                tabs: const [
                  Tab( text: 'Entete'),
                  Tab(text: "Ligne"),

                ],
              ),
            ),
            body:TabBarView(


                children: [
                  _buildEntete(PieceCLI),
                  LignePiece(PICOD: PieceCLI.PICOD, ENT_PINO: PieceCLI.PINO,ENT_PREFPINO: PieceCLI.PREFPINO,),
                ]
            ),
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


Widget _buildEntete(M_PieceCLI PieceCLI){
  return SingleChildScrollView(
    child: Column(
      children: [
        createCard("Date", PieceCLI.PIDT),
        createCard("Préfixe pièce", PieceCLI.PREFPINO),
        createCard("N°Pièce", PieceCLI.PINO),
        createCard("Etat", PieceCLI.CE4),
        createCard("Statut ", PieceCLI.STATUS),
        createCard("Catégorie ", PieceCLI.CATPICOD),
        createCard("tiers", PieceCLI.TIERS),
        createCard("Nom", PieceCLI.NOM),
        //createCard("N°de pièce du Référence", PieceCLI.CA_TTC!),
        createCard("Référence ", PieceCLI.PIREF),
        createCard("Devis", PieceCLI.DEV),
        createCard("Montant HT", PieceCLI.HTMT),
        createCard("HT Produit", PieceCLI.HTPDTMT),
        createCard("TTC de le piece", PieceCLI.TTCMT),
        createCard("OP", PieceCLI.OP),
        createCard("Commercial 1", PieceCLI.REPR_0001),
      ],
    ),
  );
}

Widget createCard(String label , String value){
  return Card(

    // color: Constants.greyLight,
    // elevation: 3,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(20),
    // ),
    child: Container(
      width: double.infinity,
      height: 45,
      child:Row(
        children: [
        Text(
            label,

            style: TextStyle(color: primaryColor,fontSize: 13.sp),
          ),
Spacer(),
          value.length>15 ? Flexible(
          child: Text(
                  value,
                 maxLines: 2,
                   textAlign: TextAlign.right,
                  style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,
                     fontSize:  value.length>15 ? 12.sp :13.sp
                  ),
                ),
        ):Text(
    value,
    maxLines: 2,
    textAlign: TextAlign.right,
    style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,
    fontSize:  value.length>15 ? 12.sp :13.sp
    ),
  ),
        ],
      )
      //ListTile(
        //leading: Icon(Icons.shopping_basket),
      //   title: Text(
      //     label,
      //
      //     style: TextStyle(color: primaryColor,fontSize: 13.sp),
      //   ),
      //   // subtitle: Text(
      //   //   "18% of Products Sold",
      //   //   style: TextStyle(color: Constants.TextColor),
      //   // ),
      //   trailing:
      //      Text(
      //       value,
      //        textAlign: TextAlign.right,
      //       style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,
      //          fontSize:  value.length>15 ? 12.sp :13.sp
      //       ),
      //     ),
     // ),
    ),
  );
}





