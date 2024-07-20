

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {


static final String url = dotenv.env['API_BASE_URL'] ?? 'http://default_url';

/*********************************************** user url ***************************/
static final String Login = url + '/auth/login';
static final String Register = url + '/auth/register';
static final String Logout = url + '/auth/logout';
static final String Verify = url + '/auth/verify';
static final String Notify = url + '/notify';
static final String GetUsers = url + '/users';
static final String GetCurrentUserId = url + '/current_user_id';

/*********************************************** Chiffre Affaire url ***************************/

static final String CA_MONT_CLI = url + "/ChiffreAffaire/CLI_MONT_total";
static final String CA_getPayeur = url + "/ChiffreAffaire/get_payeur";
static final String CA_listDetail = url + "/ChiffreAffaire/listDetail";
static final String CA_getCA_ShowRoom = url + "/ChiffreAffaire/getCA_ShowRoom";
static final String CA_getCA_ShowRoom_detail = url +  "/ChiffreAffaire/getCA_ShowRoom_detail";

/*******************************************STOCK *********************************************/

static final String get_Stock = url + "/Stock/VerifStock";
static final String get_total = url + "/Stock/get_total";
static final String get_familleART = url + "/Stock/get_familleART";
static final String get_REFART = url + "/Stock/get_REFART";

/****************************************** Piece CLI ***************************************/

static final String get_PieceCLI = url + "/PieceCLI/List";

/****************************************** Ligne Piece  ***************************************/

static final String get_LignePi = url + "/LignePiece/List";

/******************************************  CLI ***************************************/

static final String getTiers = url + "/CLI/getTiers";

/******************************************  FA_nonPaye_CLI ***************************************/

static final String getFA_nonPaye_CLI = url + "/FA/FA_nonPaye_CLI";
static final String getTotalFA_nonPaye_CLI = url + "/FA/getTotal";
static final String getTotalFA_nonPaye_Rep = url + "/FA/getTotal_REP";
static final String get_Representant = url + "/FA/get_Representant";
static final String getdetailFA_REP = url + "/FA/getdetailFA_REP";

/************************************** etat de retour ******************************************/

static final String getRetour_ART_Entete = url + "/Retour/getRetour_ART_Entete";
static final String getRetour_ART_Ligne = url + "/Retour/getRetour_ART_Ligne";
static final String getRetour_REP_Entete = url + "/Retour/getRetour_REP_Entete";
static final String getRetour_REP_Ligne = url + "/Retour/getRetour_REP_Ligne";

/************************************* notification ************************************/

static final String getNotifications = url + "/getNotifications";


/************************************* DOS & ETB ************************************/

static final String get_DOS = url + "/get_DOS";
static final String get_ETB = url + "/get_ETB";

/************************************* Depot ************************************/

static final String get_DEPO = url + "/getDEPO";






}
