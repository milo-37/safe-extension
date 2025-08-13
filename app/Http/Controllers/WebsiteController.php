<?php

namespace App\Http\Controllers;

use App\Models\Website;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class WebsiteController extends Controller
{
    const BLACKLISTED = 1;
    const WHITELISTED = 0;

    // ==================== COMMON ====================
    public function index(Request $request)
    {
        $isBlacklisted = $request->get('is_blacklisted', self::BLACKLISTED);
        $search = $request->get('search');

        $query = Website::where('is_blacklisted', $isBlacklisted);

        if (!empty($search)) {
            $query->where('url', 'like', '%' . $search . '%');
        }

        $websites = $query->orderBy('created_at', 'desc')
            ->paginate(10)
            ->appends([
                'is_blacklisted' => $isBlacklisted,
                'search' => $search,
            ]);

        return view('websites.index', compact('websites', 'isBlacklisted'));
    }


    // ==================== CREATE ====================
    public function create(Request $request)
    {
        $isBlacklisted = $request->get('is_blacklisted', self::BLACKLISTED);
        return view('websites.create', compact('isBlacklisted'));
    }

    // ==================== EDIT ====================
    public function edit(Website $website)
    {
        return view('websites.edit', compact('website'));
    }

    // ==================== STORE ====================
    public function store(Request $request)
    {
        $this->validateStoreRequest($request);

        $url = trim($request->url);

        // Xóa website khỏi loại đối diện
        $this->removeOppositeType($url, $request->is_blacklisted);

        // Tạo mới website
        $this->createWebsite($url, $request->is_blacklisted, $request->reason);

        return redirect()->route('websites.index', ['is_blacklisted' => $request->is_blacklisted])
            ->with('success', 'Website đã được thêm vào ' . ($request->is_blacklisted == self::BLACKLISTED ? 'Blacklist' : 'Whitelist') . '!');
    }

    // ==================== UPDATE ====================
    public function update(Request $request, Website $website)
    {
        $request->validate([
            'url' => 'required|string|unique:websites,url,' . $website->id,
            'reason' => 'nullable|string|max:255',
            'is_blacklisted' => 'required|in:' . self::BLACKLISTED . ',' . self::WHITELISTED,
        ]);

        $website->update([
            'url' => $request->url,
            'reason' => $request->reason,
            'is_blacklisted' => $request->is_blacklisted,
        ]);

        return redirect()->route('websites.index', ['is_blacklisted' => $request->is_blacklisted])
            ->with('success', 'Website đã được cập nhật!');
    }


    // ==================== DELETE MULTIPLE ====================
    public function destroy(Request $request)
    {
        $this->validateDestroyRequest($request);

        if (empty($request->urls)) {
            return redirect()->route('websites.index', ['is_blacklisted' => $request->is_blacklisted])
                ->with('error', 'Không có website nào được chọn để xóa!');
        }

        Website::whereIn('id', $request->urls)
            ->where('is_blacklisted', $request->is_blacklisted)
            ->delete();

        return redirect()->route('websites.index', ['is_blacklisted' => $request->is_blacklisted])
            ->with('success', 'Đã xóa URL khỏi ' . ($request->is_blacklisted == self::BLACKLISTED ? 'Blacklist' : 'Whitelist') . '!');
    }

    // ==================== CHECK URL ====================
    public function check(Request $request)
    {
        $request->validate([
            'url' => 'required|url',
            'is_blacklisted' => 'required|in:' . self::WHITELISTED . ',' . self::BLACKLISTED,
        ]);

        $exists = Website::where('url', $request->url)
            ->where('is_blacklisted', $request->is_blacklisted)
            ->exists();

        return response()->json([
            'is_blacklisted' => $exists,
        ]);
    }

    // ==================== PRIVATE METHODS ====================
    private function validateStoreRequest(Request $request)
    {
        $request->validate([
            'url' => 'required|string|unique:websites,url',
            'is_blacklisted' => 'required|in:' . self::WHITELISTED . ',' . self::BLACKLISTED,
            'reason' => 'nullable|string|max:255',
        ]);
    }

    private function validateUpdateRequest(Request $request, Website $website)
    {
        $request->validate([
            'url' => 'required|string|unique:websites,url,' . $website->id,
            'reason' => 'nullable|string|max:255',
        ]);
    }

    private function validateDestroyRequest(Request $request)
    {
        $request->validate([
            'urls' => 'required|array',
            'is_blacklisted' => 'required|in:' . self::WHITELISTED . ',' . self::BLACKLISTED,
        ]);
    }

    private function removeOppositeType($url, $isBlacklisted)
    {
        Website::where('url', $url)
            ->where('is_blacklisted', $isBlacklisted == self::BLACKLISTED ? self::WHITELISTED : self::BLACKLISTED)
            ->delete();
    }

    private function createWebsite($url, $isBlacklisted, $reason)
    {
        Website::create([
            'url' => $url,
            'is_blacklisted' => $isBlacklisted,
            'reason' => $isBlacklisted == self::BLACKLISTED ? $reason : null,
        ]);
    }
}
