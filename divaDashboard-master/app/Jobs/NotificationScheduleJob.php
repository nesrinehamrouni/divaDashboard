<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Http\Controllers\NotificationController;
use Illuminate\Support\Facades\Log;

class NotificationScheduleJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $title;
    protected $body;
    protected $key;
    protected $click_action;

    public function __construct($title, $body, $key, $click_action = 'FLUTTER_NOTIFICATION_CLICK')
    {
        $this->title = $title;
        $this->body = $body;
        $this->key = $key;
        $this->click_action = $click_action;
    }

    public function handle()
    {
        Log::info("Executing NotificationScheduleJob");    
        NotificationController::notify($this->title, $this->body, $this->key, $this->click_action);
    }
}