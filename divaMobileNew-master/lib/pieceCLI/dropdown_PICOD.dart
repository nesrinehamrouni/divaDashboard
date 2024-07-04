import 'package:flutter/material.dart';



class dropdown_PICOD extends StatefulWidget {

  TextEditingController PICODController;

  dropdown_PICOD({Key? key, required this.PICODController})
      : super(key: key);
  @override
  dropdown_PICODState createState() =>dropdown_PICODState();
}

class dropdown_PICODState extends State<dropdown_PICOD> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.PICODController.text != ""){ dropdown_PICOD =widget.PICODController.text ; visibile_PICOD = true;}
  }

  bool visibile_PICOD =false;

  var List_PICOD = [

    {'PICOD': '1', 'COD': "Devis"},
    {'PICOD': '2', 'COD': "Commande"},
    {'PICOD': '3', 'COD': "Bon de livraison"},
    {'PICOD': '4', 'COD': "Facture"},

  ];
  var dropdown_PICOD ;



  Widget _buildPICOD() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          //color: Colors.yellow[100],
          border:Border.all(color: Colors.grey,width: 1),
          borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownButtonFormField(

        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //validator: (value) => value == null ? 'champs obligatoire' : null,
        // hint: Text('choisir type'),
        decoration:  InputDecoration(
            isDense: true,
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_PICOD.map((item) {
          return DropdownMenuItem(

            value: item['PICOD'].toString(),
            child: Text(item['COD'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_PICOD = newVal;
            widget.PICODController.text = newVal.toString();
            visibile_PICOD = true;
          });
        },
        value: dropdown_PICOD,
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return Row(children: [
      Expanded(flex:4,child: _buildPICOD()),
      Expanded(
          flex: 1,
          child: Visibility(child: IconButton(onPressed: (){
            widget.PICODController.clear();
            dropdown_PICOD =null;
            setState(() {
              visibile_PICOD = false;
            });

          },
            icon: const Icon(Icons.delete_outline),),visible: visibile_PICOD,))
    ]);

  }


}

