import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Accordion_blue extends StatefulWidget {
  final String title;

  final Widget content;

  const Accordion_blue({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion_blue> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 63.h,

      child: Card(
        semanticContainer: true,
        //color: Colors.blue[800],

        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   width:2,
          //   color: Colors.blue.shade800,
          // ),
          borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
        ),
        margin: const EdgeInsets.only(top: 5,bottom: 5),
        child: Container(
        // padding: EdgeInsets.symmetric(vertical: 2),

          child: Column(children: [
            Container(

              decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10 ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      primaryColor,
                      Constants.TextColor,
                    ],
                  )),
              //height: 36.h,
              constraints: BoxConstraints(
                  minHeight:  36.h, maxHeight: 40.h),
             // padding: EdgeInsets.only(bottom: 5),
              child: ListTile(
                  //tileColor: _showContent ? AppColors.blueShade2 : Colors.blue[800],
                  title: Text(widget.title ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 12.sp),),
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10 ),
                  ),
                  trailing: IconButton(
                    color: Colors.white,
                    icon: Icon(

                        _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showContent = !_showContent;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showContent = !_showContent;
                    });
                  }
              ),
            ),
            _showContent
                ? Container(

              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: widget.content,
            )
                : Container()
          ]),
        ),
      ),
    );
  }
}