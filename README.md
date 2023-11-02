# sql-challenge
Module 9 Challenge (PostgreSQL) - Wassim Deen

# Summary of Challenge
- Data Modelling
    1. Inspect and understand all six CSV data files (tables)
    2. Produce an Entity Relationship Diagram (ERD) of the tables

- Data Engineering
    1. For each of the six CSV data files, create a table schema where:
        - All required columns are defined
        - Columns are set to the correct data type
        - Primary Keys set for the table
        - Related tables are correctly referenced
        - Tables are correctly related using Foreign Keys
        - NOT NULL condition on necessary columns is used correctly
        - Define value length for columns accurately

 - Data Analysis
    1. Perform the following SQL queries using the SQL tables:
        - List the employee number, last name, first name, sex, and salary of each employee
        - List the first name, last name, and hire date for the employees who were hired in 1986
        - List the manager of each department along with their department number, department name, employee number, last name, and first name
        - List the department number for each employee along with that employee’s employee number, last name, first name, and department name
        - List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
        - List each employee in the Sales department, including their employee number, last name, and first name
        - List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
        - List the frequency counts, in descending order, of all the employee last names i.e. how many employees share each last name?

# Notes
1. `EmployeeSQL_Final.sql` contains both the SQL Table Schemata and Queries
2. ERD Sketch (`EmployeeSQL_ERD.png`) can be found in 'data' folder


# Final Repository Structure
```
├── README.md
├── .gitignore
└── EmployeeSQL
    ├── EmployeeSQL_Final.sql
    └── data
        ├── EmployeeSQL_ERD.png
        ├── titles.csv
        ├── salaries.csv
        ├── employees.csv
        ├── dept_manager.csv
        ├── dept_emp.csv
        ├── departments.csv

```
