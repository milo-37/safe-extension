<x-app-layout>
    <x-slot name="header">
        <h2 class="text-xl font-bold text-cyan-400 tracking-wide">
            Danh sách {{ request('is_blacklisted', 1) == 1 ? 'Blacklist 🔒' : 'Whitelist 🛡️' }}
        </h2>
    </x-slot>

    <div class="py-10 bg-gray-900 text-gray-100 min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            {{-- Flash Messages --}}
            @if (session('success'))
            <div class="mb-6 bg-green-600 text-white p-4 rounded-lg shadow">
                {{ session('success') }}
            </div>
            @elseif (session('error'))
            <div class="mb-6 bg-red-600 text-white p-4 rounded-lg shadow">
                {{ session('error') }}
            </div>
            @endif

            {{-- Tabs --}}
            <div class="flex justify-between items-center mb-6">
            <div class="space-x-4">
    <a href="{{ route('websites.index', ['is_blacklisted' => 1]) }}"
        class="px-4 py-2 rounded-md text-sm font-medium 
        {{ request('is_blacklisted', 1) == 1 ? 'bg-red-600 text-white shadow' : 'bg-gray-700 text-gray-300 hover:bg-gray-600' }}">
        🔒 Blacklist
    </a>
    <a href="{{ route('websites.index', ['is_blacklisted' => 0]) }}"
        class="px-4 py-2 rounded-md text-sm font-medium 
        {{ request('is_blacklisted', 1) == 0 ? 'bg-green-600 text-white shadow' : 'bg-gray-700 text-gray-300 hover:bg-gray-600' }}">
        🛡️ Whitelist
    </a>
</div>

                <a href="{{ route('websites.create', ['is_blacklisted' => $isBlacklisted]) }}"
                    class="px-4 py-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded-md font-semibold shadow">
                    ➕ Thêm Website
                </a>
                
            </div>
<form method="GET" action="{{ route('websites.index') }}" class="mb-6 flex space-x-4">
    <input type="hidden" name="is_blacklisted" value="{{ $isBlacklisted }}">
    <input type="text" name="search" value="{{ request('search') }}"
           class="px-4 py-2 bg-gray-800 border border-cyan-600 rounded text-white w-1/3"
           placeholder="🔍 Tìm kiếm theo URL...">
</form>
            {{-- Danh sách --}}
            @if ($websites->count())
            <form method="POST" action="{{ route('websites.destroy') }}" onsubmit="return confirmDelete()">
                @csrf
                @method('DELETE')
                <input type="hidden" name="is_blacklisted" value="{{ $isBlacklisted }}">

                <div class="overflow-x-auto rounded-lg shadow border border-cyan-700">
                    <table class="min-w-full divide-y divide-gray-700">
                        <thead class="bg-gray-800 text-cyan-300">
                            <tr>
                                <th class="px-4 py-3 text-left text-sm">#</th>
                                <th class="px-4 py-3 text-left text-sm">🌐 URL</th>
                                
                                <th class="px-4 py-3 text-left text-sm">🚫 Lý do</th>
                                
                                <th class="px-4 py-3 text-left text-sm">☑️</th>
                                <th class="px-4 py-3 text-left text-sm">⚙️ Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="bg-gray-900 divide-y divide-gray-800">
                            @foreach ($websites as $index => $website)
                            <tr class="hover:bg-gray-800">
                                <td class="px-4 py-2">{{ $index + 1 + ($websites->currentPage() - 1) * $websites->perPage() }}</td>
                                <td class="px-4 py-2">{{ $website->url }}</td>
                                
                                <td class="px-4 py-2">{{ $website->reason }}</td>
                    
                                <td class="px-4 py-2">
                                    <input type="checkbox" name="urls[]" value="{{ $website->id }}"
                                        class="accent-cyan-600 scale-125">
                                </td>
                                <td class="px-4 py-2">
                                    <a href="{{ route('websites.edit', $website) }}"
                                        class="text-cyan-400 hover:text-cyan-300 underline font-medium">
                                        ✏️ Sửa
                                    </a>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>

                <button type="submit"
                    class="mt-4 bg-red-600 hover:bg-red-700 text-white font-semibold px-5 py-2 rounded-lg shadow">
                    🗑️ Xoá đã chọn
                </button>
            </form>

            {{-- Pagination --}}
            <div class="mt-6">
                {{ $websites->appends(['is_blacklisted' => $isBlacklisted])->links('pagination::tailwind') }}
            </div>
            @else
            <div class="bg-gray-800 text-center text-gray-400 p-6 rounded-lg shadow">
                Không có website nào trong {{ $isBlacklisted === 1 ? 'Blacklist 🔒' : 'Whitelist 🛡️' }}.
            </div>
            @endif
        </div>
    </div>

    {{-- JavaScript --}}
    <script>
        function confirmDelete() {
            return confirm('Bạn có chắc chắn muốn xóa mục đã chọn không?');
        }
    </script>
</x-app-layout>