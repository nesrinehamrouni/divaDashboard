import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/M_LignePiece.dart';
import '../My_globals.dart';
import '../Utils.dart';
import '../colorApp.dart';
import '../widget/Accroditon_blue.dart';
import '/../Api.dart';
import 'package:http/http.dart' as http;




class LignePiece extends StatefulWidget {
  String PICOD;
  String ENT_PREFPINO;
  String ENT_PINO;



  LignePiece({Key? key, required this.PICOD,required this.ENT_PREFPINO,required this.ENT_PINO})
      : super(key: key);

  @override
  LignePieceState createState() => LignePieceState();
}

class LignePieceState extends State<LignePiece> {
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



  List<M_Ligne_Piece> listeLignePI =[];
  ///*******************************************************************  get Entete   ****************************************/

  Future<void> getLigne() async {


    listeLignePI.clear();

    setState(() {
      loading = true;
    });



print("${widget.PICOD} ${widget.ENT_PREFPINO} ${widget.ENT_PINO}");

    String myUrl = BaseUrl.get_LignePi;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "PICOD":widget.PICOD =="Devis"? "1": widget.PICOD =="Commande"? "2": widget.PICOD =="Bon de livraison"? "3" : "4" ,
          "ENT_PREFPINO":  widget.ENT_PREFPINO ,
          "ENT_PINO":      widget.ENT_PINO ,
          "DOS":          Global.getDOS(),


        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {


        final data = jsonDecode(response.body) as List<dynamic>;
        listeLignePI = data.map((json) => M_Ligne_Piece.fromJson(json)).toList();


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
              alignment: Alignment.centerRight,
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
              itemCount: listeLignePI.length,

              shrinkWrap: true,
              itemBuilder: (context,index){

                return Accordion_blue(

                  title:  ' ${listeLignePI[index].DES}',


                  content: Column(
                    children: [
                      _buildTextInfo("Réference",listeLignePI[index].REF),
                      _buildTextInfo("Nom",listeLignePI[index].DES),
                      _buildTextInfo("Numéro",listeLignePI[index].CDNO),
                      _buildTextInfo("Préfixe",listeLignePI[index].PREFCDNO),
                      _buildTextInfo("Date",listeLignePI[index].CDDT),
                      _buildTextInfo("Ligne",listeLignePI[index].CDLG),
                      _buildTextInfo("Quantité",listeLignePI[index].CDQTE),
                      _buildTextInfo("Montant",listeLignePI[index].MONT),
                      _buildTextInfo("OP",listeLignePI[index].OP),
                      _buildTextInfo("Tarif vente",listeLignePI[index].TACOD),
                      _buildTextInfo("Unité de vente",listeLignePI[index].VENUN),
                     // _buildTextInfo("Unité",listeLignePI[index].REFUN),
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


