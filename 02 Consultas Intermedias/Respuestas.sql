-- 📌 CONSULTAS INTERMEDIAS - BASE DE DATOS employees.
-- 📢 Tienes las consultas bien explicadas en mi canal de youtube: 
    -- 🔗 https://www.youtube.com/@DataAnalystAtares
-- Archivo con las respuestas SQL listas para ejecución

-- 1️⃣ Crea una tabla prueba_update_salarios con 5 columnas y luego añade una nueva columna llamada reason.
CREATE TABLE prueba_updates_salarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_no INT NOT NULL,
    old_salary INT,
    NEW_salary INT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE prueba_updates_salarios ADD COLUMN reason VARCHAR(255);

-- 2️⃣ Análisis de ingeniería inversa: Explicación teórica (ver video). No se requiere código SQL.

-- 3️⃣ Diferencia en días entre la fecha de contratación y la fecha actual.
SELECT emp_no, first_name, last_name, hire_date, 
       DATEDIFF(CURDATE(), hire_date) AS dias_trabajados
FROM employees;

-- 4️⃣ Cantidad de empleados por departamento (incluye nombre).
SELECT DP.dept_name, COUNT(DE.dept_no) AS cantidad_empleados
FROM departments DP
JOIN dept_emp DE ON DP.dept_no = DE.dept_no
GROUP BY DP.dept_name;

-- 5️⃣ Salario promedio, mínimo y máximo por título.
SELECT T.title, MAX(S.salary) AS salario_max, 
       MIN(S.salary) AS salario_min, AVG(S.salary) AS salario_promedio
FROM salaries S
JOIN titles T ON S.emp_no = T.emp_no
GROUP BY T.title;

-- 6️⃣ Número de títulos distintos que ha tenido cada empleado.
SELECT E.emp_no AS 'Nº empleado', E.first_name AS 'Nombre', E.last_name AS 'Apellido', 
       COUNT(*) AS 'Nº titulos'
FROM titles T
JOIN employees E ON T.emp_no = E.emp_no
GROUP BY T.emp_no, E.first_name, E.last_name;

-- 7️⃣ Salario total pagado por cada departamento.
SELECT DP.dept_name AS 'Departamento', SUM(S.salary) AS 'Total del salario'
FROM salaries S
JOIN dept_emp DE ON S.emp_no = DE.emp_no
JOIN departments DP ON DE.dept_no = DP.dept_no
WHERE S.to_date = '9999-01-01'
GROUP BY DP.dept_name
ORDER BY 2 DESC;

-- 8️⃣ Departamentos con más de 3 gerentes diferentes.
SELECT DP.dept_name, DE.dept_no, COUNT(*) AS 'Numero_gerentes'
FROM dept_manager DE
JOIN departments DP ON DE.dept_no = DP.dept_no
GROUP BY DE.dept_no
HAVING Numero_gerentes > 3;

-- 9️⃣ Empleados que han trabajado en más de un departamento simultáneamente.
SELECT DISTINCT d1.emp_no
FROM dept_emp d1
JOIN dept_emp d2 
    ON d1.emp_no = d2.emp_no  
    AND d1.dept_no <> d2.dept_no  
    AND d1.from_date < d2.to_date  
    AND d2.from_date < d1.to_date;

-- 🔟 Empleados con salario mayor al salario promedio de la empresa.
SELECT E.emp_no, E.first_name, E.last_name, S.salary
FROM salaries S
JOIN employees E ON S.emp_no = E.emp_no
WHERE S.salary > (
    SELECT AVG(salary) FROM salaries
);

-- 1️⃣1️⃣ Empleados cuyo salario ha cambiado más de 3 veces.
-- Versión sin CTE:
SELECT emp_no, COUNT(*) AS 'Numero_sueldos'
FROM salaries
GROUP BY emp_no
HAVING Numero_sueldos > 2;

-- Versión con CTE:
WITH NumeroSueldos AS (
    SELECT emp_no, COUNT(*) AS 'Numero_sueldos'
    FROM salaries
    GROUP BY emp_no
)
SELECT * FROM NumeroSueldos
WHERE Numero_sueldos > 2;

-- 1️⃣2️⃣ Empleados que tienen el mismo salario actual que al ser contratados.
WITH SalaryHistory AS (
    SELECT emp_no, salary, to_date,
           FIRST_VALUE(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS first_salary
    FROM salaries
)
SELECT DISTINCT emp_no
FROM SalaryHistory
WHERE salary = first_salary AND to_date = '9999-01-01';

-- 1️⃣3️⃣ Duración promedio (en días) de los títulos ocupados por los empleados.
WITH Time_Titles AS (
    SELECT emp_no, title, DATEDIFF(to_date, from_date) AS 'Tiempo_trabajando'
    FROM titles
    WHERE to_date <> '9999-01-01'
)
SELECT title, AVG(Tiempo_trabajando)
FROM Time_Titles
GROUP BY title;

-- 1️⃣4️⃣ Clasificación del salario como alto, medio o bajo con CASE.
SELECT e.emp_no, e.first_name, e.last_name, s.salary,
       CASE 
           WHEN s.salary > 80000 THEN 'Alto salario'
           WHEN s.salary BETWEEN 50000 AND 80000 THEN 'Salario medio'
           ELSE 'Bajo salario'
       END AS categoria_salarial
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01';

-- 1️⃣5️⃣ Cantidad de empleados actualmente por género en cada departamento.
SELECT 
    Dp.dept_name, 
    COUNT(CASE WHEN E.gender = 'M' THEN 1 END) AS hombres,
    COUNT(CASE WHEN E.gender = 'F' THEN 1 END) AS mujeres
FROM employees E
JOIN dept_emp D ON E.emp_no = D.emp_no
JOIN departments Dp ON D.dept_no = Dp.dept_no
WHERE D.to_date = '9999-01-01'
GROUP BY Dp.dept_name
ORDER BY dept_name;

-- 1️⃣6️⃣ Empleados cuyo salario es el más alto dentro de su departamento.
WITH Max_Salaries AS (
    SELECT de.dept_no, MAX(s.salary) AS max_salary
    FROM salaries s
    JOIN dept_emp de ON s.emp_no = de.emp_no
    WHERE de.to_date = '9999-01-01' 
    GROUP BY de.dept_no
)
SELECT 
    d.dept_name, 
    e.emp_no, 
    e.first_name, 
    e.last_name, 
    s.salary
FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN Max_Salaries ms ON de.dept_no = ms.dept_no AND s.salary = ms.max_salary
WHERE de.to_date = '9999-01-01';
