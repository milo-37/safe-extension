<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;
use App\Models\Website;
use Illuminate\Support\Str;
use Carbon\Carbon;

class WebsiteCheckerController extends Controller
{
    public function check(Request $request)
    {
        $url = $request->input('url');

        // 1) Validate
        if (!$url || !filter_var($url, FILTER_VALIDATE_URL)) {
            return response()->json([
                'action'     => 'warn',
                'score'      => 50,
                'deductions' => [[
                    'reason' => 'URL không hợp lệ, không thể gửi URL.',
                    'score'  => 50,
                    'type'   => 'negative'
                ]]
            ]);
        }

        // 2) Chuẩn hóa host
        $host = strtolower(parse_url($url, PHP_URL_HOST) ?: $url);
        $host = preg_replace('/^www\./', '', $host);

        // Helper lấy host từ chuỗi bất kỳ (có thể thiếu schema)
        $getHost = function (string $rawUrl) {
            if (!preg_match('#^https?://#i', $rawUrl)) {
                $rawUrl = 'http://' . $rawUrl;
            }
            $h = strtolower(parse_url($rawUrl, PHP_URL_HOST) ?: '');
            return preg_replace('/^www\./', '', $h);
        };

        // 3) Whitelist
        $whitelisted = Website::where('is_blacklisted', Website::WHITELISTED)
            ->pluck('url')->toArray();

        foreach ($whitelisted as $wl) {
            $wlHost = $getHost($wl);
            if ($host === $wlHost || Str::endsWith($host, '.' . $wlHost)) {
                return response()->json([
                    'action'     => 'safe',
                    'score'      => 100,
                    'deductions' => [[
                        'reason' => 'Trang web nằm trong danh sách website an toàn.',
                        'score'  => 100,
                        'type'   => 'positive'
                    ]]
                ]);
            }
        }

        // 4) Blacklist
        $blacklisted = Website::where('is_blacklisted', Website::BLACKLISTED)
            ->pluck('url')->toArray();

        foreach ($blacklisted as $bl) {
            $blHost = $getHost($bl);
            if ($host === $blHost || Str::endsWith($host, '.' . $blHost)) {
                return response()->json([
                    'action'     => 'block',
                    'score'      => 0,
                    'deductions' => [[
                        'reason' => 'Trang web nằm trong danh sách website lừa đảo.',
                        'score'  => 0,
                        'type'   => 'negative'
                    ]]
                ]);
            }
        }

        // 5) Cache
        $cacheKey = 'flask_analysis_v1_' . md5($url);

        try {
            if (Cache::has($cacheKey)) {
                $json = Cache::get($cacheKey);
            } else {
                // 6) WHOIS -> domain_age (ngày)
                $domain = preg_replace('/^www\./', '', parse_url($url, PHP_URL_HOST));
                $domainAge = 0;

                try {
                    $whois = Http::withOptions(['verify' => false])
                        ->timeout(10)
                        ->get("https://whois.inet.vn/api/whois/domainspecify/{$domain}")
                        ->json();

                    // API này thường trả "creationDate" dạng dd-mm-YYYY
                    if (!empty($whois['creationDate'])) {
                        $created = Carbon::createFromFormat('d-m-Y', $whois['creationDate']);
                        $domainAge = now()->diffInDays($created);
                    }
                } catch (\Throwable $e) {
                    $domainAge = 0; // fallback
                }

                // 7) Server location -> is_vietnam: 0 unknown, 1 VN, 2 non-VN
                $isVietnam = 0;
                try {
                    $res = Http::withOptions(['verify' => false])
                        ->timeout(10)
                        ->get("https://checkip.com.vn/locator?host={$domain}");
                    $body = $res->body();
                    $isVietnam = Str::contains($body, 'Vietnam VN') ? 1 : 2;
                } catch (\Throwable $e) {
                    $isVietnam = 0;
                }

                // 8) Gọi Flask (chỉ phân tích; KHÔNG làm WHOIS/Geo)
                $flaskBase = rtrim(config('services.flask.base_url', env('FLASK_BASE_URL', 'http://python-analyzer:8000')), '/');
                $timeout   = (int) env('FLASK_TIMEOUT', 20);

                $response = Http::timeout($timeout)
                    ->post("{$flaskBase}/analyze", [
                        'url'        => $url,
                        'domain_age' => $domainAge,
                        'is_vietnam' => $isVietnam
                    ]);

                $json = $response->json();

                if (!is_array($json) || !isset($json['score'])) {
                    throw new \Exception('Dữ liệu trả về từ Flask không hợp lệ.');
                }

                Cache::put($cacheKey, $json, now()->addMinutes(10));
            }
        } catch (\Throwable $e) {
            Log::error('Lỗi khi gọi Flask: ' . $e->getMessage());
            return response()->json([
                'action'     => 'warn',
                'score'      => 50,
                'deductions' => [[
                    'reason' => 'Không thể kết nối tới Flask.',
                    'score'  => 50,
                    'type'   => 'negative'
                ]]
            ]);
        }

        // 9) Quy đổi action cuối
        $score      = (float) $json['score'];
        $deductions = $json['deductions'] ?? [];

        $action = 'safe';
        if ($score < 50)       $action = 'block';
        elseif ($score < 80)   $action = 'warn';

        return response()->json([
            'action'     => $action,
            'score'      => (int) round(min(100, max(0, $score))),
            'deductions' => $deductions
        ]);
    }
}
