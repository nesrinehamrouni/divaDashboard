import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Api.dart';
import 'package:http/http.dart' as http;

import '../Utils.dart';



class dropdown_TIERS extends StatefulWidget {

  final TextEditingController TIERSController;

  const dropdown_TIERS({Key? key, required this.TIERSController})
      : super(key: key);
  @override
  dropdown_TIERSState createState() =>dropdown_TIERSState();
}

class dropdown_TIERSState extends State<dropdown_TIERS> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTiers();
  }

  bool visibile_Tiers =false;

  List<String> dataTiers = [];

  Future getTiers() async {
    var baseUrl = BaseUrl.getTiers;

    http.Response response = await http.get(
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
      Uri.parse(baseUrl),
    );
    print('Response status : ${response.statusCode}');
    print('Response body : ${response.body}');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      final data = jsonData;
      setState(() {
        data.forEach((api) {

          dataTiers.add(api['TIERS'].toString().trimRight(),);
        });
      });
    }
  }



  @override
  Widget build(BuildContext context)  {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 5),
      height: 40.h,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child:  DropdownSearch<String>(
              onChanged: itemSelectionChanged,
              selectedItem:widget.TIERSController.text ,
              items:dataTiers,

              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  border:OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  hintText: "TIERS",
                 // labelText: 'TIERS',
                ),
              ),
              popupProps: const PopupProps.menu(

                title: Text('Choisir client',style: TextStyle(fontWeight: FontWeight.bold),),
                showSearchBox: true,

                fit: FlexFit.loose,
                //comment this if you want that the items do not takes all available height
                constraints: BoxConstraints.tightFor(),
              ),
            ),


          ),
          Expanded(
              flex: 1,
              child: Visibility(visible: visibile_Tiers,child: IconButton(onPressed: (){
                setState(() {
                  widget.TIERSController.clear();

                  visibile_Tiers = false;
                });
              },
                icon: const Icon(Icons.delete_outline),color: Colors.grey,),))
        ],
      ),
    );




  }

  void itemSelectionChanged(String? s) {
    setState(() {
      widget.TIERSController.text = s! ;
      print(widget.TIERSController.text);


      visibile_Tiers = true;

    });

  }
}

