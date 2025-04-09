-- 📌 CONSULTAS AVANZADAS - BASE DE DATOS employees
-- 📢 Tienes las consultas explicadas paso a paso en mi canal de YouTube: 
-- 🔗 https://www.youtube.com/@DataAnalystAtares
-- Archivo con las respuestas SQL listas para ejecución

-- 1️⃣ Salario más alto de cada departamento (CTE)
WITH SalariosAltos AS (
    SELECT DP.dept_name AS Nombre_Departamento, MAX(S.salary) AS Salario_maximo
    FROM salaries S
    JOIN dept_emp D ON S.emp_no = D.emp_no
    JOIN departments DP ON D.dept_no = DP.dept_no
    GROUP BY DP.dept_no
)
SELECT Nombre_Departamento AS Departamento, Salario_maximo AS 'Salario máximo'
FROM SalariosAltos
ORDER BY Salario_maximo DESC;

-- 2️⃣ Vista con historial de títulos y salarios
CREATE VIEW Titulos_Salarios_Empleados AS
SELECT E.emp_no AS 'Nº empleado', E.first_name AS 'Nombre', E.last_name AS 'Apellido',
       S.salary AS 'Salario', T.title AS 'Título'
FROM employees E 
JOIN salaries S ON E.emp_no = S.emp_no
JOIN titles T ON E.emp_no = T.emp_no
WHERE T.to_date = '9999-01-01';

SELECT * FROM Titulos_Salarios_Empleados;

-- 3️⃣ Empleados cuyo salario actual es mayor que el salario promedio de su departamento
SELECT D.emp_no AS "Número empleado", S.salary AS "Salario"
FROM dept_emp D
JOIN salaries S ON D.emp_no = S.emp_no
WHERE S.to_date = '9999-01-01'
  AND S.salary > (
    SELECT AVG(S2.salary)
    FROM salaries S2
    JOIN dept_emp D2 ON S2.emp_no = D2.emp_no
    WHERE D2.dept_no = D.dept_no
  );

-- 4️⃣ ROW_NUMBER, RANK y DENSE_RANK por fecha de contratación
SELECT *, ROW_NUMBER() OVER (ORDER BY hire_date ASC) AS 'Orden contratacion'
FROM employees;

SELECT *, RANK() OVER (ORDER BY hire_date ASC) AS 'Orden contratacion'
FROM employees;

SELECT *, DENSE_RANK() OVER (ORDER BY hire_date ASC) AS 'Orden contratacion'
FROM employees;

-- 5️⃣ REGEXP para patrones en nombres
SELECT emp_no, first_name, last_name
FROM employees
WHERE first_name REGEXP 'aa+';

SELECT emp_no, first_name, last_name
FROM employees
WHERE first_name REGEXP 'Is..c';

SELECT emp_no, first_name, last_name
FROM employees
WHERE first_name REGEXP '[x-z]';

SELECT emp_no, first_name, last_name
FROM employees
WHERE first_name REGEXP 'e{2}';

-- 6️⃣ Empleados con aumento salarial mayor al 15% (LAG)
WITH SalaryChanges AS (
    SELECT emp_no, salary,
           LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS prev_salary
    FROM salaries
)
SELECT DISTINCT emp_no
FROM SalaryChanges
WHERE salary > prev_salary * 1.15;

-- 7️⃣ Top 3 salarios por departamento
SELECT *
FROM (
    SELECT E.first_name, E.last_name, DP.dept_name, S.salary,
           DENSE_RANK() OVER (PARTITION BY DP.dept_name ORDER BY S.salary DESC) AS ranking
    FROM employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    JOIN departments DP ON DE.dept_no = DP.dept_no
    JOIN salaries S ON E.emp_no = S.emp_no
    WHERE S.to_date = '9999-01-01'
) AS AliasSalario
WHERE ranking <= 3;

-- 8️⃣ Empleados con el salario máximo de su departamento
SELECT *
FROM (
    SELECT E.first_name, E.last_name, DP.dept_name, S.salary,
           DENSE_RANK() OVER (PARTITION BY DP.dept_name ORDER BY S.salary DESC) AS ranking
    FROM employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    JOIN departments DP ON DE.dept_no = DP.dept_no
    JOIN salaries S ON E.emp_no = S.emp_no
    WHERE DE.to_date = '9999-01-01'
) AS AliasSalario
WHERE ranking = 1;

