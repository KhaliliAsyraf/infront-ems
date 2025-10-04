<?php

namespace App\Filament\Resources\EmployeeResource\Widgets;

use App\Models\Employee;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class TotalEmployees extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Employees', Employee::count())
                ->icon('heroicon-o-users')
                ->color('primary'),
        ];
    }
}
