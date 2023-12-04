<?php

namespace App\Console\Commands;

use App\Jobs\GeneralJob;
use Illuminate\Console\Command;

class GeneralCommand extends Command
{
    protected $signature = 'general:command';

    protected $description = 'Check Service API';

    public function __construct()
    {
        parent::__construct();
    }

    public function handle()
    {
        GeneralJob::dispatch()->delay(now());

        return 0;
    }
}
