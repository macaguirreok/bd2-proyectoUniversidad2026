-- Ejercicios, sobre mi propia bd

USE universidad;

--1) Mostrar todos los alumnos
SELECT * FROM alumnos;

--2) Mostrar solamente el nombre de todos los alumnos
SELECT nombre FROM alumnos;

--3) Mostrar todos los profesores ordenados alfabeticamente
SELECT * FROM profesores;
-- ¿ qué columna define el oden alfabético? --> nombre
-- Entonces ¿Cómo le digo a SQL que ordene por una columna?
-- ORDER BY

SELECT * FROM profesores
ORDER BY nombre;

-- SELECT * FROM profesores ORDER BY nombre; es igual a escribir:
-- SELECT * FROM profesores ORDER BY nombre ASC; Si fuese al revés, sería DESC;


-- 4) Mostrar todas las materias
SELECT * FROM materias;

--5) Mostrar solamente las notas mayores a 8.
SELECT  nota FROM notas WHERE nota > 8;
--¿y si quisiéramos saber de quienes son esas notas?

--primero escribimos SELECT FROM ..... y despues ponemos el "que" entre
-- SELECT y FROM.

SELECT a.nombre,
       n.nota
FROM notas n
INNER JOIN inscripciones i 
ON n.id_inscripcion = i.id_inscripcion
INNER JOIN alumnos a 
ON i.id_alumno = a.id_alumno
 WHERE n.nota > 8


--6) Mostrar todos los alumnos mayores de 25 años.
SELECT * FROM alumnos WHERE edad > 25;

--7) Mostrar todas las notas entre 7 y 9.
SELECT nota FROM notas WHERE nota BETWEEN 7 AND 9;
--NOTA: between incluye ambos extremos.

--8)Mostrar todas las inscripciones del año 2026.

SELECT * FROM inscripciones WHERE anio_cursada = 2026;
--¿y si quiero saber de quién es la inscripción?
SELECT i.anio_cursada,
a.nombre AS alumno,
m.nombre AS materia
FROM inscripciones i 
INNER JOIN alumnos a 
ON i.id_alumno = a.id_alumno
INNER JOIN materias m 
ON i.id_materia = m.id_materia
WHERE i.anio_cursada = 2026

--Los "AS" sirven para que al mostrar las consultas, esas columnas
--tengan esos nombrecitos después del AS.

--9) Mostrar todas las materias cuyo nombre empiece con "M".
SELECT nombre FROM materias;
SELECT nombre FROM materias WHERE nombre LIKE 'M%';

--La regla para acordarte:
--'M%' → empieza con M
--'%M' → termina con M
--'%M%' → contiene M