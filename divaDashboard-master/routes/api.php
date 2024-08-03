<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ChiffreAffaireController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\StockController;
use App\Http\Controllers\PieceController;
use App\Http\Controllers\CLIController;
use App\Http\Controllers\MOVController;
use App\Http\Controllers\FactureNonPaye_CLIController;
use App\Http\Controllers\FactureNonPaye_REPController;
use App\Http\Controllers\Etat_RetourController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\DOS_ETBController;
use App\Http\Controllers\DepotController;
use App\Http\Controllers\VerificationmailController;
use App\Http\Controllers\ConversationController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\AttachmentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});



Route::post('auth/register',[AuthController::class,'register']);
Route::post('auth/login', [AuthController::class, 'login'])->name('login');
Route::post('auth/verify', [VerificationmailController::class,'verifyCode']);
Route::post("auth/logout", [AuthController::class, 'logout']);
Route::get('users', [AuthController::class, 'get_user']);
Route::get('current_user_id', [AuthController::class, 'getCurrentUserId']);

Route::post('notify', [NotificationController::class,'testqueues']);

Route::post("ChiffreAffaire", [ChiffreAffaireController::class,'list']);


Route::post("ChiffreAffaire/getCA_ShowRoom", [ChiffreAffaireController::class,'getCA_ShowRoom']);


Route::group(['middleware'=>['auth:sanctum']],function(){
    
    Route::post("/verif_password", [AuthController::class, 'passwordverif']);
    Route::get("/get_user", [AuthController::class, 'get_user']);
    Route::post("ChiffreAffaire", [ChiffreAffaireController::class,'list']);
    Route::post("ChiffreAffaire/listDetail", [ChiffreAffaireController::class,'list_CA_Detail']);
    Route::get("ChiffreAffaire/get_payeur", [ChiffreAffaireController::class,'get_payeur']);
    Route::post("ChiffreAffaire/CLI_MONT_total", [ChiffreAffaireController::class,'CLI_MONT_total']);
    
    Route::post("ChiffreAffaire/getCA_ShowRoom_detail", [ChiffreAffaireController::class,'getCA_ShowRoom_detail']);

    /******************************************* Etat Stock ******************************************* */

    Route::post("Stock/VerifStock", [StockController::class,'get_stock']);
    Route::get("Stock/get_total", [StockController::class,'get_total']);
    Route::get("Stock/get_familleART", [StockController::class,'get_familleART']);
    Route::post("Stock/get_REFART", [StockController::class,'get_REFART']);
 
    

    /************************************************* Piece CLI  *************************************** */

    Route::post("PieceCLI/List", [PieceController::class,'get_PieceCLI']);

 /************************************************* ligne pièce (MOUV) *************************************** */

    Route::post("LignePiece/List", [MOVController::class,'get_ligne']);

    /************************************************* Tiers **************************************** */
 
    Route::get("CLI/getTiers", [CLIController::class,'get_Tiers']);

   
    /************************************************* FA non payée par CLI *************************************** */

    Route::post("FA/FA_nonPaye_CLI", [FactureNonPaye_CLIController::class,'getEtatFA_nonPaye_CLI']);
    Route::post("FA/getTotal", [FactureNonPaye_CLIController::class,'getTotal']);
    Route::post("FA/getTotal_REP", [FactureNonPaye_REPController::class,'getFA_nonp_REP']);
    Route::post("FA/get_Representant", [FactureNonPaye_REPController::class,'get_Representant']);
    Route::post("FA/getdetailFA_REP", [FactureNonPaye_REPController::class,'getdetailFA_REP']);

    /***************************************** Retour par article *********************************** */

    Route::post("Retour/getRetour_ART", [Etat_RetourController::class,'getRetour_ART']);
    Route::post("Retour/getRetour_ART_Entete", [Etat_RetourController::class,'getRetour_ART_Entete']);
    Route::post("Retour/getRetour_ART_Ligne", [Etat_RetourController::class,'getRetour_ART_Ligne']);
    Route::post("Retour/getRetour_REP_Entete", [Etat_RetourController::class,'getRetour_REP_Entete']);
    Route::post("Retour/getRetour_REP_Ligne", [Etat_RetourController::class,'getRetour_REP_Ligne']);

    /************************************************** Notif *********************************** */

    // Route::post("Notif/get_Notification", [NotificationController::class,'get_Notification']);
    // Route::get('notifications', [NotificationController::class, 'getNotifications']);
    Route::get('getNotifications', [NotificationController::class, 'getNotifications'])->withoutMiddleware(['auth:api']);
    Route::post('markNotificationAsRead/{notificationId}', [NotificationController::class, 'markNotificationAsRead']);

    /************************************************** DOS & ETB *********************************** */

    Route::get("get_DOS", [DOS_ETBController::class,'get_DOS']);
    Route::post("get_ETB", [DOS_ETBController::class,'get_ETB']);

    /************************************************** depot ************************** */

    Route::post("getDEPO", [DepotController::class,'getDEPO']);

    

    Route::prefix('chat')->group(function () {
        // Conversations
        Route::get('conversations', [ConversationController::class, 'index']);
        Route::post('conversations', [ConversationController::class, 'store']);
        Route::get('conversations/{conversation}', [ConversationController::class, 'show']);

        // Messages
        Route::get('conversations/{conversation}/messages', [MessageController::class, 'index']);
        Route::post('conversations/{conversation}/messages', [MessageController::class, 'store']);

        // Attachments
        Route::post('messages/{message}/attachments', [AttachmentController::class, 'store']);
        Route::get('attachments/{attachment}', [AttachmentController::class, 'show']);
    });
});