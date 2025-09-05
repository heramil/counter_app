<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CounterController;

Route::get('/health', fn () => ['ok' => true]);

Route::get('/counter', [CounterController::class, 'current']);
Route::apiResource('counters', CounterController::class);
Route::post('counters/{counter}/increment', [CounterController::class, 'increment']);
Route::post('counters/{counter}/decrement', [CounterController::class, 'decrement']);
Route::post('counters/{counter}/reset',     [CounterController::class, 'reset']);
