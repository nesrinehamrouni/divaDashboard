<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Conversation;
use App\Models\User;

class ConversationController extends Controller
{
    // public function index()
    // {
    //     $user = Auth::user();
    //     $conversations = Conversation::where('user1_id', $user->id)
    //         ->orWhere('user2_id', $user->id)
    //         ->with(['user1', 'user2', 'lastMessage'])
    //         ->latest('updated_at')
    //         ->get();

    //     return response()->json($conversations);
    // }
    public function index()
    {
        $user = Auth::user();
        $conversations = Conversation::where('user1_id', $user->id)
            ->orWhere('user2_id', $user->id)
            ->with(['user1', 'user2', 'lastMessage'])
            ->latest('updated_at')
            ->get()
            ->map(function ($conversation) use ($user) {
                $otherUser = $conversation->user1_id == $user->id ? $conversation->user2 : $conversation->user1;
                return [
                    'id' => $conversation->id,
                    'user' => [
                        'id' => $otherUser->id,
                        'prenom' => $otherUser->prenom,
                        'nom' => $otherUser->nom,
                        'profile_image' => $otherUser->photo ?? 'default_photo_url', // Provide a default if no photo
                    ],
                    'last_message' => [
                        'content' => $conversation->lastMessage 
                            ? (strlen($conversation->lastMessage->content) > 22 
                                ? substr($conversation->lastMessage->content, 0, 22) . '...' 
                                : $conversation->lastMessage->content)
                            : 'No messages yet',
                        'time' => $conversation->lastMessage ? $conversation->lastMessage->sent_at : null,
                    ],
                    'unread_count' => $conversation->messages()
                        ->where('read', false)
                        ->where('user_id', '!=', $user->id)
                        ->count(),
                ];
            });

        return response()->json($conversations);
    }
  
    public function show(Conversation $conversation)
    {
        $user = Auth::user();
        if (!$this->isUserInConversation($user, $conversation)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $conversation->load(['user1', 'user2', 'messages' => function ($query) {
            $query->latest()->limit(20);
        }]);

        return response()->json($conversation);
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