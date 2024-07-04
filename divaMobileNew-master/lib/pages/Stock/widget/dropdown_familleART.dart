import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../Api.dart';
import 'package:http/http.dart' as http;

import '../../../Utils.dart';




class dropdown_FamART extends StatefulWidget {

  TextEditingController FamARTController;

  dropdown_FamART({Key? key, required this.FamARTController})
      : super(key: key);
  @override
  dropdown_FamARTState createState() =>dropdown_FamARTState();
}

class dropdown_FamARTState extends State<dropdown_FamART> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPayeur();
  }

  bool visibile_Payeur =false;

  var List_FAmART = [];
  var dropdown_Payeur ;

  Future getAllPayeur() async {
    var baseUrl = BaseUrl.get_familleART;

    http.Response response = await http.get(Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
    );
   // print("Payeur response : ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        List_FAmART = jsonData;
        //print(SousTypeCLItemlist);
      });
    }
  }

  Widget _buildPayeur() {
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
        validator: (value) => value == null ? 'champs obligatoire' : null,
        // hint: Text('choisir type'),
        decoration:  InputDecoration(
            isDense: true,
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_FAmART.map((item) {
          return DropdownMenuItem(

            value: item['CODE_TYP'].toString(),
            child: Text(item['DES'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_Payeur = newVal;
            widget.FamARTController.text = newVal.toString();
          });
        },
        value: dropdown_Payeur,
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return _buildPayeur();

  }


}

