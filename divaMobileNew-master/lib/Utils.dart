//import 'models/user.dart';

abstract class Utils{
  static String? token;
  // static User? user;
  //
  // static User? getUser(){
  //   return user;
  // }
  //
  static String? getToken(){
    return token;
  }
  //
  // static User? setUser(User? u){
  //   Utils.user = u ;
  // }

  static String? setToken(String? token)  {
    Utils.token = token;
    return null;
  }
}