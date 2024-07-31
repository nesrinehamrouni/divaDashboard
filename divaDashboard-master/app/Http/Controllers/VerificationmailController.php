<?php

namespace App\Http\Controllers;
use App\Models\User;
use App\Mail\VerificationCodeMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;

class VerificationmailController extends Controller{
    public function verifyCode(Request $request){
        $user = User::where('email', $request->email)->first();
        
        if ($user && $user->verification_code === $request->code) {
            $user->email_verified_at = now();
            $user->save();
            return response()->json(['message' => 'Email verified successfully.']);
        }
        
        return response()->json(['message' => 'Invalid verification code.'], 400);
    }
}