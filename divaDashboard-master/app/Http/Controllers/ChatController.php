<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\User;
use App\Models\Attachment;
use Illuminate\Support\Facades\Storage;

class ChatController extends Controller
{
    public function createConversation(Request $request)
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

        return response()->json(['conversation' => $conversation->load('user1', 'user2')], 201);
    }

    public function sendMessage(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'content' => 'required|string',
            'message_type' => 'required|in:text,audio,image,file',
            'attachment' => 'nullable|file|max:10240', // 10MB max file size
        ]);

        $currentUser = Auth::user();
        $conversation = Conversation::findOrFail($request->conversation_id);

        if (!$this->isUserInConversation($currentUser, $conversation)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $message = new Message([
            'conversation_id' => $conversation->id,
            'sender_id' => $currentUser->id,
            'content' => $request->content,
            'message_type' => $request->message_type,
        ]);

        $message->save();

        if ($request->hasFile('attachment')) {
            $this->handleAttachment($request->file('attachment'), $message);
        }

        // Load the sender relationship
        $message->load('sender');

        // TODO: Implement real-time notification (e.g., using Pusher or WebSockets)

        return response()->json(['message' => $message], 201);
    }

    public function getConversations()
    {
        $currentUser = Auth::user();
        $conversations = Conversation::where('user1_id', $currentUser->id)
            ->orWhere('user2_id', $currentUser->id)
            ->with(['user1', 'user2', 'messages' => function ($query) {
                $query->latest()->limit(1);
            }])
            ->get();

        return response()->json($conversations);
    }

    public function getMessages(Request $request, $conversationId)
    {
        $request->validate([
            'page' => 'integer|min:1',
            'per_page' => 'integer|min:1|max:100',
        ]);

        $currentUser = Auth::user();
        $conversation = Conversation::findOrFail($conversationId);

        if (!$this->isUserInConversation($currentUser, $conversation)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $perPage = $request->input('per_page', 15);
        $messages = Message::where('conversation_id', $conversationId)
            ->with(['sender', 'attachment'])
            ->orderBy('sent_at', 'desc')
            ->paginate($perPage);

        return response()->json($messages);
    }

    private function isUserInConversation($user, $conversation)
    {
        return $conversation->user1_id === $user->id || $conversation->user2_id === $user->id;
    }

    private function handleAttachment($file, $message)
    {
        $path = $file->store('attachments');
        
        $attachment = new Attachment([
            'message_id' => $message->id,
            'file_name' => $file->getClientOriginalName(),
            'file_type' => $file->getMimeType(),
            'file_size' => $file->getSize(),
            'file_path' => $path,
        ]);

        $attachment->save();
    }
}