<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Jobs\NotificationScheduleJob;
use Illuminate\Support\Facades\Log;

class DispatchDailyNotifications extends Command
{
    protected $signature = 'notifications:dispatch-daily';
    protected $description = 'Dispatch daily notifications for all users';

    public function handle()
    {
        Log::info('Starting daily notification dispatch');

        $users = User::whereNotNull('device_key')->get();
        
        Log::info('Found ' . $users->count() . ' users with device keys');

        foreach ($users as $user) {
            dispatch(new NotificationScheduleJob(
                $user->nom,
                $user->email,
                $user->device_key
            ));
            Log::info("Dispatched notification for user: {$user->id}");
        }

        Log::info('Completed daily notification dispatch');

        $this->info('Daily notifications dispatched for ' . $users->count() . ' users.');
    }
}