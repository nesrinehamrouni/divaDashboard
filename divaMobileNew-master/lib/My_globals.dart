abstract class Global {
    static bool activate_Histo = false;
    static bool activate_Stat = false;
    static bool Accrodition_statut = false;
    static String isRetourRep = "";
    static bool loading = false;
    static int count_notif = 0;
    static String Payeur_Stat = "";
    static String Token = "";
    static String FamART_Stat = "";
    static String DOS_Stat = "1";
    static String Depot_Stat = "1";
    static String date_debut_Stat = "";
    static String date_fin_Stat = "";
    static String CLI_FA_Stat = "";
    static String? DOS = "1";
    static String? ETB = "1";
    static int NB_stock = 0;

    // static String? server_api_key = "";
    static String URL = "192.168.137.89";

    static String getURL() {
      return URL;
    }

    static String? set_URL(String URL) {
      Global.URL = URL;
      return null;
    }

    static String? getDOS() {
      return DOS;
    }

    static String? set_DOS(String DOS) {
      Global.DOS = DOS;
      return null;
    }
    static String? getETB() {
      return ETB;
    }

    static String? set_ETB(String ETB) {
      Global.ETB = ETB;
      return null;
    }


    static String getisRetourRep() {
      return isRetourRep;
    }

    static String? set_isRetourRep(String isRetourRep) {
      Global.isRetourRep = isRetourRep;
      return null;
    }

    static String getToken() {
      return Token;
    }

    static String? set_Token(String Token) {
      Global.Token = Token;
      return null;
    }

    static int get_count_notif() {
      return count_notif;
    }

    static int? set_count_notif(int count_notif) {
      Global.count_notif = count_notif;
      return null;
    }


    static String getPayeur_Stat() {
      return Payeur_Stat;
    }

    static String? set_Payeur_Stat(String Payeur_Stat) {
      Global.Payeur_Stat = Payeur_Stat;
      return null;
    }

    static String getCLI_FA_Stat() {
      return CLI_FA_Stat;
    }

    static String? set_CLI_FA_Stat(String CLI_FA_Stat) {
      Global.CLI_FA_Stat = CLI_FA_Stat;
      return null;
    }

static String getFamART_Stat() {
      return FamART_Stat;
    }

    static String? set_FamART_Stat(String FamART_Stat) {
      Global.FamART_Stat = FamART_Stat;
      return null;
    }
    static String getDOS_Stat() {
      return DOS_Stat;
    }

    static String? set_DOS_Stat(String DOS_Stat) {
      Global.DOS_Stat = DOS_Stat;
      return null;
    }

    static String getDepot_Stat() {
      return Depot_Stat;
    }

    static String? set_Depot_Stat(String Depot_Stat) {
      Global.Depot_Stat = Depot_Stat;
      return null;
    }



    static String getdate_debut_Stat() {
      return date_debut_Stat;
    }

    static String? set_date_debut_Stat(String date_debut_Stat) {
      Global.date_debut_Stat = date_debut_Stat;
      return null;
    }


    static String getdate_fin_Stat() {
      return date_fin_Stat;
    }

    static String? set_date_fin_Stat(String date_fin_Stat) {
      Global.date_fin_Stat = date_fin_Stat;
      return null;
    }

  }

