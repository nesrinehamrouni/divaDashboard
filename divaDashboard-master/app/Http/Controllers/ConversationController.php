<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Conversation;
use App\Models\User;

class ConversationController extends Controller
{
    public function index()
{
    $user = Auth::user();

    // Check if user is authenticated
    if (!$user) {
        \Log::error('User not authenticated in ConversationController@index');
        return response()->json(['error' => 'Unauthorized'], 401);
    }

    try {
        $conversations = Conversation::where('user1_id', $user->id)
            ->orWhere('user2_id', $user->id)
            ->with(['user1', 'user2', 'lastMessage'])
            ->latest('updated_at')
            ->get();

        return response()->json($conversations);
    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}


public function show(Conversation $conversation)
{
    $user = Auth::user();

    if (!$user) {
        return response()->json(['error' => 'Unauthorized'], 401);
    }

    if (!$this->isUserInConversation($user, $conversation)) {
        return response()->json(['error' => 'Unauthorized'], 403);
    }

    try {
        $conversation->load(['user1', 'user2', 'messages' => function ($query) {
            $query->latest()->limit(20);
        }]);

        return response()->json($conversation);
    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}
public function __construct()
    {
        $this->middleware('auth:sanctum');
    }


    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $currentUser = Auth::user();
        $otherUser = User::findOrFail($request->user_id);

        if ($currentUser->id === $otherUser->id) {
            return response()->json(['error' => 'You cannot create a conversation with yourself'], 400);
        }

        $conversation = Conversation::firstOrCreate([
            'user1_id' => min($currentUser->id, $otherUser->id),
            'user2_id' => max($currentUser->id, $otherUser->id),
        ]);

        return response()->json($conversation->load('user1', 'user2'), 201);
    }

    private function isUserInConversation($user, $conversation)
    {
        return $conversation->user1_id === $user->id || $conversation->user2_id === $user->id;
    }
}