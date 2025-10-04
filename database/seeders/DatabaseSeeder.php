<?php

namespace Database\Seeders;

use App\Models\Department;
use App\Models\Employee;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@example.com',
            'is_admin' => true,
            'password' => bcrypt('password'), // password
        ]);

        Employee::firstOrCreate(
            [
                'name' => 'John Doe',
                'email' => 'john@example.com',
                'position' => 'Developer',
                'salary' => 6000.00,
                'id_departments' => Department::firstOrCreate(['name' => 'Engineering'])->id,
            ]
        );
    }
}
