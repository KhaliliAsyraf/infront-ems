<?php

namespace App\Filament\Resources\EmployeeResource\Widgets;

use App\Models\Department;
use Filament\Widgets\ChartWidget;

class EmployeesByDepartment extends ChartWidget
{
    protected static ?string $heading = 'Chart';

    protected function getData(): array
    {
        $departments = Department::withCount('employees')->get();

        return [
            'datasets' => [
                [
                    'label' => 'Employees',
                    'data' => $departments->pluck('employees_count')->toArray(),
                ],
            ],
            'labels' => $departments->pluck('name')->toArray(),
        ];
    }

    protected function getType(): string
    {
        return 'pie';
    }
}
