<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Http\Controllers\NotificationController;
use Illuminate\Support\Facades\LOG;

class NotificationScheduleJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
     /**
     * The title of the notification.
     *
     * @var string
     */
    protected $title;

    /**
     * The body of the notification.
     *
     * @var string
     */
    protected $body;

    /**
     * The key for the notification.
     *
     * @var string
     */
    protected $key;

    /**
     * Create a new job instance.
     *
     * @param string $title
     * @param string $body
     * @param string $key
     * @return void
     */
  
    public function __construct($title, $body, $key)
    {
        $this->title = $title;
        $this->body = $body;
        $this->key = $key;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
    Log::info("Entering handle function of NotificationScheduleJob");
        
        try {
            NotificationController::notify($this->title, $this->body, $this->key);
        } catch (\Exception $e) {
            Log::error("Failed to send notification: " . $e->getMessage());
            // Handle the exception as needed
        }
    }
}
