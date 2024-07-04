import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../Api.dart';
import 'package:http/http.dart' as http;
import '../../../Utils.dart';




class dropdown_Payeur extends StatefulWidget {

  TextEditingController PayeurController;

  dropdown_Payeur({Key? key, required this.PayeurController})
      : super(key: key);
  @override
  dropdown_PayeurState createState() =>dropdown_PayeurState();
}

class dropdown_PayeurState extends State<dropdown_Payeur> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPayeur();
  }

  bool visibile_Payeur =false;

  var List_Payeur = [];
  var dropdown_Payeur ;

  Future getAllPayeur() async {
    var baseUrl = BaseUrl.CA_getPayeur;

    http.Response response = await http.get(Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
    );
    print("Payeur response : ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        List_Payeur = jsonData;
        //print(SousTypeCLItemlist);
      });
    }
  }

  Widget _buildPayeur() {
    return Container(
      height: 55,
      // decoration: BoxDecoration(
      //     //color: Colors.yellow[100],
      //     border:Border.all(color: Colors.grey,width: 1),
      //     borderRadius: BorderRadius.circular(5)
      // ),
      child: DropdownButtonFormField(

        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value == null ? 'champs obligatoire' : null,
        // hint: Text('choisir type'),
        decoration:  InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)

        ),
           // border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_Payeur.map((item) {
          return DropdownMenuItem(

            value: item['TIERSR3'].toString(),
            child: Text(item['NOM'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_Payeur = newVal;
            widget.PayeurController.text = newVal.toString();
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

