<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class VerificationCodeMail extends Mailable
{
    use Queueable, SerializesModels;

    public $verificationCode;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct(User $user, $verificationCode)
    {
        $this->user = $user;
        $this->verificationCode = $verificationCode;
    }
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function build()
    {
        return $this->view('emails.verificationCodeMail')
                    ->subject('Verification Code')
                    ->with([
                        'user' => $this->user,
                        'verificationCode' => $this->verificationCode,
                    ]);
    }
}