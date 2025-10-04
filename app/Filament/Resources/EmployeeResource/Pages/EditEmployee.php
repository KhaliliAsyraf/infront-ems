<?php

namespace App\Filament\Resources\EmployeeResource\Pages;

use App\Filament\Resources\EmployeeResource;
use Filament\Actions;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Form;
use Filament\Resources\Pages\EditRecord;

class EditEmployee extends EditRecord
{
    protected static string $resource = EmployeeResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }

    public function form(Form $form): Form
    {
        return $form->schema([
            TextInput::make('name')
                ->label('Name')
                ->required(),

            TextInput::make('email')
                ->label('Email')
                ->required()
                ->unique(ignorable: fn ($record) => $record),
            
            TextInput::make('position')
                ->label('Position')
                ->required(),

            TextInput::make('salary')
                ->label('Salary')
                ->numeric()
                ->prefix('RM')
                ->default(0)
                ->rule(['numeric','min:1500']),

             Select::make('id_departments')
                ->label('Department')
                ->relationship('department', 'name') // assumes Employee belongsTo Department
                ->required(),

        ]);
    }
}
