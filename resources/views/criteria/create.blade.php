<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-2xl text-green-400 tracking-wide leading-tight">
            ➕ {{ __('Thêm Tiêu chí Mới') }}
        </h2>
    </x-slot>

    <div class="min-h-screen bg-gray-900 text-white py-12">
        <div class="max-w-5xl mx-auto sm:px-6 lg:px-8">
            <div class="relative bg-gray-800 shadow-xl sm:rounded-lg p-6 border border-green-500">

                <div class="absolute inset-0 bg-green-500 opacity-10 blur-lg rounded-lg pointer-events-none"></div>

                <h2 class="text-2xl font-bold mb-6 text-green-400">➕ Thêm Tiêu chí Mới</h2>

                <form action="{{ route('criteria.store') }}" method="POST">
                    @csrf
                    <div class="space-y-4">

                        <!-- Loại Tiêu chí -->
                        <div>
                            <label for="type" class="block text-sm font-medium text-green-300">Loại Tiêu chí</label>
                            <input type="text" name="type" id="type" class="w-full p-2 rounded-md shadow-md bg-gray-800 text-white border border-green-500" placeholder="Nhập loại tiêu chí" value="{{ old('type') }}" required>
                            @error('type')
                                <span class="text-red-500 text-sm">{{ $message }}</span>
                            @enderror
                        </div>

                        <!-- Từ khóa -->
                        <div>
                            <label for="keywords" class="block text-sm font-medium text-green-300">Từ khóa</label>
                            <input type="text" name="keywords" id="keywords" class="w-full p-2 rounded-md shadow-md bg-gray-800 text-white border border-green-500" placeholder="Nhập từ khóa, ngăn cách bằng dấu phẩy" value="{{ old('keywords') }}" required>
                            @error('keywords')
                                <span class="text-red-500 text-sm">{{ $message }}</span>
                            @enderror
                        </div>

                    </div>

                    <div class="mt-6 flex justify-between items-center">
                        <a href="{{ route('criteria.index') }}"
                            class="inline-flex items-center px-4 py-2 bg-gray-600 text-white rounded-md shadow hover:bg-gray-700">
                            ⬅️ Quay lại
                        </a>
                        <button type="submit"
                            class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-md shadow hover:bg-green-700">
                            ✅ Thêm Tiêu chí
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</x-app-layout>
