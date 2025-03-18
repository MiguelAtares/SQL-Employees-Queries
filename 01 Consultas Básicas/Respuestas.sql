-- 📌 CONSULTAS BÁSICAS - BASE DE DATOS employees. Tienes las consultas bien explicadas en mi canal de youtube https://www.youtube.com/@DataAnalystAtares
-- Archivo con las respuestas SQL listas para ejecución

-- 1️⃣ Muestra los nombres y apellidos de todos los empleados.
SELECT first_name, last_name FROM employees;

-- 2️⃣ Lista los nombres de los departamentos sin repetir valores.
SELECT DISTINCT dept_name FROM departments;

-- 3️⃣ Muestra los empleados cuyo apellido empieza con la letra ‘S’.
SELECT emp_no, first_name, last_name 
FROM employees 
WHERE last_name LIKE 'S%';

-- 4️⃣ Muestra los empleados cuyo nombre tiene exactamente 5 caracteres.
SELECT first_name, last_name 
FROM employees
WHERE first_name LIKE '_____'; -- 5 guiones bajos representan 5 caracteres exactos

-- 5️⃣ Encuentra los empleados que trabajan en los departamentos 'd005' o 'd007'.
SELECT emp_no, dept_no 
FROM dept_emp
WHERE dept_no IN ('d005', 'd007');

-- 6️⃣ Muestra los empleados cuyo salario está entre 60,000 y 80,000.
SELECT emp_no, salary 
FROM salaries
WHERE salary BETWEEN 60000 AND 80000;

-- 7️⃣ Muestra los primeros 10 empleados ordenados por fecha de contratación ASCendente.
SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
ORDER BY hire_date ASC
LIMIT 10;

-- 8️⃣ Encuentra los empleados que no trabajan en el departamento ‘Sales’.
-- Paso 1: Identificar el código del departamento ‘Sales’
SELECT dept_no, dept_name 
FROM departments 
WHERE dept_name = 'Sales'; -- Resultado: d007

-- Paso 2: Listar empleados que NO están en d007
SELECT emp_no, dept_no 
FROM dept_emp 
WHERE dept_no <> 'd007';

-- 9️⃣ Muestra el número total de empleados en la empresa.
SELECT COUNT(*) AS total_empleados 
FROM employees;

-- 🔟 Calcula el número total de títulos distintos que ha habido en la empresa.
SELECT COUNT(DISTINCT title) AS total_titulos 
FROM titles;

-- Consulta extra: Obtener la lista de títulos distintos
SELECT DISTINCT title 
FROM titles;
