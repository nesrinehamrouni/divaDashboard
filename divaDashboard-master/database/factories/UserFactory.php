<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'nom' => fake()->lastName(),
            'prenom' => fake()->firstName(),
            'email' => fake()->unique()->safeEmail(),
            'phone' => fake()->unique()->phoneNumber(),
            'email_verified_at' => now(),
            'device_key' => "dGyzdMaWQpSB_OOqQIL4rw:APA91bEjoRtwcNlMdoIhYHkzCqPBsyXC9y5USiN_bT3KmFYzyh4P45dUc2uBjwNXnR6W2f1Mn7jkGvEGyyByKxjR2W0_qpGDlSI-NrlYIDf5gTh_jFbhfMYasCA32zDvjPCTwdJLZstv",
            'delay' => rand(0,5),
            'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     *
     * @return static
     */
    public function unverified()
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
    
}