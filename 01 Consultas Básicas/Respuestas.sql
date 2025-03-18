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

-- 1️⃣1️⃣ Muestra los empleados con mayor y menor salario de cada departamento.
-- Opción 1: Mostrar el salario mínimo y máximo por empleado
SELECT emp_no, MIN(salary) AS salario_minimo, MAX(salary) AS salario_maximo
FROM salaries
GROUP BY emp_no;

-- Opción 2: Obtener el salario mínimo y máximo por departamento
SELECT d.dept_no, MIN(s.salary) AS salario_minimo, MAX(s.salary) AS salario_maximo
FROM salaries s
JOIN dept_emp d ON s.emp_no = d.emp_no
GROUP BY d.dept_no;

-- 1️⃣2️⃣ Muestra la cantidad de empleados históricamente en cada departamento.
SELECT dept_no, COUNT(*) AS total_empleados
FROM dept_emp
GROUP BY dept_no;

-- 1️⃣3️⃣ Obtén los empleados que fueron contratados en la misma fecha.
SELECT hire_date, COUNT(emp_no) AS empleados_contratados
FROM employees
GROUP BY hire_date
ORDER BY hire_date;

-- 1️⃣4️⃣ Encuentra los años en los que se contrataron empleados, sin repetir valores.
SELECT YEAR(hire_date) AS anio_contratacion, COUNT(emp_no) AS total_contratados
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY año_contratacion;

-- 1️⃣5️⃣ Encuentra los empleados que han trabajado en más de un departamento.
SELECT emp_no, COUNT(DISTINCT dept_no) AS num_departamentos
FROM dept_emp
GROUP BY emp_no
HAVING COUNT(DISTINCT dept_no) > 1;

-- 1️⃣6️⃣ Muestra los empleados contratados antes de 1995 o que estén en el departamento ‘d007’.
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, d.dept_no
FROM employees e
JOIN dept_emp d ON e.emp_no = d.emp_no
WHERE e.hire_date < '1995-01-01' OR d.dept_no = 'd007';

-- 1️⃣7️⃣ ¿Cuál es el máximo de contrataciones en un día?
-- Opción 1: Ordenar y mostrar el día con más contrataciones
SELECT hire_date, COUNT(emp_no) AS contrataciones
FROM employees
GROUP BY hire_date
ORDER BY contrataciones DESC
LIMIT 1;

-- Opción 2: Usar una subconsulta para obtener el máximo de contrataciones en un día
SELECT MAX(Contrataciones) AS maximo_contrataciones
FROM (
    SELECT COUNT(emp_no) AS Contrataciones
    FROM employees
    GROUP BY hire_date
) AS Subconsulta;
