<?php

namespace App\Filament\Resources\DepartmentResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Actions\AssociateAction;
use Filament\Tables\Actions\AttachAction;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class EmployeesRelationManager extends RelationManager
{
    protected static string $relationship = 'employees';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('name')
                    ->required()
                    ->maxLength(255),

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
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('AssignedEmployee')
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Name')
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('email')
                    ->label('Email')
                    ->searchable(),

                Tables\Columns\TextColumn::make('position')
                    ->label('Position')
                    ->searchable(),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                // Tables\Actions\CreateAction::make(),
                AssociateAction::make()
                    ->label('New Employee') // keep the label if you like
                    ->modalHeading('Assign Employee') // modal title
                    ->modalSubmitActionLabel('Assign') // changes "Associate" button to "Assign"
                    ->modalFooterActions(fn ($action) => [
                        $action->getModalSubmitAction()->label('Assign'), // only keep "Assign"
                        $action->getModalCancelAction(),
                    ])
                    ->preloadRecordSelect() // load options up-front
                    // ->recordSelectOptionsQuery(fn (Builder $query) => $query->whereNull('department_id')) // only show unassigned employees
                    ->recordTitleAttribute('name'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }
}
