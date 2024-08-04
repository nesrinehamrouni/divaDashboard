<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
class Message extends Model
{
    use HasFactory;

    const CREATED_AT = 'sent_at';
    const UPDATED_AT = null;

    protected $fillable = ['conversation_id', 'sender_id', 'content', 'message_type', 'is_read'];

    public function conversation()
    {
        return $this->belongsTo(Conversation::class);
    }
    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id');
    }
    public function attachment()
    {
        return $this->hasOne(Attachment::class);
    }
}