import '../../My_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class dropdown_choixRetour extends StatefulWidget {

  TextEditingController choixRetourController;

  dropdown_choixRetour({Key? key, required this.choixRetourController})
      : super(key: key);
  @override
  dropdown_choixRetourState createState() =>dropdown_choixRetourState();
}

class dropdown_choixRetourState extends State<dropdown_choixRetour> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     dropdown_choix = "Article";
  }

  bool visibile_choix =false;

  var List_Etat = [

    "Article",
    "Représentant",

  ];
  var dropdown_choix ;



  Widget _buildEtat() {
    return Container(
      height:35.h,
      decoration: BoxDecoration(
        //color: Colors.yellow[100],
          border:Border.all(color: Colors.grey,width: 1),
          borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownButtonFormField(

        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value == null ? 'champs obligatoire' : null,
        // hint: Text('choisir type'),
        decoration:  InputDecoration(
            isDense: true,
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_Etat.map((item) {
          return DropdownMenuItem(

            value: item,
            child: Text(item,overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_choix = newVal;
            widget.choixRetourController.text = newVal.toString();
           // visibile_choix = true;
            Global.set_isRetourRep(dropdown_choix);
          });
        },
        value: dropdown_choix,
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return Row(children: [
      Expanded(flex:4,child: _buildEtat()),
      Expanded(
          flex: 1,
          child: Visibility(child: IconButton(onPressed: (){
            widget.choixRetourController.clear();
            dropdown_choix =null;
            setState(() {
             // visibile_choix = false;
            });

          },
            icon: const Icon(Icons.delete_outline),),visible: visibile_choix,))
    ]);

  }


}

