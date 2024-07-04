import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../Api.dart';
import '../My_globals.dart';
import '../Utils.dart';
import 'notification_service.dart';



class Notif_Function  {






  static Future<void> notify()  async {

    var List_notif = [];

    String myUrl = BaseUrl.get_Notification;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {


          "DOS":Global.getDOS(),
          "date":DateTime.now().toString(),

        }).then((response) async {
      print('Response status : ${response.statusCode}');
      print('Response body notif : ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        List_notif = jsonData;
        for (var item in List_notif){

          await NotificationService.showNotification(
            title: "Notification ",
            body: item['LIBL1'],
            payload: {
              "navigate": "diva",


            },


          );

          //FlutterAppBadger.updateBadgeCount(Global.count_notif +1);
        }



      }

    });







  }





  Future getAllnotif()  async {


  }

  // static Future<void> listeNotif()  async {
  //
  //
  //
  // }


}