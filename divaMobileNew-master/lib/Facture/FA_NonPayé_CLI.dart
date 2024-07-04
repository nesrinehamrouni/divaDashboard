import '../Facture/widget/Tableau_FA.dart';
import '../Facture/widget/dunatChart_FA_nnpay%C3%A9_CLI.dart';
import '../constants.dart';
import '../pages/Filter_Stat/Filter_FA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colorApp.dart';

class FA_CLI_NonPayer extends StatefulWidget {
  String? ETB;
  String? REP;
  String? CLI;
  String date_debut;
  String date_fin;

  FA_CLI_NonPayer(
      {Key? key,
       this.ETB,
       this.REP,
       this.CLI,
      required this.date_debut,
      required this.date_fin})
      : super(key: key);

  @override
  CA_list createState() => CA_list();
}

class CA_list extends State<FA_CLI_NonPayer>
    with AutomaticKeepAliveClientMixin<FA_CLI_NonPayer> {
  static const String _title = " Facture non payé ";

  Widget WidgetTitle = Text(
    _title,
    style: TextStyle(fontSize: 17.sp, color: Colors.white),
  );

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  var loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  /******************************************************** build stat *****************************************/
  Widget _buildStatistique() {
    return Container(
      height: MediaQuery.of(context).size.height * 1.9,
      child: Column(
        children: <Widget>[
          _buildStatCard(Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Totale facture non payé",
                style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 200,
                  child: dunatChart_FA_NonPaye_CLI(
                      ETB: widget.ETB,
                      CLI: widget.CLI,
                      REP: widget.REP,
                      date_debut: widget.date_debut,
                      date_fin: widget.date_fin)),
            ],
          )),
          _buildStatCard(Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Liste facture non payé",
                style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                //  height: 200,
                  child: Table_FA_nonPayer(
                      ETB: widget.ETB,
                      CLI: widget.CLI,
                      REP: widget.REP,
                      date_debut: widget.date_debut,
                      date_fin: widget.date_fin)),
            ],
          )),
        ],
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Filter_FA()),
                  (route) => false);
            },
          ),
          title: WidgetTitle,
        ),
        body: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildStatistique(),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ));
  }

  Container _buildStatCard(Widget widget) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      //padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlueShade2,
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 2.0, //extend the shadow

            offset: Offset(
              5.0, // Move to right 5  horizontally
              5.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: widget,
    );
  }
}
