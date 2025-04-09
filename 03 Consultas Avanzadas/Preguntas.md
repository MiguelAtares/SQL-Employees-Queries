📌 Consultas SQL Avanzadas - Base de Datos employees
Este bloque está enfocado en consultas complejas de SQL, que incluyen subconsultas correlacionadas, CTEs, vistas, funciones de ventana, expresiones regulares, procedimientos almacenados, transacciones y triggers.

📢 Todas las consultas están explicadas paso a paso en mi canal de YouTube:
🔗 @DataAnalystAtares

1️⃣ Usa una CTE para obtener el salario más alto de cada departamento.

2️⃣ Crea una vista que muestre el historial completo de títulos y salarios de cada empleado.

3️⃣ Escribe una subconsulta para encontrar los empleados cuyo salario actual es mayor que el salario promedio de su departamento.

4️⃣ Usa funciones de ventana para asignar un número de fila a cada empleado según su fecha de contratación:

ROW_NUMBER

RANK

DENSE_RANK

5️⃣ Usa REGEXP para encontrar empleados cuyos nombres cumplan patrones específicos:

Dos vocales seguidas

Comodines

Letras específicas

Repeticiones

6️⃣ Obtén los empleados que han recibido un aumento salarial de más del 15% en una sola ocasión.
Utiliza LAG() dentro de una CTE para comparar salarios actuales y anteriores.

7️⃣ Encuentra los tres empleados con los salarios más altos en cada departamento.
Utiliza funciones de ventana y una subconsulta para filtrar los top 3 por cada grupo.

8️⃣ Usa una subconsulta para encontrar empleados cuyo salario actual sea el máximo de su departamento.
Requiere DENSE_RANK y filtrado posterior.

9️⃣ Crea una CTE que devuelva los empleados que han cambiado de título más de dos veces.

🔟 Devuelve los empleados con un salario superior al 90% de todos los salarios registrados en la empresa.
Usa NTILE como función de ventana para crear percentiles.

1️⃣1️⃣ Explica cómo mejorar el rendimiento de las consultas en tablas grandes:

Aumentando el tiempo de espera de ejecución

Creando un índice sobre columnas relevantes

Explicación paso a paso del impacto del índice

1️⃣2️⃣ Usa LAG() para mostrar el salario anterior de cada empleado antes de su último cambio.
Filtra adecuadamente usando to_date = '9999-01-01' y condiciones de rendimiento.

1️⃣3️⃣ Escribe un procedimiento almacenado que actualice el salario de un empleado, cierre el periodo anterior y registre el cambio.
Incluye control de errores, transacción, SAVEPOINT, ROLLBACK y COMMIT.

1️⃣4️⃣ Implementa un trigger que registre automáticamente en una tabla los cambios de salario insertados por el procedimiento.
Utiliza AFTER INSERT ON salaries.

1️⃣5️⃣ Implementa un trigger que impida insertar empleados con fecha de contratación futura.
Utiliza BEFORE INSERT ON employees y SIGNAL SQLSTATE para lanzar el error.

🧠 Estos ejercicios están diseñados para practicar consultas complejas, comprender mejor cómo se gestionan los datos en entornos reales y aplicar SQL a nivel profesional.

Puedes encontrar el código completo con todas las respuestas en el archivo respuestas_avanzadas.sql.

🔗 GitHub: https://github.com/MiguelAtares
🔗 YouTube: https://www.youtube.com/@DataAnalystAtares
