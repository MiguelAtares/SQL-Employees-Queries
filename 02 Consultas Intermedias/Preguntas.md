📌 Consultas SQL Intermedias - Base de Datos employees  
Este bloque está enfocado en el desarrollo de habilidades intermedias con SQL, incluyendo el uso de `GROUP BY`, `HAVING`, distintos tipos de `JOINs`, funciones de agregación, condicionales (`CASE`, `WHEN`, `ELSE`), subconsultas, CTEs y funciones de fecha.

📢 Tienes las consultas bien explicadas paso a paso en mi canal de YouTube: 🔗 @DataAnalystAtares  

---

1️⃣ **Crea una tabla `prueba_update_salarios` con 5 columnas: `id`, `emp_no`, `old_salary`, `new_salary` y `change_date`. Luego, altera la tabla añadiendo una nueva columna llamada `reason`.**

2️⃣ **Sin hacer JOINs, investiga cómo se relacionan las tablas en la base de datos empleados (ingeniería inversa).**  
Explicamos cómo construir un diagrama entidad-relación para entender la estructura interna de la base de datos, claves primarias y foráneas, y cómo interpretar la cardinalidad de las relaciones.

3️⃣ **Obtén la diferencia en días entre la fecha de contratación de cada empleado y la fecha actual.**

4️⃣ **Muestra la cantidad de empleados por departamento, incluyendo el nombre del departamento.**

5️⃣ **Calcula el salario promedio, mínimo y máximo por título de trabajo.**

6️⃣ **Muestra el número de títulos distintos que ha tenido cada empleado en la empresa.**

7️⃣ **Calcula el salario total pagado por cada departamento.**

8️⃣ **Muestra los departamentos que han tenido más de 3 gerentes diferentes.**

9️⃣ **Encuentra los empleados que han trabajado en más de un departamento simultáneamente.**

🔟 **Muestra los empleados cuyo salario es mayor que el salario promedio de la empresa.**

1️⃣1️⃣ **Encuentra los empleados cuyo salario ha cambiado más de 3 veces.**  
Incluye una versión con y sin CTE.

1️⃣2️⃣ **Muestra los empleados que tienen el mismo salario actual que al momento de ser contratados.**  
Se analiza una opción básica y otra más robusta usando funciones de ventana.

1️⃣3️⃣ **Calcula la duración promedio (en días) de los títulos ocupados por los empleados.**

1️⃣4️⃣ **Muestra los empleados junto con una columna adicional que indique: "Alto salario", "Salario medio" o "Bajo salario" según el monto.**  
Uso de `CASE`, `WHEN`, `THEN`, `ELSE`.

1️⃣5️⃣ **Cuenta la cantidad de empleados actualmente por género en cada departamento.**

1️⃣6️⃣ **Muestra los empleados (con nombres) cuyo salario es el más alto dentro de su departamento.**  
Se utiliza una CTE para identificar los salarios máximos por departamento y se cruza con los empleados correspondientes.

---

🧠 Estos ejercicios están diseñados para ayudarte a aplicar SQL de manera práctica y prepararte para desafíos reales en bases de datos relacionales.  
Puedes encontrar el código completo con todas las respuestas en el archivo `respuestas.sql`.

🔗 GitHub: https://github.com/MiguelAtares  
🔗 YouTube: https://www.youtube.com/@DataAnalystAtares
