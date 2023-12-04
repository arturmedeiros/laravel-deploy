<?php

namespace App\Jobs;

use App\Http\Controllers\Api\V1\GeneralController;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class GeneralJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 3;

    public int $timeout = -1;

    public function __construct()
    {
        //
    }

    public function handle()
    {
        $service = new GeneralController();
        if (!$service->GetCheckServices()){
            return false;
        }

        return true;
    }
}
