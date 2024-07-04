<?php

namespace App\Http\Controllers;
use App\Models\User;
use App\Mail\VerificationCodeMail;
use Illuminate\Http\Request;
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
        ]);
    
        $verificationCode = $user->generateVerificationCode();
        Mail::to($user->email)->send(new VerificationCodeMail($user, $verificationCode));

    // Return response
    return response()->json([
        'message' => 'User registered successfully. Please check your email for the verification code.',
        'verification_code' => $verificationCode,
        'user' => $user, 
        'token' => $user->createToken('secret')->plainTextToken
    ], 200);
}

public function login(Request $request)
{
  Log::info('Login request:', $request->all());

    // Validate the request
    $validator = Validator::make($request->all(), [
        'email' => 'required',
        'password' => 'required'
    ]);

    if ($validator->fails()) {
        return response()->json(['status_code' => 400, 'message' => 'Bad Request']);
    }

    // Check if the user exists in the external database
    $ExistUserX = DB::select("SELECT CASE WHEN EXISTS(SELECT 1 FROM MUSER WHERE EMAIL = '" . strtoupper($request->email) . "')THEN 1 ELSE 0 END as EXIST;");

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
    $tokenResult = $user->createToken('authToken')->plainTextToken;

    // Return the response with the token
    return response()->json([
        'status_code' => 200,
        'token' => $tokenResult,
        'message' => 'Authenticated'
    ]);
}
public function logout()
{
    auth()->user()->tokens()->delete();
        return response([
            'message' => 'Logout success'
        ],200); 
}



public function get_user(){

    return response([
        'user' => auth()->user()
    ],200);
}



public function destroy(Request $req)
    {
        
        return User::destroy($req->id);
    }



    public function update(Request $req)
    {
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
