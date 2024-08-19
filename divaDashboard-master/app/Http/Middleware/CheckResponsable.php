<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckResponsable
{
    public function handle($request, Closure $next)
    {
        if (Auth::user()->role === 'responsable') {
            return response()->json(['message' => 'Access denied'], 403);
        }

        return $next($request);
    }
}
