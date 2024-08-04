<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\User;
use App\Jobs\NotificationScheduleJob;
use Google\Client as GoogleClient;

class NotificationController extends Controller
{
    static public function notify($title, $body, $device_key, $click_action ='FLUTTER_NOTIFICATION_CLICK')
    {
        $url = "https://fcm.googleapis.com/v1/projects/laranotify-99086/messages:send";
        $credentialsFilePath = env('GOOGLE_APPLICATION_CREDENTIALS', public_path('json/laranotify-99086-1af7c591118e.json'));
        if (!file_exists($credentialsFilePath)) {
          Log::error("Credentials file not found: $credentialsFilePath");
          return [
              "message" => "Failed to send notification: Credentials file not found",
              "success" => false,
          ];
      }
        $client = new GoogleClient();
        $client->setAuthConfig($credentialsFilePath);
        $client->addScope('https://www.googleapis.com/auth/firebase.messaging');
        $client->refreshTokenWithAssertion();
        $token = $client->getAccessToken();
        $access_token = $token['access_token'];

        $data = [
            "message" => [
                "token" => $device_key,
                "notification" => [
                    "title" => $title,
                    "body" => $body,
                ],
                "data" => [
                "click_action" => $click_action,
                "sound"=> "default", 
                "status"=> "done",
                "screen"=> "tableau_de_bord"
            ],
                "android" => [
                    "priority" => "high",
                    "notification" => [
                        "sound" => "default",
                        "icon" => "res_launcher_icon"
                    ]
                ]
            ]
        ];

        $encodeData = json_encode($data);
        $headers = [
            "Authorization: Bearer $access_token",
            'Content-Type: application/json'
        ];

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $encodeData);

        $result = curl_exec($ch);
        Log::info($result);

        if ($result === FALSE) {
            return [
                "message" => "Failed to send notification",
                "r" => $result,
                "success" => false,
            ];
        }
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        Log::info("FCM notification response: $result");

        if ($http_code >= 200 && $http_code < 300) {
            DB::table('MNOTIFICATION')->insert([
                'CE1' => '',
                'NOTIFICATIONCOD' => '',  
                'LIBL1' => $title,
                'ACTIFFLG' => 0,
                'MODEAFFICHAGE' => 0,
                'CENOTE' => 0,
                'NOTE' => 0,
                'IMPORTANCE' => 0,
                'BLOQUANTFLG' => 0,
                'MASQUABLEFLG' => 0,
                'ACTIONFLG' => 0,
                'AP' => '',
                'REG' => '',
                'ORDRE' => 0,
                'USERCR' => '',
                'USERMO' => '',
                'AFFICHAGETPV' => $body
            ]);
    
            return [
                "message" => "Notification sent successfully",
                "success" => true
            ];
        } else {
            Log::error("Failed to send notification. HTTP Status Code: $http_code");
            return [
                "message" => "Failed to send notification",
                "success" => false,
                "http_code" => $http_code
            ];
        }
    }

    public function testqueues(Request $request)
    {
        $users = User::whereNotNull('device_key')->whereNotNull('delay')->get();
        Log::info('Sending notifications to user');
        foreach ($users as $user) {
            dispatch(
                new NotificationScheduleJob(
                    $user->nom,
                    $user->email,
                    $user->device_key,

                )
                )->delay(now()->addSeconds($user->delay));
            // dispatch(new FetchNotificationsJob($user->id));
        }
    }

    public function getNotifications(): JsonResponse
{
    try {
        DB::beginTransaction();

        $notification = DB::table('MNOTIFICATION')
            ->where('ACTIFFLG', 0)
            ->orderBy('MNOTIFICATION_ID', 'asc')
            ->lockForUpdate()
            ->first();

        if ($notification) {
            // Mark the notification as read immediately
            DB::table('MNOTIFICATION')
                ->where('MNOTIFICATION_ID', $notification->MNOTIFICATION_ID)
                ->update(['ACTIFFLG' => 1]);

            DB::commit();

            Log::info('Notification fetched and marked as read: ' . json_encode($notification));
            return response()->json([$notification]);
        } else {
            DB::commit();
            return response()->json([]);
        }
    } catch (\Exception $e) {
        DB::rollBack();
        Log::error('Error fetching notification: ' . $e->getMessage());
        return response()->json(['error' => 'Failed to fetch notification'], 500);
    }
}

}