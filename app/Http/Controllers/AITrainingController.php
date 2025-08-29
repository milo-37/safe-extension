<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\JsonResponse;

class AITrainingController extends Controller
{
    /** Gọi Flask train-model, trả về [ok(bool), message(string)] */
    private function callFlaskTrain(): array
    {
        $base    = rtrim(config('services.flask.base_url', env('FLASK_BASE_URL', 'http://python_analyzer:8000')), '/');
        $timeout = (int) config('services.flask.timeout', (int) env('FLASK_TIMEOUT', 20));
        $url     = $base . '/train-model';

        try {
            Log::info('Training AI via Flask', ['url' => $url, 'timeout' => $timeout]);
            $res = Http::timeout($timeout)->post($url);

            if ($res->successful()) {
                return [true, 'Huấn luyện AI thành công!'];
            }
            return [false, 'Gọi Flask thất bại: ' . $res->body()];
        } catch (\Throwable $e) {
            return [false, 'Lỗi khi kết nối đến Flask: ' . $e->getMessage()];
        }
    }

    /** Dùng cho giao diện web (redirect back) */
    public function train()
    {
        [$ok, $msg] = $this->callFlaskTrain();
        return back()->with($ok ? 'success' : 'error', $msg);
    }

    /** Dùng cho API (Postman) – trả JSON */
    public function trainApi(): JsonResponse
    {
        [$ok, $msg] = $this->callFlaskTrain();
        return response()->json(
            $ok ? ['message' => $msg] : ['error' => $msg],
            $ok ? 200 : 500
        );
    }
}
