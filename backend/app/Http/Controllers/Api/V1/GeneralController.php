<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GeneralController extends Controller
{
    // Exemplo de método que chama uma API e gera um log no Slack com a cotação do Wise.
    public function GetCheckServices(): bool|array
    {
        $url = 'https://api.wise.com/v1/comparisons/provider/wise?sourceCurrency=EUR&sendAmount=1000';

        if(empty(env('LOG_SLACK_WEBHOOK_URL'))) {
            return false;
        }

        try {
            $response = Http::retry(3, 1000)->get($url)->json();
            $quotes = $response['routes'];
            $return = [];
            $percent = 3.26;
            foreach ($quotes as $quote) {
                if ($quote['targetCurrency'] === 'BRL') {
                    $return = [
                        'sourceCurrency' => $quote['sourceCurrency'],
                        'targetCurrency' => $quote['targetCurrency'],
                        'receivedAmount' => $quote['quotes'][0]['receivedAmount'],
                        'rate' => $quote['quotes'][0]['rate'],
                        'fee' => $quote['quotes'][0]['fee'],
                        'dateCollected' => $quote['quotes'][0]['dateCollected'],
                        'midmarketRate' => $quote['quotes'][0]['midmarketRate'],
                        'estimateBRL' => number_format(((floatval($quote['quotes'][0]['receivedAmount']) * $percent) / 100) + floatval($quote['quotes'][0]['receivedAmount']), 2, ',', '.'),
                        'estimateEUR' => number_format(1000, 2, ',', '.'),
                    ];
                    break;
                }
            }

            Log::info("Cotação Wise", [$return]);
            return $return;
        } catch (RequestException $exception) {
            Log::critical("Erro na API da Wise!", [$exception->getCode(), $exception->response->json(), $url]);

            return false;
        }
    }
}
