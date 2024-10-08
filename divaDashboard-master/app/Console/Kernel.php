<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use App\Console\Commands\DispatchDailyNotifications;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected $commands = [
        \App\Console\Commands\DispatchDailyNotifications::class,
    ];
    protected function schedule(Schedule $schedule)
{
    $schedule->command('notifications:dispatch-daily')->dailyAt("11:41")
    ->withoutOverlapping()->appendOutputTo(storage_path('logs/notification-dispatch.log')); ;
}
    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
