import 'package:flutter/material.dart';



class dropdown_Etat extends StatefulWidget {

  TextEditingController EtatController;

  dropdown_Etat({Key? key, required this.EtatController})
      : super(key: key);
  @override
  dropdown_EtatState createState() =>dropdown_EtatState();
}

class dropdown_EtatState extends State<dropdown_Etat> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  if (widget.EtatController.text != ""){ dropdown_Etat =widget.EtatController.text ; visibile_Etat = true;}
  }

  bool visibile_Etat =false;

  var List_Etat = [

    {'CE4': '1', 'Etat': "actif"},
    {'CE4': '2', 'Etat': "suspendu"},
    {'CE4': '4', 'Etat': "modèle"},
    {'CE4': '6', 'Etat': "attente"},
    {'CE4': '7', 'Etat': "préparé"},
    {'CE4': '8', 'Etat': "périmé"},
    {'CE4': '9', 'Etat': "transféré"},
    {'CE4': 'A', 'Etat': "archivé"},
  ];
  var dropdown_Etat ;



  Widget _buildEtat() {
    return Container(
      height: 50,
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
        items: List_Etat.map((item) {
          return DropdownMenuItem(

            value: item['CE4'].toString(),
            child: Text(item['Etat'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_Etat = newVal;
            widget.EtatController.text = newVal.toString();
            visibile_Etat = true;
          });
        },
        value: dropdown_Etat,
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
            widget.EtatController.clear();
            dropdown_Etat =null;
            setState(() {
              visibile_Etat = false;
            });

          },
            icon: const Icon(Icons.delete_outline),),visible: visibile_Etat,))
    ]);

  }


}

