<?php

namespace App\Providers;

use App\Models\User;
use App\Observers\UserUuidObserver;
use Illuminate\Routing\UrlGenerator;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(UrlGenerator $url): void
    {
        Schema::defaultStringLength(255);

        // Força o uso do HTTPS nas requisições em Prod.
        if (getenv('APP_ENV') == "production") {
            $url->forceScheme('https');
            $this->app['request']->server->set('HTTPS', 'on');
        }

        // Ativa o UserUuidObserver
        User::observe(UserUuidObserver::class);
    }
}
