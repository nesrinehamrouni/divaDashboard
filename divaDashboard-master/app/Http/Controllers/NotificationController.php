<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Models\User;
use App\Jobs\NotificationScheduleJob;

class NotificationController extends Controller
{
    static public function notify($title, $body, $device_key){
        $url ="https://fcm.googleapis.com/fcm/send";
        $serverKey= env('serverKey', 'sync');

        $dataArr = [
            "click_action" => "FLUTTER_NOTIFICATION_CLICK",
            "status" => "done",
        ];

        $data=[
            "registration_ids" => $device_key,
            "notification" => [
                "title" => $title,
                "body" => $body,
                "sound" => "default",
            ],
            "data" => $dataArr,
            "priority" => "high",
        ];

        $encodeData = json_encode($data);
        $headers=[
            "Authorization: key=".$serverKey,
            "Content-Type: application/json",
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

    public function testqueues(Request $request){
        $users = User::whereNotNull('device_key')->whereNotNull('delay')->get();

        foreach ($users as $user) {
            dispatch(
                new NotificationScheduleJob(
                    $user->nom,
                    $user->prenom,
                    $user->email,
                    $user->device_key,
                )
            )->delay(now()->addMinutes($user->delay)) ;
        }
    }
}
