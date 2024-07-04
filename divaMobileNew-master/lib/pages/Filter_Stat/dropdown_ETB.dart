import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class dropdown_ETB extends StatefulWidget {

  TextEditingController ETBController;

  dropdown_ETB({Key? key, required this.ETBController})
      : super(key: key);
  @override
  dropdown_ETBState createState() =>dropdown_ETBState();
}

class dropdown_ETBState extends State<dropdown_ETB> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  if (widget.ETBController.text != ""){ dropdown_ETB =widget.ETBController.text ; visibile_ETB = true;}
  }

  bool visibile_ETB =false;

  var List_Etat = [

   "PLAST",
   "MEUBLE",

  ];
  var dropdown_ETB ;



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
            dropdown_ETB = newVal;
            widget.ETBController.text = newVal.toString();
            visibile_ETB = true;
          });
        },
        value: dropdown_ETB,
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
            widget.ETBController.clear();
            dropdown_ETB =null;
            setState(() {
              visibile_ETB = false;
            });

          },
            icon: const Icon(Icons.delete_outline),),visible: visibile_ETB,))
    ]);

  }


}

