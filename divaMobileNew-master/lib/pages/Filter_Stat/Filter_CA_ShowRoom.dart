

import 'package:divamobile/pages/ChiffreAffaireGS/CA_ShowRoom.dart';

import '../../colorApp.dart';
import '../../pages/Menu/MenuBI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';






class Filter_CA_SH extends StatefulWidget {
  //late final ValueChanged<bool> update;
  // Filter_CA({required this.update});

  const Filter_CA_SH({Key? key, }): super(key:key);
  @override
  State<Filter_CA_SH> createState() => _Filter_CA_SHState();
}

class _Filter_CA_SHState extends State<Filter_CA_SH> {


  var submitTextStyle = GoogleFonts.rubik(
      fontSize: 18.sp,
      letterSpacing: 3,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();






  TextEditingController dateinputTo = TextEditingController();
  TextEditingController dateinputFrom = TextEditingController();

  var loading = false;


  bool is_selected = false;




  /***************************************************** date -*******************************************/
  Widget _buidDateTo(){

    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 10,left: 30,right: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
                height: 40,


                padding: const EdgeInsets.only(left: 10,right: 10),

                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
                child:TextFormField(
                  validator: (value)=> value!.isEmpty ?"s'il vous plait entrer une date ":null,
                  controller: dateinputTo, //editing controller of this TextField
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Jusqu'a ",
                    icon: Icon(Icons.calendar_today), //icon of text field
                    //labelText: "Jusqu'a " //label text of field
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      locale: const Locale("fr", "FR"),
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),

                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary:  AppColors.lightBlueShade5,
                              onPrimary: Colors.white,
                              surface: AppColors.lightBlueShade5,
                              //onSurface: Colors.grey,
                            ),
                            // dialogBackgroundColor:Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );

                    if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinputTo.text = formattedDate; //set output date to TextField value.

                        // searchDate(dateinputFrom.text, dateinputTo.text);
                       // openaccording =  true;
                      });
                    }else{
                      print("Date is not selected");
                    //  openaccording =  true;
                    }
                  },
                )
            ),
          ),

          Expanded(
              flex: 1,
              child: Visibility(child: IconButton(onPressed: (){

              },
                icon: const Icon(Icons.delete_outline),),visible: false,))
        ],
      ),
    );
  }
  /***************************************************** date -*******************************************/
  Widget _buidDateFrom( ){

    return Container(
      height: 45,
      //margin:const EdgeInsets.only(top: 10.0) ,
      margin:const EdgeInsets.only(top: 10.0,left: 30,right: 20) ,
      child: Row(

        children: [
          Expanded(
            flex: 4,
            child: Container(
                height: 40,
                padding: const EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)
                ),
                child:TextFormField(
                  validator: (value)=> value!.isEmpty ?"s'il vous plait entrer une date ":null,
                  controller: dateinputFrom, //editing controller of this TextField
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "De la date",
                    icon: Icon(Icons.calendar_today), //icon of text field
                    //  labelText: "Enter Date BT" //label text of field
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(

                      locale: const Locale("fr", "FR"),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),

                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary:  AppColors.lightBlueShade5,
                              onPrimary: Colors.white,
                              surface: AppColors.lightBlueShade5,
                              //onSurface: Colors.grey,
                            ),
                            // dialogBackgroundColor:Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );

                    if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinputFrom.text = formattedDate;
                        // if(dateinputTo != ''){
                        //   searchDate(dateinputFrom.text, dateinputTo.text);
                        // }
                      //  openaccording =  true
                        ;              });
                    }else{
                      print("Date is not selected");
                    //  openaccording =  true ;
                    }
                  },
                )
            ),
          ),
          Expanded(
              flex: 1,
              child: Visibility(child: IconButton(onPressed: (){

              },
                icon: const Icon(Icons.delete_outline),),visible: false,))
        ],
      ),
    );
  }



  /************************************************************ liste DI *************************************************/


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAllD_intervention();
    // getAllD_intervention();


    dateinputTo.text =  DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateinputFrom.text =   DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day));




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


  bool _verticalList = true;
  ScrollController _scrollController = ScrollController();

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

        title:Text( " Filtre",style: TextStyle(fontSize: 19.sp,color: Colors.white,fontWeight: FontWeight.bold),),


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

                  _buildText("Date début :"),
                  _buidDateFrom(),
                  const SizedBox(height: 20,),
                  _buildText("Date fin :"),
                  _buidDateTo(),
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


          });
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            //widget.update(true);
            isLoading = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CA_ShowRoom(date_debut: dateinputFrom.text, date_fin: dateinputTo.text)));

          });

        },
      ),
    );
  }








  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }










}