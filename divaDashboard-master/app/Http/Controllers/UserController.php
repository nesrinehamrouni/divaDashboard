<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;


class UserController extends Controller
{
  public function getAllUsers()
  {
      $authUserId = Auth::id(); // Get the ID of the authenticated user
      Log::info('Authenticated user ID:', ['id' => $authUserId]);
  
      $users = User::select('id', 'prenom', 'nom', 'profile_image')
          ->where('id', '!=', $authUserId) // Exclude the current user
          ->get()
          ->map(function ($user) {
              return [
                  'id' => $user->id,
                  'prenom' => $user->prenom,
                  'nom' => $user->nom,
                  'profile_image' => $user->profile_image ?? 'default_profile_image_url',
              ];
          });
  
      // Log the final list of users
      Log::info('Users data:', $users->toArray());
  
      return response()->json($users);
  }
  
}