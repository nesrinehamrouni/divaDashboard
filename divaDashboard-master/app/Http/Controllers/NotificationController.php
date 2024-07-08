<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use App\Models\User;
use App\Jobs\NotificationScheduleJob;
use Google\Client as GoogleClient;

class NotificationController extends Controller
{
    static public function notify($title, $body, $device_key)
    {
        $url = "https://fcm.googleapis.com/v1/projects/laravelnotif-ec82d/messages:send";
        $credentialsFilePath = "public/json/laravelnotif-ec82d-5ce5b0db9483.json";
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
                    "click_action" => "FLUTTER_NOTIFICATION_CLICK",
                    "status" => "done",
                ],
                "android" => [
                    "priority" => "high",
                    "notification" => [
                        "sound" => "default"
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

        curl_close($ch);

        return [
            "message" => "Notification sent successfully",
            "r" => $result,
            "success" => true,
        ];
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
        }
    }
}
