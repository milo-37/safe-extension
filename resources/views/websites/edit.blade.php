<x-app-layout>
    <x-slot name="header">
        <h2 class="text-xl font-bold text-yellow-400 tracking-wide">
            ✏️ Chỉnh sửa Website
        </h2>
    </x-slot>

    <div class="py-10 bg-gray-900 text-gray-100 min-h-screen">
        <div class="max-w-3xl mx-auto bg-gray-800 p-8 rounded-xl shadow-lg border border-yellow-500">
            <form method="POST" action="{{ route('websites.update', $website) }}">
                @csrf
                @method('PUT')

                <!-- URL -->
                <div class="mb-6">
                    <label for="url" class="block text-sm font-medium text-yellow-300 mb-1">🌐 Website URL</label>
                    <input type="text" name="url" id="url" required
                        value="{{ old('url', $website->url) }}"
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-yellow-400">
                    @error('url') <p class="text-red-400 text-sm mt-1">{{ $message }}</p> @enderror
                </div>

                <!-- Loại Website -->
                <div class="mb-6">
                    <label for="is_blacklisted" class="block text-sm font-medium text-yellow-300 mb-1">📁 Loại Website</label>
                    <select name="is_blacklisted" id="is_blacklisted"
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-yellow-400">
                        <option value="1" {{ old('is_blacklisted', $website->is_blacklisted) == 1 ? 'selected' : '' }}>Blacklist 🔒</option>
                        <option value="0" {{ old('is_blacklisted', $website->is_blacklisted) == 0 ? 'selected' : '' }}>Whitelist 🛡️</option>
                    </select>
                    @error('is_blacklisted') <p class="text-red-400 text-sm mt-1">{{ $message }}</p> @enderror
                </div>

                <!-- Lý do -->
                <div class="mb-6">
                    <label for="reason" class="block text-sm font-medium text-yellow-300 mb-1">✍️ Lý do</label>
                    <input type="text" name="reason" id="reason"
                        value="{{ old('reason', $website->reason) }}"
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-yellow-400">
                    @error('reason') <p class="text-red-400 text-sm mt-1">{{ $message }}</p> @enderror
                </div>

                <!-- Hành động -->
                <div class="flex justify-between items-center mt-8">
                    <a href="{{ route('websites.index', ['is_blacklisted' => $website->is_blacklisted]) }}"
                       class="text-sm text-gray-400 hover:text-yellow-400 transition">← Quay lại danh sách</a>
                    <button type="submit"
                        class="bg-yellow-600 hover:bg-yellow-700 text-white font-semibold px-6 py-2 rounded-lg shadow">
                        💾 Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</x-app-layout>
