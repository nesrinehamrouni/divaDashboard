
import 'dart:convert';
import 'dart:io';

import '../../constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Api.dart';
import '../../My_globals.dart';
import '../../Utils.dart';

class Choix_DOS_ETB extends StatefulWidget {
  const Choix_DOS_ETB({Key? key}) : super(key: key);

  @override
  State<Choix_DOS_ETB> createState() => _Choix_DOS_ETBState();
}

class _Choix_DOS_ETBState extends State<Choix_DOS_ETB> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllDOS();

  }

  TextEditingController DOSController = TextEditingController();

  var List_DOS = [];
  var List_ETB = [];

  var dropdown_DOS ;
  var dropdown_ETB ;

  Future getAllDOS() async {
    var baseUrl = BaseUrl.get_DOS;

    http.Response response = await http.get(Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
    );
    print("DOS response : ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        List_DOS = jsonData;
        dropdown_DOS = List_DOS[0]["DOS"];
        Global.set_DOS(dropdown_DOS);
        getETB(dropdown_DOS);
        //print(SousTypeCLItemlist);
      });
    }
  }

  Widget _buildDOS() {
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
        items: List_DOS.map((item) {
          return DropdownMenuItem(

            value: item['DOS'].toString(),
            child: Text(item['NOM'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_DOS = newVal;
           DOSController.text = newVal.toString();
            Global.set_DOS(dropdown_DOS);
           getETB(dropdown_DOS);
          });
        },
        value: dropdown_DOS,
      ),
    );
  }



  /*************************************** ETB ***************************************************/

  Future<void> getETB(String DOS) async {


    String myUrl = BaseUrl.get_ETB;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "DOS":DOS,


        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        var jsonData = json.decode(response.body);
        setState(() {
          List_ETB = jsonData;
          dropdown_ETB = List_ETB[0]["ETB"];
          Global.set_ETB(dropdown_ETB);
          //print(SousTypeCLItemlist);
        });
      }
    });
  }


  Widget _buildETB() {
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
        decoration:  InputDecoration(
            isDense: true,
            border:InputBorder.none ,
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8)
        ),
        items: List_ETB.map((item) {
          return DropdownMenuItem(

            value: item['ETB'].toString(),
            child: Text(item['NOM'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_ETB = newVal;
            Global.set_ETB(dropdown_ETB);
          });
        },
        value: dropdown_ETB,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Align(alignment : Alignment.centerLeft,child: Text("Dossier :",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)),
      _buildDOS(),
      SizedBox(height: 10,),
      Align(alignment : Alignment.centerLeft,child: Text("Etablissement :",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)),
      _buildETB(),
    ],);
  }
}
