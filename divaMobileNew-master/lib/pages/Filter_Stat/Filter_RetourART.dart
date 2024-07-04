
import '../../pages/Menu/MenuBI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../Etat_RetourART/RetourART.dart';
import '../../constants.dart';
import '../../pieceCLI/InputDate.dart';
import 'dropdown_choixRetour.dart';




class Filter_Retour extends StatefulWidget {
  //late final ValueChanged<bool> update;
  // Filter_CA({required this.update});

  const Filter_Retour({Key? key, }): super(key:key);
  @override
  State<Filter_Retour> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Filter_Retour> {


  var submitTextStyle = GoogleFonts.rubik(
      fontSize: 18.sp,
      letterSpacing: 3,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();



  TextEditingController _DateDebutController = TextEditingController();
  TextEditingController _DateFinController = TextEditingController();
  TextEditingController _ChoixController = TextEditingController();



  var loading = false;
  bool is_selected = false;

  bool is_TiersVisible = false;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _DateDebutController.text =   DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day));
    _DateFinController.text =  DateFormat('yyyy-MM-dd').format(DateTime.now());

  }

  Widget _buildText(String txt){

    return Container(
      margin: EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          txt,
          style:  TextStyle(
              color: primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: <Color>[accentColor, primaryColor]),
          ),
        ),
        titleSpacing: 20.0,
        leading:  IconButton(
          icon:  Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Menu_BI()));

          },
        ),

        title:Text( " Filtre Etat de retour",style: TextStyle(fontSize: 19.sp,color: Colors.white,fontWeight: FontWeight.bold),),


      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 20,),

            Container(
              margin: EdgeInsets.only(left: 10,top: 40),
              child: Column(
                children: [
                  SizedBox(height: 30,),

                  _buildText("Date du :"),
                  Container(

                      margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                      child: Row(
                        children: [
                          Expanded(flex:4 ,child: InputDate( DateController: _DateDebutController, text: "du",)),

                        ],
                      )),
                  SizedBox(height: 10,),
                  _buildText("au :"),
                  Container(

                      margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                      child: Row(
                        children: [
                          Expanded(flex:4 ,child: InputDate( DateController: _DateFinController,text:"jusqu'à")),

                        ],
                      )),
                  SizedBox(height: 10,),
                  _buildText("Filter par :"),
                  Container(

                      margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                      child: Row(
                        children: [
                          Expanded(flex:4 ,child: dropdown_choixRetour( choixRetourController: _ChoixController)
                          ),

                        ],
                      )),




                  SizedBox(height: 40),
                  buildElevatedButton(),
                  SizedBox(height: 10),
                ],
              ),
            ),





          ],
        ),

      ),


    );
  }

  bool isLoading = false ;

  Widget buildElevatedButton(){
    return Container(
      width: 150.w,
      height: 50.r,
      margin: EdgeInsets.only(right: 50),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0 ,1.0],
          colors: [
            kPrimaryColor,
            kPrimaryColor,


          ],
        ),
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child:  ElevatedButton(


        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20) ),
        ),

        child: isLoading ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white,),
            SizedBox(width: 24),
            // Text('loading ...')
          ],
        ):Text('valider',style: TextStyle(fontSize: 18.sp,color: Colors.white,fontWeight: FontWeight.w600),),

        onPressed: () async {
          if(isLoading)return;
          setState(() {
            isLoading = true ;
           // Global.set_CLI_FA_Stat(_TiersController.text)  ;


          });
          await Future.delayed(Duration(seconds: 1));
          setState(() {

            isLoading = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RetourART(

                      date_debut: _DateDebutController.text,
                      date_fin: _DateFinController.text,))
            );

          });

        },
      ),
    );
  }









}




