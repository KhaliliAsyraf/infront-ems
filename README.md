# Employee Management System (EMS)

A **modern, minimalist employee management system** built with Laravel and Filament. Designed for easy tracking and administration of employees, departments, and reporting.

## Tech Stack

- **Frontend:** [Filament](https://filamentphp.com/) / Livewire  
- **Backend:** PHP Laravel  

---

## Features

- Employee management with departments  
- Department-based reporting  
- Dashboard with statistics (Total Employees, Employees by Department, Average Salary by Department)  
- Minimalist and easy-to-use admin interface  

---

## Prerequisites

Before starting, make sure you have the following installed:

- PHP >= 8.x  
- Composer  
- Node.js and NPM  
- A local database (MySQL, MariaDB, or PostgreSQL)  

> **Note:** Docker is not included in this setup. You will need to create your own local database manually if not already installed.

---

## Installation Steps

1. **Setup your local database**  

   Make sure you have a local database ready for EMS. For example, create a database named `ems_db`.  
   Then, configure your database connection in the `.env` file (that copy from `.env.example`):

   ```dotenv
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=ems_db
   DB_USERNAME=root
   DB_PASSWORD=

2. **Run the installation script**  

   Open your terminal/CLI and execute:

   ```bash
   ./install.sh
   ```

   This command to initially setup, install and build project.
