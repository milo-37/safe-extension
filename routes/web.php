<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BlacklistWebsiteController;
use App\Http\Controllers\WhitelistWebsiteController;
use App\Http\Controllers\CriteriaController;
use App\Http\Controllers\WebsiteController;
use App\Http\Controllers\AITrainingController;


/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::post('/admin/train-ai', [AITrainingController::class, 'train'])->name('train.ai');

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
])->group(function () {
    Route::get('/dashboard', function () {
        return view('dashboard');
    })->name('dashboard');
});

Route::middleware(['auth'])->group(function () {
    Route::resource('blacklist', BlacklistWebsiteController::class);
    Route::post('blacklist/check', [BlacklistWebsiteController::class, 'check'])->name('blacklist.check');
    Route::delete('blacklist/{blacklist}', [BlacklistWebsiteController::class, 'destroy'])->name('blacklist.destroy');


    Route::post('whitelist/check', [WhitelistWebsiteController::class, 'check'])->name('whitelist.check');
    Route::get('whitelist', [WhitelistWebsiteController::class, 'index'])->name('whitelist.index');
    Route::get('whitelist/create', [WhitelistWebsiteController::class, 'create'])->name('whitelist.create');
    Route::delete('whitelist/delete', [WhitelistWebsiteController::class, 'destroy'])->name('whitelist.destroy');
    // Route edit phải có query `?urls=...`
    Route::get('whitelist/edit', [WhitelistWebsiteController::class, 'edit'])->name('whitelist.edit');
    // Hỗ trợ cả PUT và POST
    Route::match(['POST', 'PUT'], '/whitelist/update', [WhitelistWebsiteController::class, 'update'])->name('whitelist.update');
    Route::post('whitelist/check', [WhitelistWebsiteController::class, 'check'])->name('whitelist.check');
    Route::post('whitelist', [WhitelistWebsiteController::class, 'store'])->name('whitelist.store');

    //Criteria
    Route::resource('criteria', CriteriaController::class);
    Route::get('criteria', [CriteriaController::class, 'index'])->name('criteria.index');
    Route::get('criteria/create', [CriteriaController::class, 'create'])->name('criteria.create');
    Route::post('criteria', [CriteriaController::class, 'store'])->name('criteria.store');
    Route::get('criteria/{id}/edit', [CriteriaController::class, 'edit'])->name('criteria.edit');
    Route::put('criteria/{id}', [CriteriaController::class, 'update'])->name('criteria.update');
    Route::delete('criteria/{id}', [CriteriaController::class, 'destroy'])->name('criteria.destroy');

    //Website Checker
    Route::get('/websites', [WebsiteController::class, 'index'])->name('websites.index');
    Route::get('/websites/create', [WebsiteController::class, 'create'])->name('websites.create');
    Route::post('/websites', [WebsiteController::class, 'store'])->name('websites.store');
    Route::get('/websites/{website}/edit', [WebsiteController::class, 'edit'])->name('websites.edit');
    Route::put('/websites/{website}', [WebsiteController::class, 'update'])->name('websites.update');
    Route::delete('/websites', [WebsiteController::class, 'destroy'])->name('websites.destroy');

    Route::post('/websites/check', [WebsiteController::class, 'check'])->name('websites.check');
});
