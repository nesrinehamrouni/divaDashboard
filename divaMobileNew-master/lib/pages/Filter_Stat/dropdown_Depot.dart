import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../Api.dart';
import 'package:http/http.dart' as http;
import '../../../Utils.dart';
import '../../My_globals.dart';




class dropdown_Depot extends StatefulWidget {

  TextEditingController DepotController;

  dropdown_Depot({Key? key, required this.DepotController})
      : super(key: key);
  @override
  dropdown_DepotState createState() =>dropdown_DepotState();
}

class dropdown_DepotState extends State<dropdown_Depot> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDepot();
  }

  bool visibile_Depot =false;

  var List_Depot = [];
  var dropdown_Depot ;

  Future getAllDepot() async {

    String myUrl = BaseUrl.get_DEPO;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {


          "DOS":Global.getDOS(),


        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          List_Depot = jsonData;
          //print(SousTypeCLItemlist);
        });
      }
    });

  }

  Widget _buildDepot() {
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
        items: List_Depot.map((item) {
          return DropdownMenuItem(

            value: item['DEPO'].toString(),
            child: Text(item['LIB'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            dropdown_Depot = newVal;
            widget.DepotController.text = newVal.toString();
          });
        },
        value: dropdown_Depot,
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return _buildDepot();

  }


}

