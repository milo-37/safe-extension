<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-2xl text-green-400 tracking-wide leading-tight">
            ✏️ {{ __('Chỉnh sửa Tiêu chí') }}
        </h2>
    </x-slot>

    <div class="min-h-screen bg-gray-900 text-white py-12">
        <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
            <div class="relative bg-gray-800 shadow-xl sm:rounded-lg p-6 border border-green-500">

                <!-- Hiệu ứng nền -->
                <div class="absolute inset-0 bg-green-500 opacity-10 blur-lg rounded-lg"></div>

                <h2 class="text-2xl font-bold mb-6 text-green-400 flex items-center relative">
                    <span class="mr-2">🔧 Chỉnh sửa Tiêu chí</span>
                    <span class="text-sm bg-yellow-600 px-3 py-1 rounded-md shadow-md">Cập nhật thông tin</span>
                </h2>

                <!-- Hiển thị thông báo lỗi -->
                @if ($errors->any())
                <div class="relative mb-4 p-4 bg-red-500 border border-red-700 text-white rounded-lg">
                    <ul class="list-disc pl-5">
                        @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
                @endif

                <form action="{{ route('criteria.update', $criteria->id) }}" method="POST" class="relative space-y-6">
                    @csrf
                    @method('PUT')

                    <!-- Input Loại Tiêu chí -->
                    <div>
                        <label for="type" class="block text-sm font-medium text-green-300">🌐 Loại Tiêu chí:</label>
                        <input type="text" name="type" id="type"
                            class="w-full mt-1 p-3 bg-gray-700 text-white border border-green-500 rounded-lg shadow-sm focus:ring focus:ring-green-500 focus:outline-none"
                            required value="{{ old('type', $criteria->type) }}" placeholder="Nhập loại tiêu chí">
                    </div>

                    <!-- Input Từ khóa -->
                    <div>
                        <label for="keywords" class="block text-sm font-medium text-green-300">📝 Từ khóa:</label>
                        <input type="text" name="keywords" id="keywords"
                            class="w-full mt-1 p-3 bg-gray-700 text-white border border-green-500 rounded-lg shadow-sm focus:ring focus:ring-green-500 focus:outline-none"
                            value="{{ old('keywords', implode(', ', json_decode($criteria->keywords))) }}" placeholder="Nhập từ khóa, ngăn cách bằng dấu phẩy">
                    </div>

                    <!-- Nút bấm -->
                    <div class="flex space-x-4 mt-6">
                        <button type="submit"
                            class="px-6 py-3 bg-yellow-600 hover:bg-yellow-700 transition text-white font-semibold rounded-lg shadow-lg">
                            🔄 Cập nhật
                        </button>
                        <a href="{{ route('criteria.index') }}"
                            class="px-6 py-3 bg-gray-500 hover:bg-gray-600 transition text-white font-semibold rounded-lg shadow-lg">
                            🔙 Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>
