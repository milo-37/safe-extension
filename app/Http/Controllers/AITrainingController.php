<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Http;

class AITrainingController extends Controller
{
    public function train()
    {
        try {
            $response = Http::timeout(20)->post('http://127.0.0.1:5000/train-model');

            if ($response->successful()) {
                return back()->with('success', 'Huấn luyện AI thành công!');
            } else {
                return back()->with('error', 'Gọi Flask thất bại: ' . $response->body());
            }
        } catch (\Exception $e) {
            return back()->with('error', 'Lỗi khi kết nối đến Flask: ' . $e->getMessage());
        }
    }
}
