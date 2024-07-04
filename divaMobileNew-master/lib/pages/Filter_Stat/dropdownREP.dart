import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../Utils.dart';

import 'package:http/http.dart' as http;



class dropdown_REP extends StatefulWidget {

  final TextEditingController REPController;

  const dropdown_REP({Key? key, required this.REPController})
      : super(key: key);
  @override
  dropdown_REPState createState() =>dropdown_REPState();
}

class dropdown_REPState extends State<dropdown_REP> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllREP();
  }

  bool visibile_REP =false;

  var List_REP = [];
  var dropdown_REP ;

  Future getAllREP() async {

    String myUrl = BaseUrl.get_Representant;
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
          List_REP = jsonData;
          //print(SousTypeCLItemlist);
        });
      }
    });

  }

  Widget _buildREP() {
    return Container(

      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 35.h,
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
                items: List_REP.map((item) {
                  return DropdownMenuItem(

                    value: item['TIERS'].toString(),
                    child: Text(item['NOM'].toString(),overflow: TextOverflow.visible,maxLines: 2,),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    dropdown_REP = newVal;
                    widget.REPController.text = newVal.toString();
                  });
                },
                value: dropdown_REP,
              ),
            ),
          ),

          Expanded(
              flex: 1,
              child: Visibility(visible: visibile_REP,child: IconButton(onPressed: (){
                setState(() {
                  widget.REPController.clear();

                  visibile_REP = false;
                });
              },
                icon: const Icon(Icons.delete_outline),color: Colors.grey,),)
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return _buildREP();

  }
}