-- 9️⃣ Empleados que han cambiado de título más de dos veces (CTE)
WITH EmpleadosConTitulos AS (
    SELECT E.emp_no, E.first_name, E.last_name, COUNT(DISTINCT T.title) AS num_titulos
    FROM employees E
    JOIN titles T ON E.emp_no = T.emp_no
    GROUP BY E.emp_no
)
SELECT *
FROM EmpleadosConTitulos
WHERE num_titulos > 2
ORDER BY num_titulos DESC;

-- 🔟 Empleados con salario superior al percentil 90 (NTILE)
WITH SalariosPercentil AS (
    SELECT salary, NTILE(100) OVER (ORDER BY salary) AS percentil
    FROM salaries
)
SELECT S.emp_no, E.first_name, E.last_name, S.salary
FROM salaries S
JOIN employees E ON S.emp_no = E.emp_no
WHERE S.salary > (
    SELECT salary FROM SalariosPercentil
    WHERE percentil = 90
    LIMIT 1
);

-- 1️⃣1️⃣ Aumentar tiempo de espera y crear índice
-- OPCIÓN SESIÓN ACTUAL:
SET @@SESSION.wait_timeout = 300;
SET @@SESSION.interactive_timeout = 300;

-- Crear índice para mejorar rendimiento en salaries
CREATE INDEX idx_salaries_emp_date ON salaries (emp_no, from_date);

-- Para eliminarlo más adelante:
-- DROP INDEX idx_salaries_emp_date ON salaries;

-- 1️⃣2️⃣ Mostrar salario anterior con LAG
WITH SalarioAnterior AS (
    SELECT 
        s.emp_no, e.first_name, e.last_name, s.salary, s.to_date,
        LAG(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date) AS salario_anterior
    FROM salaries s
    JOIN employees e ON s.emp_no = e.emp_no
)
SELECT emp_no, first_name, last_name, salary, salario_anterior
FROM SalarioAnterior
WHERE to_date = '9999-01-01' AND salario_anterior IS NOT NULL;

-- 1️⃣3️⃣ Procedimiento almacenado para actualizar salario (con transacción)
DELIMITER //

CREATE PROCEDURE UpdateSalary (
    IN p_emp_no INT,
    IN p_new_salary INT,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE old_salary INT;

    START TRANSACTION;

    SELECT salary INTO old_salary
    FROM salaries
    WHERE emp_no = p_emp_no AND to_date = '9999-01-01'
    LIMIT 1;

    SAVEPOINT before_update;

    UPDATE salaries
    SET to_date = CURDATE()
    WHERE emp_no = p_emp_no AND to_date = '9999-01-01';

    IF ROW_COUNT() = 0 THEN
        ROLLBACK TO SAVEPOINT before_update;
        SELECT 'Error: No se encontró el salario actual' AS message;
    ELSE
        INSERT INTO salaries (emp_no, salary, from_date, to_date)
        VALUES (p_emp_no, p_new_salary, CURDATE(), '9999-01-01');

        IF ROW_COUNT() = 0 THEN
            ROLLBACK TO SAVEPOINT before_update;
            SELECT 'Error: No se pudo insertar el nuevo salario' AS message;
        ELSE
            COMMIT;
            SELECT 'Salario actualizado correctamente' AS message;
        END IF;
    END IF;
END //

DELIMITER ;

-- Llamar al procedimiento
-- CALL UpdateSalary(10001, 92000, 'Aumento anual');

-- 1️⃣4️⃣ Trigger para registrar cambios en salario
DELIMITER //

CREATE TRIGGER trigger_actualizar_salario
AFTER INSERT ON salaries
FOR EACH ROW
BEGIN
    INSERT INTO prueba_updates_salarios (emp_no, old_salary, new_salary, reason)
    VALUES (
        NEW.emp_no,
        (SELECT salary FROM salaries WHERE emp_no = NEW.emp_no ORDER BY to_date DESC LIMIT 1),
        NEW.salary,
        'Aumento anual'
    );
END //

DELIMITER ;

-- 1️⃣5️⃣ Trigger para evitar contratación futura
DELIMITER //

CREATE TRIGGER trg_prevent_future_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.hire_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede insertar un empleado con fecha futura';
    END IF;
END //

DELIMITER ;

-- Prueba del trigger (debería lanzar error)
-- INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
-- VALUES (10002, '1995-07-20', 'Ana', 'Gómez', 'F', '2030-01-01');
