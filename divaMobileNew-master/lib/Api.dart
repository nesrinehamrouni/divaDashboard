

class BaseUrl {


static const url = 'http://192.168.1.6:8000/api';

/*********************************************** user url ***************************/
static const Login = url + '/auth/login';
static const Register = url + '/auth/register';
static const Logout = url + '/auth/logout';
static const Verify = url + '/auth/verify';
static const Notify = url + '/notify';

/*********************************************** Chiffre Affaire url ***************************/

static const CA_MONT_CLI = url + "/ChiffreAffaire/CLI_MONT_total";
static const CA_getPayeur = url + "/ChiffreAffaire/get_payeur";
static const CA_listDetail = url + "/ChiffreAffaire/listDetail";
static const CA_getCA_ShowRoom = url + "/ChiffreAffaire/getCA_ShowRoom";
static const CA_getCA_ShowRoom_detail = url +  "/ChiffreAffaire/getCA_ShowRoom_detail";

/*******************************************STOCK *********************************************/

static const get_Stock = url + "/Stock/VerifStock";
static const get_total = url + "/Stock/get_total";
static const get_familleART = url + "/Stock/get_familleART";
static const get_REFART = url + "/Stock/get_REFART";

/****************************************** Piece CLI ***************************************/

static const get_PieceCLI = url + "/PieceCLI/List";

/****************************************** Ligne Piece  ***************************************/

static const get_LignePi = url + "/LignePiece/List";

/******************************************  CLI ***************************************/

static const getTiers = url + "/CLI/getTiers";

/******************************************  FA_nonPaye_CLI ***************************************/

static const getFA_nonPaye_CLI = url + "/FA/FA_nonPaye_CLI";
static const getTotalFA_nonPaye_CLI = url + "/FA/getTotal";
static const getTotalFA_nonPaye_Rep = url + "/FA/getTotal_REP";
static const get_Representant = url + "/FA/get_Representant";
static const getdetailFA_REP = url + "/FA/getdetailFA_REP";

/************************************** etat de retour ******************************************/

static const getRetour_ART_Entete = url + "/Retour/getRetour_ART_Entete";
static const getRetour_ART_Ligne = url + "/Retour/getRetour_ART_Ligne";
static const getRetour_REP_Entete = url + "/Retour/getRetour_REP_Entete";
static const getRetour_REP_Ligne = url + "/Retour/getRetour_REP_Ligne";

/************************************* notification ************************************/

static const get_Notification = url + "/Notif/get_Notification";

/************************************* DOS & ETB ************************************/

static const get_DOS = url + "/get_DOS";
static const get_ETB = url + "/get_ETB";

/************************************* Depot ************************************/

static const get_DEPO = url + "/getDEPO";






}
