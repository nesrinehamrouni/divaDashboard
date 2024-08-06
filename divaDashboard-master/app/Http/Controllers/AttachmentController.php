<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Attachment;
use App\Models\Message;
use Illuminate\Support\Facades\Storage;

class AttachmentController extends Controller
{
    public function store(Request $request, Message $message)
    {
        $user = Auth::user();
        if ($message->sender_id !== $user->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'file' => 'required|file|max:10240', // 10MB max file size
        ]);

        $file = $request->file('file');
        $path = $file->store('attachments');

        $attachment = new Attachment([
            'message_id' => $message->id,
            'file_name' => $file->getClientOriginalName(),
            'file_type' => $file->getMimeType(),
            'file_size' => $file->getSize(),
            'file_path' => $path,
        ]);

        $attachment->save();

        return response()->json($attachment, 201);
    }

    public function show(Attachment $attachment)
    {
        $user = Auth::user();
        if (!$this->canAccessAttachment($user, $attachment)) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->download(Storage::path($attachment->file_path), $attachment->file_name);
    }

    private function canAccessAttachment($user, $attachment)
    {
        $conversation = $attachment->message->conversation;
        return $conversation->user1_id === $user->id || $conversation->user2_id === $user->id;
    }
}