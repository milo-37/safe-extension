<x-app-layout>
    @php
        // Mặc định chọn Blacklist
        $selected = old('is_blacklisted', 1);
    @endphp

    <x-slot name="header">
        <h2 id="form-header" class="text-xl font-bold text-green-400 tracking-wide">
            {{ $selected == 1 ? 'Thêm Website vào Blacklist 🔒' : 'Thêm Website vào Whitelist 🛡️' }}
        </h2>
    </x-slot>

    <div class="py-10 bg-gray-900 text-gray-100 min-h-screen">
        <div class="max-w-3xl mx-auto bg-gray-800 p-8 rounded-xl shadow-lg border border-green-500">
            <form method="POST" action="{{ route('websites.store') }}" id="website-form">
                @csrf

                {{-- Chọn Blacklist hoặc Whitelist --}}
                <div class="mb-6">
                    <label for="is_blacklisted" class="block text-sm font-medium text-green-300 mb-1">
                        🔀 Loại Danh sách
                    </label>
                    <select name="is_blacklisted" id="is_blacklisted"
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-green-400">
                        <option value="1" {{ $selected == 1 ? 'selected' : '' }}>Blacklist 🔒</option>
                        <option value="0" {{ $selected == 0 ? 'selected' : '' }}>Whitelist 🛡️</option>
                    </select>
                </div>

                {{-- URL Website --}}
                <div class="mb-6">
                    <label for="url" class="block text-sm font-medium text-green-300 mb-1">🌐 Website URL</label>
                    <input type="text" name="url" id="url" required
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-green-400"
                        placeholder="https://example.com" value="{{ old('url') }}">
                    @error('url')
                        <p class="text-red-400 text-sm mt-1">{{ $message }}</p>
                    @enderror
                </div>

                {{-- Lý do chỉ hiển thị khi chọn Blacklist --}}
                <div class="mb-6" >
                    <label for="reason" class="block text-sm font-medium text-green-300 mb-1">🚫 Lý do (tùy chọn)</label>
                    <input type="text" name="reason" id="reason"
                        class="w-full px-4 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:ring-2 focus:ring-green-400"
                        placeholder="VD: Phát tán mã độc, phishing..." value="{{ old('reason') }}">
                    @error('reason')
                        <p class="text-red-400 text-sm mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <div class="flex justify-between items-center mt-8">
                    <a href="{{ route('websites.index', ['is_blacklisted' => $selected]) }}"
                       class="text-sm text-gray-400 hover:text-green-400 transition">← Quay lại danh sách</a>
                    <button type="submit"
                        class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-2 rounded-lg shadow">
                        💾 Lưu Website
                    </button>
                </div>
            </form>
        </div>
    </div>

    {{-- JavaScript để cập nhật tiêu đề và hiển thị/ẩn trường lý do ngay lập tức --}}
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const select = document.getElementById('is_blacklisted');
            const header = document.getElementById('form-header');

            function updateForm() {
                if (select.value === '1') {
                    header.textContent = 'Thêm Website vào Blacklist 🔒';
                    reasonContainer.style.display = '';
                } else {
                    header.textContent = 'Thêm Website vào Whitelist 🛡️';
                    reasonContainer.style.display = 'none';
                }
            }

            select.addEventListener('change', updateForm);
        });
    </script>
</x-app-layout>
