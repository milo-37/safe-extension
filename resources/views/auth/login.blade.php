<x-guest-layout>
    <div class="min-h-screen flex items-center justify-center bg-gray-900 text-white">
        <div class="w-full max-w-md p-8 space-y-6 bg-gray-800 rounded-lg shadow-xl border border-gray-700">
            <!-- Logo -->
            <div class="flex justify-center">
                <x-authentication-card-logo class="w-20 h-20 text-green-400" />
            </div>

            <h2 class="text-center text-2xl font-extrabold tracking-wide text-green-400">
                🔐 Secure Login
            </h2>

            <!-- Hiển thị lỗi -->
            <x-validation-errors class="mb-4 text-red-400" />

            @if (session('status'))
                <div class="mb-4 font-medium text-sm text-green-400">
                    {{ session('status') }}
                </div>
            @endif

            <!-- Form đăng nhập -->
            <form method="POST" action="{{ route('login') }}" class="space-y-6">
                @csrf

                <div>
                    <x-label for="email" value="{{ __('Email') }}" class="text-green-300 font-semibold" />
                    <x-input id="email" class="block mt-1 w-full bg-gray-700 text-white border border-gray-600 focus:ring-green-500 focus:border-green-500 rounded-lg shadow-md p-3" 
                        type="email" name="email" :value="old('email')" required autofocus autocomplete="username" placeholder="Nhập email của bạn" />
                </div>

                <div>
                    <x-label for="password" value="{{ __('Password') }}" class="text-green-300 font-semibold" />
                    <x-input id="password" class="block mt-1 w-full bg-gray-700 text-white border border-gray-600 focus:ring-green-500 focus:border-green-500 rounded-lg shadow-md p-3"
                        type="password" name="password" required autocomplete="current-password" placeholder="Nhập mật khẩu" />
                </div>

                <!-- Ghi nhớ đăng nhập -->
                <div class="flex items-center">
                    <input id="remember_me" name="remember" type="checkbox" class="h-4 w-4 text-green-500 focus:ring-green-500 border-gray-600 bg-gray-700 rounded">
                    <label for="remember_me" class="ml-2 text-sm text-gray-300">
                        {{ __('Remember me') }}
                    </label>
                </div>

                <!-- Nút Đăng nhập & Quên mật khẩu -->
                <div class="flex items-center justify-between">
                    @if (Route::has('password.request'))
                        <a class="text-sm text-green-400 hover:text-green-300 transition duration-300" href="{{ route('password.request') }}">
                            {{ __('Forgot your password?') }}
                        </a>
                    @endif

                    <button type="submit" class="px-6 py-3 bg-green-500 hover:bg-green-600 transition text-white font-semibold rounded-lg shadow-lg">
                        🚀 {{ __('Log in') }}
                    </button>
                </div>
            </form>

            <!-- Hiệu ứng hacker -->
            <div class="mt-6 text-center text-sm text-gray-500">
                ⚠️ Bảo vệ tài khoản của bạn. Không chia sẻ mật khẩu với ai! 🔒
            </div>
        </div>
    </div>
</x-guest-layout>
