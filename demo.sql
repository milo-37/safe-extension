-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th5 13, 2025 lúc 03:33 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `demo`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `blacklist_websites`
--

CREATE TABLE `blacklist_websites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `blacklist_websites`
--

INSERT INTO `blacklist_websites` (`id`, `url`, `reason`, `created_at`, `updated_at`) VALUES
(11, 'https://24h.com.vn', NULL, '2025-03-23 07:20:09', '2025-03-23 07:20:09');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `criteria`
--

CREATE TABLE `criteria` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `keywords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`keywords`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `criteria`
--

INSERT INTO `criteria` (`id`, `type`, `keywords`, `created_at`, `updated_at`) VALUES
(1, 'SCAM_KEYWORDS', '\"[\\\"tr\\\\u00fang th\\\\u01b0\\\\u1edfng\\\",\\\"  ki\\\\u1ebfm ti\\\\u1ec1n nhanh\\\",\\\"  x\\\\u00e1c minh t\\\\u00e0i kho\\\\u1ea3n ngay\\\",\\\"  mua\\\"]\"', '2025-03-27 09:51:48', '2025-03-31 07:11:43'),
(2, 'ADULT_KEYWORDS', '\"[\\\"xxx\\\",\\\" sex\\\"]\"', '2025-03-27 10:23:52', '2025-03-30 21:08:26'),
(3, 'BAD_COUNTRY_TLDS', '\"[\\\".ru\\\",\\\".cn\\\",\\\".kp\\\",\\\".ir\\\",\\\".sy\\\",\\\".online\\\",\\\".store\\\",\\\".xyz\\\",\\\".tk\\\",\\\".cc\\\",\\\".ml\\\",\\\".ga\\\",\\\".cf\\\",\\\".gq\\\",\\\".ru\\\",\\\".pw\\\",\\\".to\\\",\\\".party\\\",\\\".top\\\",\\\".buzz\\\",\\\".club\\\",\\\".club\\\",\\\".win\\\",\\\".work\\\",\\\".website\\\",\\\".click\\\",\\\".host\\\",\\\".space\\\",\\\".fun\\\",\\\".co\\\",\\\".party\\\",\\\".money\\\",\\\".life\\\",\\\".pro\\\",\\\".site\\\",\\\".vip\\\",\\\".bid\\\",\\\".icu\\\",\\\".link\\\"]\"', '2025-03-31 07:09:16', '2025-03-31 07:09:16'),
(4, 'FAKE_ALERTS', '\"[\\\"m\\\\u00e1y t\\\\u00ednh c\\\\u1ee7a b\\\\u1ea1n b\\\\u1ecb nhi\\\\u1ec5m virus\\\",\\\" b\\\\u1ea5m v\\\\u00e0o \\\\u0111\\\\u00e2y \\\\u0111\\\\u1ec3 s\\\\u1eeda l\\\\u1ed7i\\\"]\"', '2025-03-31 07:10:20', '2025-04-03 07:26:37'),
(5, 'HATE_KEYWORDS', '\"[\\\"hate\\\",\\\" kill\\\",\\\" nazi\\\"]\"', '2025-03-31 07:10:40', '2025-04-03 07:26:52'),
(6, 'FAKE_MEDICAL_KEYWORDS', '\"[\\\"ch\\\\u1eefa b\\\\u00e1ch b\\\\u1ec7nh\\\",\\\" thu\\\\u1ed1c th\\\\u1ea7n k\\\\u1ef3\\\",\\\" tr\\\\u1ecb ung th\\\\u01b0\\\"]\"', '2025-03-31 07:11:01', '2025-04-03 07:27:09'),
(7, 'MALICIOUS_ADS', '\"[\\\"pop-up\\\",\\\" popup\\\",\\\" qu\\\\u1ea3ng c\\\\u00e1o kh\\\\u00f4ng th\\\\u1ec3 t\\\\u1eaft\\\"]\"', '2025-03-31 07:11:20', '2025-04-03 07:27:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2014_10_12_200000_add_two_factor_columns_to_users_table', 1),
(4, '2019_08_19_000000_create_failed_jobs_table', 1),
(5, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2025_03_17_140548_create_sessions_table', 1),
(7, '2025_03_17_141855_create_blacklist_websites_table', 2),
(12, '2025_03_18_142101_create_whitelist_websites_table', 3),
(13, '2025_03_27_160752_create_criteria_table', 3),
(15, '2025_04_01_090952_create_websites_table', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('1CUAth23YQ4KchaseZoY8hObOeCPftYv3MGAHFAQ', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicm84UHlQUzN2TTN2cFNoSlJiTVdkWTAwV1BqcGxHbmtyUjkyaGszZSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0wJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072587),
('2GrZpEI7DpaUTsIoUeU0QBqDyj2T9CWee0J3yJbu', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZVJudjJtNGNOa1ZLTElOMDBydmUwQ3RSS0xCV0NBWG84NGdjSUoxbSI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MjtzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjIxOiJwYXNzd29yZF9oYXNoX3NhbmN0dW0iO3M6NjA6IiQyeSQxMCRNbHNHd3I3RnRlelAuRnJ4Z3BLa0RPd2hWU3pHbDR1eDBGVW15WHg2dnJUaXVabXoudWJ4NiI7fQ==', 1747142607),
('2jIgsDIH7d7QRogbTTPonaY99Iv0KuG1PgJriS58', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoieHZhYmpJS3M1SHl4MktweXpQamQ2bGw0VEh5Wmo3emhoRk1Jem1WdCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzL2NyZWF0ZT9pc19ibGFja2xpc3RlZD0wIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcy9jcmVhdGU/aXNfYmxhY2tsaXN0ZWQ9MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072359),
('4qVW04504SViAjes8EDCgD42ouJoYPzwB1kU2AFX', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiU1hhVzRMYnExeWY2QlFualYyNnF0SUpDQkNFRTBOcE4xMDROWWRHeSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747070977),
('4Wkjn6hwCdq3kna54T9Yr0qBmxeysGEaPzoBIaA4', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoibk9TcW5WV3pxcDlaSGhtOEt6aVhNc2dHb3p3TzUzSk9zWWxreDNONyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzkyL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzkyL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073004),
('77Teb72pEUV1A1oqslxPWG0eVF28Nlr9I45R8zdY', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoieVhLcjBLR3h0MjFMd3JRUUdXNWhiYng0cWpmY1REM3JJMEVUTkl1bCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072944),
('9lZ6YIgWo1uCzkd8aWquWl833B8joINRoMmsjhAe', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiM1V4MGhRRFdndkkzYkxzV2VRWU5NYTh5dncwOEY2U0U3Q3JWekdNRSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747070989),
('9NcYMces4U8BGpGUDrmUVj679UeZzCLcl3GV6XwH', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSTZkM0JmUFRyZDdWWVNvdnFPQTk0TlFVN29NWWJJdGJDTDUwYjlqbCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747070989),
('9rLtSjunIfSTmphRU8E3Yi63c6GHZ4YsvyUZ6JlC', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMmJkYTFKbkx1WHgyWGd4cGw1WmVWdjBZZzd1RVRDZUdPYzhtRnh6bCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747131311),
('BZbhtypZ9P691d68PTB71MWCddoje6LJLJ3kFKgb', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiQ0pyR1ZiVWE0MEN6R214QnlnUEk0bnJEYmQyWjU0WTBEQkR2eE9zQiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc3L2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc3L2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072398),
('cDQxHcDygNUmEXqeddqDCtZlViptq8gY2rQNujDi', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVnVlY2pGeGpLQkQxWk93ZVRacFJIZ3lCMWNiZm5jbUZ4b3A2dDlZbCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747131262),
('d0s9XFtSLa5918eNPHQL0ugiGo0ZEOlgX4vcuCLR', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR1RieVd2RlZIRURWWVc0RDBwM3lISUF6TFF5Q3pOeWRSb3oyREVNYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747142564),
('D8DN3EuobAHNK5jY2nrMU4DdMydL7ACnpXEbs9yz', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRWdWeTVBVFJhMlBYVVNjb2pKcXhRTlJNc3hETFlDejM3ejJZeFVpZCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072380),
('dI9d0LrNBlnXiJe3OxBXzy5I0yFf5Sm3nIE37Jk3', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOE9Gd3doaTNKNjNnRENsTnNhcWJ1cFhaYWR0NUdIOVJmUXR6d2FLaSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747142607),
('f9ojmYhKCVoWTWyPLXMu0tmqSaDZcgwArlFabfmk', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRjN4cEVzaGVDTHdEaDRRVWJ1MllrZGpwM2dpNVdvbEFWRFpqVUtBMCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072172),
('Gky0iWkURGztS1pnDfRVkPQwO1onf2vq05gn7fEu', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRG1rS25DcEpUeEZhZmZUVjh4UXdobFFkQ3kyaEpjNE10WkhqaDI2TiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747131299),
('gX5W6hGZ8qEOkDEEwcUTlann75ro0hEFiMU4XyKe', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVR5dWI5d0F6QldjeVZIUXBDOXJ0OGVrNk9FOXFlSjNGRTVxdXJadSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747142564),
('hqjONCEMlriEt44173y902Hdy9MVjTjoL7EBnYqN', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiclZPQWt3V3ZsanEwUTY2ZDFHMXllS3VjQVptdTdaVGpjWDhtdGpLbyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzL2NyZWF0ZT9pc19ibGFja2xpc3RlZD0xIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcy9jcmVhdGU/aXNfYmxhY2tsaXN0ZWQ9MSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072963),
('j2JIRz3bWmyhP6UzTrHsjx2sB9qDfBcCKgGZ7Mej', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiUzlvWkRqQzc0VERZWlMyR3dBemQzeUQ4U1ZlM3RNNzExem9qTHo0WiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747071292),
('jkfrkRg6UQSjtzJz9yXyK2n9rE5u8ullmb46dev5', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiU0dYaXdUM3VtdmQ5ZGQ5bEtDaTg5TWMzeGJMOUlaQTNRSzVZNVFBTSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzgwL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzgwL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072622),
('jMhCNWAx3T2x5CL0NNnsyUK89eEmsuvohLeUXL9e', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVm9xOUtyWjQzM0tpNFJucXdEQ0hBazMxUmFSelF0UkR2TDVJRThuTSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzYyL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzYyL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073113),
('JQ8ebVjLQ60on83qyZ3tEIiWHBxFvWKpDN7w4P4I', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoibldKQ08wTXhkTUROSlpjVUtrbzk4VDdKT2hjY3dOZmV0TVg3WGZ0MiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzkyL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzkyL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073004),
('l8hkDYNxDUBdZ4spuoMnxcEqgKdZTroigHiJeJSs', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiQ29jVHgzWnM4SVl6Z3VwY01nZFRGOGtDMUE1OU92a0VRNEhWUmJJVyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzL2NyZWF0ZT9pc19ibGFja2xpc3RlZD0wIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcy9jcmVhdGU/aXNfYmxhY2tsaXN0ZWQ9MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072359),
('LFbk2lHOlbrBqUgTbt2l5UNH8o2GtzICXHaDsXIa', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOWVPbHVTZ09GMlp6dlAwYnJMVWJGYWJFczlmZHpYT2hxQlB4MzlLSiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747142607),
('Li6a2m5Vzzy9ZUtOaeomeGWqRsqFE0TDmKr26BeT', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVUIzY1B0dThFVzJjbDlVNkZrSnBQZ0RmZTAxUG93b0s3RVNJQ2NtVSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747131262),
('LNFzLfoQ8qn35iSfD8uMRVU3VLAFgnE0INQ4WQpZ', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiN2JVMDF6c1hTc09vTEZYUWFNYVBsY3BEa2lmb29ZV1ZDaDhNaUoySCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072944),
('MxIgJ4ZsvTCUNHUsSJtx2R8RTjNTRjTTKNQ6qLaD', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoib01RakVrQXp6RnhnZGRKekhwT2hXSHdvRVhFN01WcmNiYjFjYzdOUyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747142586),
('n6INn1bXdSD7QOXPbflycnNqwsDPkB9LEW2NxpJj', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRDJwT2ZWQ3JMQmIxR1ppdjlxV3RKRXJ4Z3JqcDcwa0ppaGJkS0ppNiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzYyL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzYyL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073114),
('nEhB68Sn1pknZsjVLYt5Xyt7wOvhuH9hEeevE6gM', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTFZRb2oyN1dBVmNndmtoaVozSkZCcFdpME5ZV0ZZS3Z2SGRVSWRoMyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073153),
('NnW1bj6f0XxRxSfnMaVPhIE9nuo9crv3UiwJ4IsW', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiazRuZ2RLTmFKa09RZHVLRTMzSTFJdE9RYXIzNjZ6a2N6VjhuQkhhaiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc4L2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc4L2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073163),
('nTqYNrJ6HROWJG15YkmwU64Z4n8Kzc6kmxszHXGa', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiY1Q3YTlIV21ySG5TNlRzclZBU0ZHeklzaXN1QmRvVlRvdnpMak8xSSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747142586),
('OaCXnwmHJYL2aYlvws4XvYy1ZqzxfMEcBaftWpCC', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiV2g3MExnTlY2OTFMSWNpOWVoUW9FMngwbDl3aUJQdjkydWxkRkkwYyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzL2NyZWF0ZT9pc19ibGFja2xpc3RlZD0xIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcy9jcmVhdGU/aXNfYmxhY2tsaXN0ZWQ9MSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072964),
('Oer0IwEEF9D1Ip6gy3f6TU6RaXjQHFZnpPTyldL7', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZmM0T0tpZjlLN3lXdm1nUE1hYU1XVG5xenJHdTNrWlh4YnI4T0EwZSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073101),
('oETN1j8jjNiNHSH07V4Qtvl7aVeuMlQ5sFLfeuoP', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoieGFWcEtENmYwbGJETXJqYVpCdVRnTTNoVkEzU3UyZlZES0FKSzM0bSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc4L2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc4L2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073163),
('ofTcENTDSO2FQONZ3OWVHg5E9BizA7mYUf2tRgEM', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoid3hBWkpWSGw0SzliOXlKQlpKZHRsTmRXWlRWOGpDUzJ4S094OXR4YSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747071292),
('P5X9UKrTzIVfGlaP5JdYlPrsSDFbWYdP8dVqrJha', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT1VTZEJ1MVM5MDA5WHcyYmNnNW55T085bkxtZFNWQmZXT1BnRmMzNyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747131251),
('Q08Zp9BGl7FEQ5yXcIJYyphVvwInqP0tGY9JsPho', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMklxZ3hYcDZwNlRrU1lpZjBYcTI1UXRWT2FKaHdzOE9LUlZESnB5RyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747070978),
('Qkfu1hZODRA3NwOs3Uk6iQFJk4eNYPeeFA5iao2c', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTnhUZ0lHY2lDQzNiTkhMRlNZaGQwVUh5dVJIV2cwVUM4cWhtQU9hMyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747142628),
('RsyuxWrBNJP0bl25l4HP99H4Ck84yjwe977zlxwG', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicWwwQ25oYWVPTkhlcWF6ZjBVVlVXczNoMm1XQnhKc0l6S3BOSnd1ZyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0xIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072954),
('sE53HbIYFDaxI1q1OkpGBkqoq6oJGT5JEgRdIfIf', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiQ003M1FOa2VDTE9lMlVzb2RTeHFsOUVRcFFGT0RkaUd1RTVUMlo5biI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072380),
('sK2WCObrS2j2aV9xpkqpPeReVQQQFC9mDVeIJWBe', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoic2NDbVhzOWZTNEZPUjdYc2puRmF2NWZBMEw5SEJnM2RVaHdLUEdqciI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747073123),
('t0dWOkDBJBulsCD6SDuhTAVFn7mH4C6HSwlOUq0I', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZGE3aG9ldEprOUUzdTJkd040Vm01aEtCbHE4aVppSUxncWVYZUloRyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072172),
('TxUqaq2yhJ7hiZN1Yhcd94IX4DfLrlwMHjFHQKvx', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiajRZajFRYlVrQXBmN0hUME5jcnN2ZDgzSDNjZnppWFU4cEhMbTdociI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747073123),
('tyjU10nxnasRzLCSppbRrk2LitGwIyytiBijyAgG', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZktJNFhaSFk2UThnSHZtM0s2ZFNhWU5wc0MzekRqOTY0OHo4MmRDbSI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MjtzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjIxOiJwYXNzd29yZF9oYXNoX3NhbmN0dW0iO3M6NjA6IiQyeSQxMCRNbHNHd3I3RnRlelAuRnJ4Z3BLa0RPd2hWU3pHbDR1eDBGVW15WHg2dnJUaXVabXoudWJ4NiI7fQ==', 1747131300),
('tyNQMF8RrYwA079JUHYQGnVJn37tV3kA2kSO6hJ9', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNkg0TVlOd0JNbWZOMDcyRGg1RzI3WnUxNHM5REYxbjl0VExFaDBzcSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAmcGFnZT0yIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0wJnBhZ2U9MiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072587),
('uy2ab8oHtGoV6E3164SeLjZ9hWZtCzYaKj7e7aeP', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRDBsQ25nSEQ1V0d5dGJxREM0ZWptZTFZeUx3b2VXNExNaEQ1VDRDVCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072410),
('VXDKOuUWEwFHU7kaaDMQaHeNGRUTGWcrygH2vo7W', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZDFLazlzWm1EVjAxQVZoSlRYZ0FoOWxOQ1JzWjY5UldnWDBaNFVSbyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747131299),
('Vz6hruHMkP1BYSuHombSyoNmxIve3gT8E04pT7FA', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiUXQ2WjNIRks5MVlvaTNYMWhIQTdLcHVhenlZN2ptQzhNVWUwOGoyYiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747071171),
('WeTNARxv1psqJImvZJJ6yy9ocFdinl74Y5ydYDra', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiUnNtMEVtZTZ2UEtnVE03OGtuMmI2Z3V5NEl0b0JMeWRIZHJDT1kwSyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2Rhc2hib2FyZCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjMxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1747071172),
('wqpEmJ2k6CZTFCnbOI5dEhYzPBYwjdBrDRKGoOtL', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicEl1c2NEdzZHWTNlN2RZQVpqRnRJNmhKeDRGWlRLOG9oa2s4QmtsWSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073101),
('WTNxXYnJ5y7vf5daLs5LUs4xeTyJRQLNpJkBpoRf', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoib0RjbDVjeWVyeWt0dDhGbUJoT3dBUThjUGtVaE1JVzRyUUJTN0VDWSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc3L2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzc3L2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072398),
('Y5EcPqaxefaePM90ZXXzPSbnHpDUxdU5W6HQouxr', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVUJmajVaY2luMU9Id3NtUkEwM200dHpGbG5mTzFHeU5xMW1jM0c2cSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747073153),
('yahOg7JbnEiFgS5fqJimbL2kL30nBAblEnetxD1t', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiYUJvSTN2WWVGd2N2TzdndnJwWUpXZnlDMmNmWmZ1UE5oTks2OFJ4cSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747142628),
('YLUyvcII7dhwNDdiO5JsqEdF4bvLImGCpqZri6iC', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNmdFRVRIbHg2bUtQWFdKTGxpZzBWNEt5NDFwc0RCWjh3RW8xM1Q5eSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072411),
('YsPpSVgKAQ9aQUxeQpQ5xc4UW0ZD4m6nAE0wd5zL', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0JpbG0wVVdRNEVrdFlqbEZiVVBUcjA1dG5scmtIb213d0xzTnpMUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747131247),
('yWCnm5DaYhwPXZIehtEMVzksWudjHZ6x4BexN8fk', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoicFVGZ3V2MkV5bWJuVzJORUUxMEllU0g4aGJkNVdNYVdUUzRCS1NWciI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1NDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEmcGFnZT0xIjt9czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC93ZWJzaXRlcz9pc19ibGFja2xpc3RlZD0xJnBhZ2U9MSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747072954),
('yzrXXkvUvDBEGHmfzVCg2BrKJW0w9IsN4xjbwLmb', NULL, '127.0.0.1', 'python-requests/2.32.3', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMU5KaDNzR21MMEt2enFlcG91Skx0VjFTUWMyUUNtRFRsbVVmbWFSViI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzgwL2VkaXQiO31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzLzgwL2VkaXQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1747072622),
('z3jVhOFCroSsbtFioHHLYwz06h1bcc2kzD2KjY6t', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoidXg1Vmxsbk5CaXY5Y0hhMGY4WFRPNG1HUWRsZ0J6ZUNBRk5Hc2hHWSI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MjtzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czo0NzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3dlYnNpdGVzP2lzX2JsYWNrbGlzdGVkPTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjIxOiJwYXNzd29yZF9oYXNoX3NhbmN0dW0iO3M6NjA6IiQyeSQxMCRNbHNHd3I3RnRlelAuRnJ4Z3BLa0RPd2hWU3pHbDR1eDBGVW15WHg2dnJUaXVabXoudWJ4NiI7fQ==', 1747073251);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `two_factor_secret` text DEFAULT NULL,
  `two_factor_recovery_codes` text DEFAULT NULL,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `current_team_id` bigint(20) UNSIGNED DEFAULT NULL,
  `profile_photo_path` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `current_team_id`, `profile_photo_path`, `created_at`, `updated_at`) VALUES
(1, 'Bui Tai', 'admin@gmail.com', NULL, '$2y$10$F0jBN59XRnfXUgyZcSYz3OSiK2M0bKhSS8sikD5vaoLgbL5wSG78i', NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-17 07:17:26', '2025-03-17 07:17:26'),
(2, 'Test', 'test@gmail.com', NULL, '$2y$10$MlsGwr7FtezP.FrxgpKkDOwhVSzGl4ux0FUmyXx6vrTiuZmz.ubx6', NULL, NULL, NULL, 'lo55Q5McnRqXrGutPoiwp8B2GKra3CMok6KVHPtEIoQIU4KU72pMElIFFqd7', NULL, NULL, '2025-03-17 19:25:28', '2025-03-17 19:25:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `websites`
--

CREATE TABLE `websites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL,
  `is_blacklisted` tinyint(1) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `websites`
--

INSERT INTO `websites` (`id`, `url`, `is_blacklisted`, `reason`, `created_at`, `updated_at`) VALUES
(61, 'https://www.youtube.com/', 0, NULL, '2025-05-11 21:06:09', '2025-05-11 21:06:09'),
(62, 'login-secure-update.com', 1, 'Giả mạo đăng nhập ngân hàng', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(63, 'winbig-prize-now.ru', 1, 'Trang trúng thưởng giả', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(64, 'paypal-alert-service.net', 1, 'Giả mạo PayPal', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(65, 'confirm-appleid.com', 1, 'Giả mạo Apple ID', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(66, 'verify-facebook-security.com', 1, 'Giả mạo Facebook', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(67, 'freemoney247.biz', 1, 'Lừa đảo tiền miễn phí', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(68, 'malicious-script.in', 1, 'Phát tán mã độc', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(69, 'cryptomining-virus.site', 1, 'Khai thác tiền ảo', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(70, 'lottery-prize-checker.info', 1, 'Trúng thưởng giả', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(71, 'bankofamerica-authenticate.net', 1, 'Giả mạo ngân hàng', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(72, 'support-amazon-resolve.com', 1, 'Giả danh Amazon', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(73, 'secure-verification-mail.net', 1, 'Phishing email', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(74, 'steamcommunity-security.ru', 1, 'Giả mạo Steam', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(75, 'untrustedcertificate.xyz', 1, 'Chứng chỉ không hợp lệ', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(76, 'vpnfree-download-now.top', 1, 'Phần mềm giả mạo chứa mã độc', '2025-05-12 16:40:41', '2025-05-12 16:40:41'),
(77, 'google.com/', 0, NULL, '2025-05-12 17:24:53', '2025-05-12 10:53:18'),
(78, 'microsoft.com', 0, 'Trang web chính thức của Microsoft', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(79, 'apple.com', 0, 'Trang chủ Apple', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(80, 'facebook.com/', 0, NULL, '2025-05-12 17:24:53', '2025-05-12 10:57:02'),
(81, 'amazon.com', 0, 'Website thương mại điện tử uy tín', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(82, 'bankofamerica.com', 0, 'Ngân hàng chính thức (real)', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(83, 'paypal.com', 0, 'Cổng thanh toán điện tử chính thống', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(84, 'github.com', 0, 'Nền tảng lưu trữ mã nguồn uy tín', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(85, 'stackoverflow.com', 0, 'Diễn đàn lập trình tin cậy', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(86, 'vnexpress.net', 0, 'Trang tin tức chính thống Việt Nam', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(87, 'moit.gov.vn', 0, 'Cổng thông tin Bộ Công Thương', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(88, 'wikipedia.org', 0, 'Bách khoa toàn thư mở uy tín', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(89, 'zalo.me', 0, 'Ứng dụng nhắn tin nội địa Việt Nam', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(90, 'tiki.vn', 0, 'Sàn thương mại điện tử nội địa đáng tin', '2025-05-12 17:24:53', '2025-05-12 17:24:53'),
(92, 'https://dantri.com.vn/', 1, NULL, '2025-05-12 11:02:51', '2025-05-12 11:07:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `whitelist_websites`
--

CREATE TABLE `whitelist_websites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `urls` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`urls`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `blacklist_websites`
--
ALTER TABLE `blacklist_websites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `blacklist_websites_url_unique` (`url`);

--
-- Chỉ mục cho bảng `criteria`
--
ALTER TABLE `criteria`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Chỉ mục cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Chỉ mục cho bảng `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Chỉ mục cho bảng `websites`
--
ALTER TABLE `websites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `websites_url_unique` (`url`);

--
-- Chỉ mục cho bảng `whitelist_websites`
--
ALTER TABLE `whitelist_websites`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `blacklist_websites`
--
ALTER TABLE `blacklist_websites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `criteria`
--
ALTER TABLE `criteria`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `websites`
--
ALTER TABLE `websites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT cho bảng `whitelist_websites`
--
ALTER TABLE `whitelist_websites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
