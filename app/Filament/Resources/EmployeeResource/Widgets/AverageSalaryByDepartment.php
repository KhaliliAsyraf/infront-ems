<?php

namespace App\Filament\Resources\EmployeeResource\Widgets;

use App\Models\Department;
use Filament\Widgets\ChartWidget;

class AverageSalaryByDepartment extends ChartWidget
{
    protected static ?string $heading = 'Average Salary by Department';

    protected function getData(): array
    {
        $departments = Department::with('employees')->get();

        $labels = $departments->pluck('name')->toArray();
        $data = $departments->map(function ($department) {
            $avg = $department->employees->avg('salary');
            return round($avg, 2);
        })->toArray();

        return [
            'datasets' => [
                [
                    'label' => 'Average Salary (RM)',
                    'data' => $data,
                    'backgroundColor' => 'rgba(34, 197, 94, 0.7)',
                ],
            ],
            'labels' => $labels,
        ];
    }

    protected function getType(): string
    {
        return 'bar'; // horizontal/vertical bar chart
    }
}
