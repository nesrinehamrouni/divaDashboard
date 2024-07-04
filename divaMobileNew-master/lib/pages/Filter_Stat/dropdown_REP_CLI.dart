import 'package:flutter/material.dart';



class dropdown_REP_CLI extends StatefulWidget {

  TextEditingController Controller;
  late final ValueChanged<String> update;

  dropdown_REP_CLI({Key? key, required this.Controller,required this.update})
      : super(key: key);

  @override
  dropdown_REP_CLIState createState() =>dropdown_REP_CLIState();
}

class dropdown_REP_CLIState extends State<dropdown_REP_CLI> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.Controller.text != ""){ dropdown_choix =widget.Controller.text ; visibile_choix = true;}
  }

  bool visibile_choix =false;

  var List_choix = [

     "Représentant",
     "Client",


  ];
  var dropdown_choix ;



  Widget _buildChoix() {
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
        decoration:  const InputDecoration(
            isDense: true,
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_choix.map((item) {
          return DropdownMenuItem(

            value: item,
            child: Text(item,overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_choix = newVal;
            widget.Controller.text = newVal.toString();
            widget.update(dropdown_choix);
            visibile_choix = true;
          });
        },
        value: dropdown_choix,
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return Row(children: [
      Expanded(flex:4,child: _buildChoix()),
      Expanded(
          flex: 1,
          child: Visibility(child: IconButton(onPressed: (){
            widget.Controller.clear();
            dropdown_choix =null;
            setState(() {
              visibile_choix = false;
            });

          },
            icon: const Icon(Icons.delete_outline),),visible: visibile_choix,))
    ]);

  }


}

