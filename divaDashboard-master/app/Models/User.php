<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Support\Str; 

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
      'nom',
      'prenom',
      'email',
      'phone',
      'password',
      'remember_token',
      'profile_image',
  ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function generateVerificationCode()
    {
        $verificationCode = Str::random(6); // Generate a 6-character random string

        $this->verification_code = $verificationCode;
        $this->save();

        return $verificationCode;
    }
// ********************************************
//     public function profile_image()
// {
//     return $this->hasOne('App/profile_image');
// }
// **********************************************************
}

