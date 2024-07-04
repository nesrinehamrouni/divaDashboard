import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../colorApp.dart';



class InputDate extends StatefulWidget {

  TextEditingController DateController;
  String text;

  InputDate({Key? key, required this.DateController,required this.text})
      : super(key: key);
  @override
  InputDateState createState() =>InputDateState();
}

class InputDateState extends State<InputDate> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  bool visibile_date =false;






  Widget _buidDate(){

    return Container(
      height: 45,
      //margin: const EdgeInsets.only(top: 10,left: 30,right: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
                height: 40,


               // padding: const EdgeInsets.only(left: 10,right: 10),

                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
                child:TextFormField(
                  validator: (value)=> value!.isEmpty ?"s'il vous plait entrer une date ":null,
                  controller: widget.DateController, //editing controller of this TextField
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.text,
                    icon: Icon(Icons.calendar_today,size: widget.DateController.text=="" ? 20:0,), //icon of text field
                    //labelText: "Jusqu'a " //label text of field
                    contentPadding: EdgeInsets.symmetric(horizontal: -12),
                  ),
                  readOnly: true,
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
                        widget.DateController.text = formattedDate; //set output date to TextField value.
                        visibile_date = true;
                        // searchDate(dateinputFrom.text, dateinputTo.text);
                       // openaccording =  true;
                      });
                    }else{
                      print("Date is not selected");
                     // openaccording =  true;
                    }
                  },
                )
            ),
          ),

          Expanded(
              flex: 1,
              child: Visibility(child: IconButton(onPressed: (){
                setState(() {
                  visibile_date = false;
                  widget.DateController.clear();
                });

              },
                icon: const Icon(Icons.delete_outline,size: 22,),),visible: visibile_date,))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context)  {
    return _buidDate();
  }


}

