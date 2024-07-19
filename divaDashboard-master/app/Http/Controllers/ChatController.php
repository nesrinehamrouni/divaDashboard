<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\User;

class ChatController extends Controller
{
    public function createConversation(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $currentUser = Auth::user();
        $otherUser = User::findOrFail($request->user_id);

        $conversation = Conversation::firstOrCreate([
            'user1_id' => min($currentUser->id, $otherUser->id),
            'user2_id' => max($currentUser->id, $otherUser->id),
        ]);

        return response()->json(['conversation_id' => $conversation->id], 201);
    }

    public function sendMessage(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'content' => 'required|string',
            'message_type' => 'required|in:text,audio,image,file',
        ]);

        $currentUser = Auth::user();
        $conversation = Conversation::findOrFail($request->conversation_id);

        // Check if the current user is part of the conversation
        if ($conversation->user1_id !== $currentUser->id && $conversation->user2_id !== $currentUser->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $message = new Message([
            'conversation_id' => $conversation->id,
            'sender_id' => $currentUser->id,
            'content' => $request->content,
            'message_type' => $request->message_type,
        ]);

        $message->save();

        // If there's an attachment, handle it here
        if ($request->hasFile('attachment')) {
            // Implement file upload and create an Attachment record
        }

        return response()->json(['message' => 'Message sent successfully'], 201);
    }

    public function getConversations()
    {
        $currentUser = Auth::user();
        $conversations = Conversation::where('user1_id', $currentUser->id)
            ->orWhere('user2_id', $currentUser->id)
            ->with(['user1', 'user2'])
            ->get();

        return response()->json($conversations);
    }

    public function getMessages(Request $request, $conversationId)
    {
        $currentUser = Auth::user();
        $conversation = Conversation::findOrFail($conversationId);

        // Check if the current user is part of the conversation
        if ($conversation->user1_id !== $currentUser->id && $conversation->user2_id !== $currentUser->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $messages = Message::where('conversation_id', $conversationId)
            ->with('sender')
            ->orderBy('sent_at', 'asc')
            ->get();

        return response()->json($messages);
    }
}
