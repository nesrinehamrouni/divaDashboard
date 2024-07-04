import 'My_globals.dart';

class BaseUrl {

static String public = "/divaDashboard/public";
static String url = "${Global.getURL()}/divaDashboard/public";
/*********************************************** user url ***************************/

  static String Login = "http://$url/api/auth/login";
  static String Logout = "http://$url/api/logout";
  static String Register = "http://$url/api/auth/register";

/*********************************************** Chiffre Affaire url ***************************/

static String CA_MONT_CLI = "http://$url/api/ChiffreAffaire/CLI_MONT_total";
static String CA_getPayeur = "http://$url/api/ChiffreAffaire/get_payeur";
static String CA_listDetail = "http://$url/api/ChiffreAffaire/listDetail";
static String CA_getCA_ShowRoom = "http://$url/api/ChiffreAffaire/getCA_ShowRoom";
static String CA_getCA_ShowRoom_detail = "http://$url/api/ChiffreAffaire/getCA_ShowRoom_detail";

/*******************************************STOCK *********************************************/

static String get_Stock = "http://$url/api/Stock/VerifStock";
static String get_total = "http://$url/api/Stock/get_total";
static String get_familleART = "http://$url/api/Stock/get_familleART";
static String get_REFART = "http://$url/api/Stock/get_REFART";

/****************************************** Piece CLI ***************************************/

static String get_PieceCLI = "http://$url/api/PieceCLI/List";

/****************************************** Ligne Piece  ***************************************/

static String get_LignePi = "http://$url/api/LignePiece/List";

/******************************************  CLI ***************************************/

static String getTiers = "http://$url/api/CLI/getTiers";

/******************************************  FA_nonPaye_CLI ***************************************/

static String getFA_nonPaye_CLI = "http://$url/api/FA/FA_nonPaye_CLI";
static String getTotalFA_nonPaye_CLI = "http://$url/api/FA/getTotal";
static String getTotalFA_nonPaye_Rep = "http://$url/api/FA/getTotal_REP";
static String get_Representant = "http://$url/api/FA/get_Representant";
static String getdetailFA_REP = "http://$url/api/FA/getdetailFA_REP";

/************************************** etat de retour ******************************************/

static String getRetour_ART_Entete = "http://$url/api/Retour/getRetour_ART_Entete";
static String getRetour_ART_Ligne = "http://$url/api/Retour/getRetour_ART_Ligne";
static String getRetour_REP_Entete = "http://$url/api/Retour/getRetour_REP_Entete";
static String getRetour_REP_Ligne = "http://$url/api/Retour/getRetour_REP_Ligne";

/************************************* notification ************************************/

static String get_Notification = "http://$url/api/Notif/get_Notification";

/************************************* DOS & ETB ************************************/

static String get_DOS = "http://$url/api/get_DOS";
static String get_ETB = "http://$url/api/get_ETB";

/************************************* Depot ************************************/

static String get_DEPO = "http://$url/api/getDEPO";






}
