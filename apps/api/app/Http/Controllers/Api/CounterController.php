<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Counter;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class CounterController extends Controller
{   
    public function current()
    {
        $counter = Counter::firstOrCreate(['name' => 'default'], ['value' => 0]);
        return response()->json($counter);
    }

    public function index()
    {
        return response()->json(Counter::orderBy('id')->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'  => 'nullable|string|unique:counters,name',
            'value' => 'nullable|integer',
        ]);

        $counter = Counter::create([
            'name' => $data['name'] ?? 'counter_'.now()->timestamp,
            'value' => $data['value'] ?? 0,
        ]);

        return response()->json($counter, Response::HTTP_CREATED);
    }

    public function show(Counter $counter)
    {
        return response()->json($counter);
    }

    public function update(Request $request, Counter $counter)
    {
        $data = $request->validate([
            'name' => 'sometimes|string|unique:counters,name,'.$counter->id,
            'value' => 'sometimes|integer',
        ]);
        $counter->update($data);
        return response()->json($counter);
    }

    public function destroy(Counter $counter)
    {
        $counter->delete();
        return response()->noContent();
    }

    public function increment(Counter $counter)
    {
        $counter->increment('value');
        return response()->json($counter->refresh());
    }

    public function decrement(Counter $counter)
    {
        $counter->decrement('value');
        return response()->json($counter->refresh());
    }

    public function reset(Counter $counter)
    {
        $counter->update(['value' => 0]);
        return response()->json($counter);
    }
}   
