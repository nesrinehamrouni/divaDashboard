<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Conversation;
use App\Models\Message;
use Illuminate\Support\Facades\Log; // Import the Log facade


class MessageController extends Controller
{
    public function index(Conversation $conversation)
    {
        $user = Auth::user();
        if (!$this->isUserInConversation($user, $conversation)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $messages = $conversation->messages()
            ->with(['sender', 'attachment'])
            ->latest()
            ->paginate(20);

        return response()->json($messages);
    }

    public function store(Request $request, Conversation $conversation)
    {

        Log::info('Auth check: ' . (Auth::check() ? 'Authenticated' : 'Not authenticated'));
    Log::info('User ID: ' . Auth::id());
        $user = Auth::user();
        if (!$this->isUserInConversation($user, $conversation)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'content' => 'required|string',
            'message_type' => 'required|in:text,audio,image,file',
        ]);

        $message = new Message([
            'conversation_id' => $conversation->id,
            'sender_id' => $user->id,
            'content' => $request->content,
            'message_type' => $request->message_type,
        ]);

        $message->save();

        // Update conversation's updated_at timestamp
        $conversation->touch();

        // Load the sender relationship
        $message->load('sender');

        // TODO: Implement real-time notification (e.g., using Pusher or WebSockets)

        return response()->json($message, 201);
    }

    private function isUserInConversation($user, $conversation)
{
  Log::info('Checking conversation access:');
  Log::info('User ID: ' . $user->id);
  Log::info('Conversation ID: ' . $conversation->id);
  Log::info('Conversation user1_id: ' . $conversation->user1_id);
  Log::info('Conversation user2_id: ' . $conversation->user2_id);

    $hasAccess = ($conversation->user1_id == $user->id) || ($conversation->user2_id == $user->id);
    Log::info('Has access: ' . ($hasAccess ? 'Yes' : 'No'));

    return $hasAccess;
}
}