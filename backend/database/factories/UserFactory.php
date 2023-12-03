<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => 'Admin', // fake()->name()
            'role_key' => 1, // Admin
            'email' => 'admin@mail.com', //fake()->unique()->safeEmail()
            'email_verified_at' => now(),
            'password' => bcrypt(1234), // password
            'remember_token' => Str::random(10),
        ];
    }

    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
