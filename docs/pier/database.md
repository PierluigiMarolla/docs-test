# Welcome to my Documentation

This is documentation generated with **Docsify**!


## Documentation Sections

- [Introduction](#introduction)
- [DatabaseController](#databasecontroller)
- [Method: createDatabase](#method-createdatabase)
- [Database Creation](#database-creation)
- [Responses](#responses)
- [Request and Response Examples](#request-and-response-examples)
- [How to Install](#how-to-install)
- [Contributions](#contributions)

## Introduction

The `DatabaseController` manages the dynamic creation of PostgreSQL databases based on the parameters provided in the request.

## DatabaseController

The `DatabaseController` provides methods to interact with the database, particularly for creating new PostgreSQL databases.

### Method: createDatabase

This method accepts a request to create a new PostgreSQL database.

#### Request Parameter Validation
The method validates the following parameters sent via `POST`:

- `db_host`: **string** - (Required) The database host.
- `db_port`: **integer** - (Required) The database port.
- `db_username`: **string** - (Required) The database username.
- `db_password`: **string** - (Required) The password to access the database.
- `databaseName`: **string** - (Required) The name of the database to create.

If one or more of these fields are invalid or missing, the method returns a response with error code **400** and details of the validation errors.

### Database Creation
After establishing the connection, the method executes an SQL command to create a new database with the specified name:

```php
$db->statement("CREATE DATABASE {$databaseName}");
```

## Request and Response Examples

### Request Example
Here's an example of an API call to create a database:

```endopoint
POST /create-database
Content-Type: application/json
```
```php
{
  "db_host": "localhost",
  "db_port": 5432,
  "db_username": "admin",
  "db_password": "password",
  "databaseName": "new_database"
}
```

### Success Response
If the database is created successfully, the response will be:
```
    {
      "success": "Database new_database created successfully."
    }
    
```

### Error Response
If an error occurs, the response will be:

```
    {
      "error": "Error during database creation: [error details]"
    }
```

# DatabaseOperationsController

The `DatabaseOperationsController` is responsible for various database manipulation operations, such as adding columns, renaming columns and tables, changing column data types, and removing columns.

## Methods

### addColumn

Adds a new column to a specified table.

**Request Parameters:**
- `table` (string): The name of the table to add the column to.
- `column` (string): The name of the new column to add.
- `type` (string): The data type of the new column.

**Usage Example:**
```php
POST /add-column
{
    "table": "users",
    "column": "phone_number",
    "type": "VARCHAR(15)"
}
```

**Success Response:**
```json
{
    "message": "Column phone_number successfully added to table users"
}
```

**Possible Errors:**
- 400 Bad Request: If the request parameters are not valid.
- 500 Internal Server Error: If an error occurs while adding the column.

### renameColumn

Renames an existing column in a table.

> **Note:** This method currently uses hardcoded values. Modify the code to accept parameters from the request.

**Usage Example:**
```php
POST /rename-column
```

**Success Response:**
```json
{
    "message": "Column renamed successfully"
}
```

### changeColumnType

Changes the data type of an existing column.

> **Note:** This method currently uses hardcoded values. Modify the code to accept parameters from the request.

**Usage Example:**
```php
POST /change-column-type
```

**Success Response:**
```json
{
    "message": "Column data type changed successfully"
}
```

### dropColumn

Removes a column from a table.

> **Note:** This method currently uses hardcoded values. Modify the code to accept parameters from the request.

**Usage Example:**
```php
POST /drop-column
```

**Success Response:**
```json
{
    "message": "Column removed successfully"
}
```

### renameTable

Renames an existing table.

> **Note:** This method currently uses hardcoded values. Modify the code to accept parameters from the request.

**Usage Example:**
```php
POST /rename-table
```

**Success Response:**
```json
{
    "message": "Table renamed successfully"
}
```

## Important Notes

1. Make sure to implement necessary security measures and access controls before using these methods in a production environment.
2. The methods `renameColumn`, `changeColumnType`, `dropColumn`, and `renameTable` currently use hardcoded values. It is advisable to modify these methods to accept parameters from the request, similar to the `addColumn` method.
3. Consider adding input validation and error handling for all methods to improve the robustness and security of the controller.
