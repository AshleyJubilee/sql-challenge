--Create Tables
CREATE TABLE titles (
    title_id varchar PRIMARY KEY,
    title varchar NOT NULL
);

CREATE TABLE departments (
	dept_no varchar PRIMARY KEY,
	dept_name varchar NOT NULL
);

CREATE TABLE employees (
	emp_no int PRIMARY KEY,
	emp_title_id varchar NOT NULL,
	birth_date varchar NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	sex varchar NOT NULL,
	hire_date varchar NOT NULL,
	FOREIGN KEY(emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE salaries (
	emp_no int PRIMARY KEY,
	salary int NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager (
	dept_no varchar NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	emp_no int NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE dept_emp (
	emp_no int NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	dept_no varchar NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

--List employee number, last name, first name, sex and salary
SELECT employees.emp_no, last_name, first_name, sex, salary
FROM employees
LEFT JOIN salaries
ON employees.emp_no = salaries.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date LIKE '%1986';

--List the manager of each department along with their department number, department name, employee number, last name, and first name 
SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name
FROM dept_manager m
LEFT JOIN employees as e
ON m.emp_no = e.emp_no
LEFT JOIN departments d
ON m.dept_no = d.dept_no;


--List the department number for each employee along with that employee’s employee number, last name, first name, and department name 
SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
LEFT JOIN employees as e
ON de.emp_no = e.emp_no
LEFT JOIN departments d
ON de.dept_no = d.dept_no;


--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B 
SELECT first_name, last_name, sex
FROM employees
WHERE first_name LIKE 'Hercules'
AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name 
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
		)
	);
	

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name 
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
LEFT JOIN dept_emp de
ON e.emp_no = de.emp_no
LEFT JOIN departments d
ON de.dept_no = d.dept_no
WHERE dept_name IN ('Sales', 'Development');


--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) 
SELECT last_name, COUNT(last_name)AS Frequency
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;
