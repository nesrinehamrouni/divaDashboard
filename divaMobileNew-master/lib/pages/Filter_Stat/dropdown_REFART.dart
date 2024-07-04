import 'dart:convert';
import 'dart:io';
import 'package:divamobile/Api.dart';
import 'package:divamobile/My_globals.dart';
import 'package:divamobile/Utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;





class dropdown_REFART extends StatefulWidget {

  final TextEditingController RefARTController;

  const dropdown_REFART({Key? key, required this.RefARTController})
      : super(key: key);
  @override
  dropdown_REFARTState createState() =>dropdown_REFARTState();
}

class dropdown_REFARTState extends State<dropdown_REFART> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRefART();
  }

  bool visibile_RefART =false;

  List<String> dataRefART = [];

  Future getRefART() async {
    String myUrl = BaseUrl.get_REFART;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {


          "DOS":     Global.getDOS(),


        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        var jsonData = json.decode(response.body);
      final data = jsonData;
      setState(() {
        data.forEach((api) {

          dataRefART.add(api['REF'].toString().trimRight(),);
        });
      });
    }
  });
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
              selectedItem:widget.RefARTController.text ,
              items:dataRefART,

              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  border:OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  hintText: "RefART",
                  // labelText: 'RefART',
                ),
              ),
              popupProps: const PopupProps.menu(

                title: Text('Choisir reférence',style: TextStyle(fontWeight: FontWeight.bold),),
                showSearchBox: true,

                fit: FlexFit.loose,
                //comment this if you want that the items do not takes all available height
                constraints: BoxConstraints.tightFor(),
              ),
            ),


          ),
          Expanded(
              flex: 1,
              child: Visibility(visible: visibile_RefART,child: IconButton(onPressed: (){
                setState(() {
                  widget.RefARTController.clear();

                  visibile_RefART = false;
                });
              },
                icon: const Icon(Icons.delete_outline),color: Colors.grey,),))
        ],
      ),
    );




  }

  void itemSelectionChanged(String? s) {
    setState(() {
      widget.RefARTController.text = s! ;
      print(widget.RefARTController.text);


      visibile_RefART = true;

    });

  }
}

