

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import '../Etat_RetourART/widget/Ligne_tableau.dart';




class Detail_tableRetourART  {


  static showDialog(BuildContext context,String REF, String DES, String Date_debut, String Date_Fin,){
    return showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        //  title: Center(child: const Text("Détails Piece ",style: TextStyle(color: kPrimaryColor),)),
        content: Container(
            constraints: BoxConstraints(
                minHeight: 150, minWidth: MediaQuery.of(context).size.width-2, maxHeight: MediaQuery.of(context).size.height-10),

            child: LigneRetourART(REF: REF,DES:DES,Date_debut:Date_debut,Date_Fin:Date_Fin)
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








