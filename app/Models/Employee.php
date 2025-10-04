<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Employee extends Model
{
    protected $table = 'employees';

    protected $fillable = [
        'name',
        'email',
        'position',
        'id_departments',
        'salary'
    ];

    public function department(): BelongsTo
    {
        return $this->belongsTo(Department::class, 'id_departments');
    }
}
