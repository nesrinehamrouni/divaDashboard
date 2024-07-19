<?php

namespace App\Http\Controllers;
use App\Models\User;
use App\Mail\VerificationCodeMail;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller{

    public function register(Request $request){
        

        $attrs = $request->validate([
            'nom' => 'required|string',
            'prenom' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|digits:8|unique:users,phone',
            'password' => 'required|min:6|confirmed'
        ]);
        $user = User::create([
            'nom'=> $attrs['nom'],
            'prenom' => $attrs['prenom'],
            'email' => $attrs['email'],
            'phone' => $attrs['phone'],
            'password' => bcrypt($attrs['password']),
            'remember_token' => Str::random(10) 
        ]);
    
        $token = $user->createToken('secret')->plainTextToken;
    
        $user->update(['remember_token' => $token]);
    
        $verificationCode = $user->generateVerificationCode();
        Mail::to($user->email)->send(new VerificationCodeMail($user, $verificationCode));

        
        // Return response
        return response()->json([
            'message' => 'User registered successfully. Please check your email for the verification code.',
            'verification_code' => $verificationCode,
            'user' => $user, 
        ], 200);
    }

    public function login(Request $request)
{
  Log::info('Login request:', $request->all());

    $validator = Validator::make($request->all(), [
        'email' => 'required',
        'password' => 'required'
    ]);

    if ($validator->fails()) {
        return response()->json(['status_code' => 400, 'message' => 'Bad Request']);
    }

    $ExistUserX = DB::select("SELECT CASE WHEN EXISTS(SELECT 1 FROM MUSER WHERE USERX = '" . strtoupper($request->email) . "')THEN 1 ELSE 0 END as EXIST;");

    if ($ExistUserX[0]->EXIST == 0) {
        return response()->json(['status_code' => 404, 'message' => 'User does not exist']);
    }

    // Convert email to uppercase and attempt to authenticate the user
    $credentials = ['email' => strtoupper($request->email), 'password' => $request->password];
    if (!Auth::attempt($credentials)) {
        return response()->json(
            [
                'status_code' => 401,
                'message' => 'Incorrect password'
            ]
        );
    }

    // Retrieve the authenticated user and generate an authentication token
    $user = User::where('email', strtoupper($request->email))->first();
    $tokenResult = $user->remember_token;

    return response()->json([
        'status_code' => 200,
        'token' => $tokenResult,
        'message' => 'Authenticated'
    ]);
}

public function logout(Request $request)
{
    try {
        $user = auth()->user();
        
        if (!$user) {
            \Log::warning('Logout attempted with no authenticated user');
            return response()->json([
                'status' => 'warning',
                'message' => 'No authenticated user found'
            ], 401);
        }

        // Revoke all tokens...
        $user->tokens()->delete();
        
        // Clear the remember_token
        $user->update(['remember_token' => null]);

        return response()->json([
            'status' => 'success',
            'message' => 'Logged out successfully'
        ], 200);
    } catch (\Exception $e) {
        \Log::error('Logout error: ' . $e->getMessage());
        
        return response()->json([
            'status' => 'error',
            'message' => 'An error occurred during logout',
            'error' => $e->getMessage()
        ], 500);
    }
}

 
    public function get_user()
{
    try {
        $users = User::where('id', '!=', auth()->id())
                     ->whereNotNull('id')
                     ->whereNotNull('nom')
                     ->whereNotNull('email')
                     ->get(['id', 'nom', 'email']);
        
        return response()->json($users);
    } catch (\Exception $e) {
        \Log::error('Error in get_user: ' . $e->getMessage());
        \Log::error('Stack trace: ' . $e->getTraceAsString());
        return response()->json([
            'error' => 'An error occurred while fetching users',
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ], 500);
    }
}

public function getCurrentUserId(Request $request)
{
    try {
        $token = $request->bearerToken();
        $user = User::where('remember_token', $token)->first();

        if ($user) {
            return response()->json(['user_id' => $user->id], 200);
        } else {
            return response()->json(['message' => 'User not authenticated'], 401);
        }
    } catch (\Exception $e) {
        \Log::error('Error in getCurrentUserId: ' . $e->getMessage());
        return response()->json(['error' => 'An error occurred while fetching user ID'], 500);
    }
}


    public function destroy(Request $req){
            
            return User::destroy($req->id);
    }



    public function update(Request $req){
        $new =  bcrypt($req->password);
        
            $user = User::where('email', $req->email)->first();
            $user->password =$new;
            $user->nom =$req->nom;
            $user->prenom =$req->prenom;
            $user->phone =$req->phone;
        

        
        $user->save();
        
        
        return $user;
        
    }


}
