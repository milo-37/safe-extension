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

        // 1. Validate URL
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

        // 2. Lấy host gốc, loại bỏ www., chuyển lowercase
        $host = strtolower(parse_url($url, PHP_URL_HOST) ?: $url);
        $host = preg_replace('/^www\./', '', $host);

        // Helper chuẩn hóa host từ DB (có thể lưu dưới nhiều dạng)
        $getHost = function(string $rawUrl) {
            if (!preg_match('#^https?://#i', $rawUrl)) {
                $rawUrl = 'http://' . $rawUrl;
            }
            $h = strtolower(parse_url($rawUrl, PHP_URL_HOST) ?: '');
            return preg_replace('/^www\./', '', $h);
        };

        // 3. Kiểm Whitelist
        $whitelisted = Website::where('is_blacklisted', Website::WHITELISTED)
                              ->pluck('url')
                              ->toArray();
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

        // 4. Kiểm Blacklist
        $blacklisted = Website::where('is_blacklisted', Website::BLACKLISTED)
                              ->pluck('url')
                              ->toArray();
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

        // 5. Build cache key
        $cacheKey = 'flask_analysis_' . md5($url);

        try {
            if (Cache::has($cacheKey)) {
                $json = Cache::get($cacheKey);
            } else {
                // 6. WHOIS tuổi tên miền
                $domain = preg_replace('/^www\./', '', parse_url($url, PHP_URL_HOST));
                $domainAge = 0;
                try {
                    $whois = Http::withOptions(['verify' => false])
                        ->get("https://whois.inet.vn/api/whois/domainspecify/{$domain}")
                        ->json();
                    if (!empty($whois['creationDate'])) {
                        $created   = Carbon::createFromFormat('d-m-Y', $whois['creationDate']);
                        $domainAge = now()->diffInDays($created);
                    }
                } catch (\Exception $e) {
                    $domainAge = 0;
                }

                // 7. Kiểm server location
                $isVietnam = 0;
                try {
                    $res = Http::withOptions(['verify' => false])
                        ->get("https://checkip.com.vn/locator?host={$domain}");
                    $body = $res->body();
                    $isVietnam = Str::contains($body, 'Vietnam VN') ? 1 : 2;
                } catch (\Exception $e) {
                    $isVietnam = 0;
                }

                // 8. Gọi Flask phân tích
                $response = Http::timeout(20)
                    ->post('http://127.0.0.1:5000/analyze', [
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
        } catch (\Exception $e) {
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

        // 9. Trả kết quả cuối cùng
        $score      = $json['score'];
        $deductions = $json['deductions'] ?? [];

        $action = 'safe';
        if ($score < 50) {
            $action = 'block';
        } elseif ($score < 80) {
            $action = 'warn';
        }

        return response()->json([
            'action'     => $action,
            'score'      => round(min(100, $score)),
            'deductions' => $deductions
        ]);
    }
}
