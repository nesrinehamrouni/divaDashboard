import 'dart:convert';
import 'dart:io';
import 'package:divamobile/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/M_RetourART_ligne.dart';
import '../../My_globals.dart';
import '../../Utils.dart';
import '../../colorApp.dart';
import '../../widget/Accroditon_blue.dart';

import 'package:http/http.dart' as http;




class LigneRetourART extends StatefulWidget {
  String REF;
  String DES;
  String Date_debut;
  String Date_Fin;



  LigneRetourART({Key? key, required this.REF,required this.DES,required this.Date_debut,required this.Date_Fin})
      : super(key: key);

  @override
  LigneRetourARTState createState() => LigneRetourARTState();
}

class LigneRetourARTState extends State<LigneRetourART> {
  bool openMenu = false;


  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  // void _update(bool loading) {
  //   setState(() {Global.set_Accrodition_statut(loading);});
  // }



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var loading = false;

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue[800]!;
  }



  List<M_RetourART_ligne> listeLigne =[];
  ///*******************************************************************  get Entete   ****************************************/

  Future<void> getLigne() async {


    listeLigne.clear();

    setState(() {
      loading = true;
    });



    print("${widget.REF} ${widget.Date_debut} ${widget.Date_Fin} ${Global.getisRetourRep()}");

    String myUrl = Global.getisRetourRep() == "Représentant" ? BaseUrl.getRetour_REP_Ligne :BaseUrl.getRetour_ART_Ligne;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "date_debut":widget.Date_debut ,
          "date_fin":  widget.Date_Fin ,
          "article":      widget.REF ,
          "REP" :      widget.REF.toString() ,
          "DOS":Global.getDOS()


        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {


        final data = jsonDecode(response.body) as List<dynamic>;
        listeLigne = data.map((json) => M_RetourART_ligne.fromJson(json)).toList();


        setState(() {
          loading = false;

        });
      }
    });
  }




  /*******************************************************initState******************************************/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    getLigne();

  }


  Widget _buildTextInfo(String txt, String valeur) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              txt,
              style: TextStyle(
                color: AppColors.deepBlue200,
                fontSize: 12.sp,
                //fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                valeur,

                style: TextStyle(

                    color: AppColors.deepBlue200,
                    fontWeight: FontWeight.w500,
                    fontSize: valeur.length>15 ? 11.sp :13.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//backgroundColor: Colors.white,
      body: RefreshIndicator(

        onRefresh: getLigne,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            margin: EdgeInsets.only(left: 5,right: 5),
            child:ListView.builder(
              itemCount: listeLigne.length,

              shrinkWrap: true,
              itemBuilder: (context,index){

                return Accordion_blue(

                    title:  ' N°Client: ${listeLigne[index].TIERS}',


                    content: Column(
                      children: [
                        _buildTextInfo("N°P Retour",listeLigne[index].NUM_PIECE),
                        _buildTextInfo("Date",listeLigne[index].FADT),
                        _buildTextInfo("Intitule Client",listeLigne[index].NOM),
                        _buildTextInfo("Designation article",widget.DES),
                        _buildTextInfo("Quantité",listeLigne[index].QTE1),
                        _buildTextInfo("N°facture",listeLigne[index].NUM_FACT),
                        _buildTextInfo("OP",listeLigne[index].OP),

                        // _buildTextInfo("Unité",listeLigne[index].REFUN),
                      ],)

                );

              },

            ),
          ),
        ),
      ),
    );
  }







}


