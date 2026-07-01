-- ON DELETE.


--Primero, intentamos borrar un profesor que ya está incripto
-- en una materia, nos debería dar error, no se debería poder borrar
-- porque profesor es (FK) de la tabla materias.

USE universidad;


-- SHOW CREATE TABLE.... muestra como fue creada la tabla, 
--en este caso necesitamos ver las constraints creadas automaticamente
--al hacer las referencias de fk, de integridad referencial, para
--borrarlas manualmente y cambiarlas.
SHOW CREATE TABLE materias;

SELECT * FROM profesores;

DELETE FROM profesores WHERE id_profesor = 1 ;

--La bd no permite borrarlo, porque rompería la integridad referencial.

-- pero ahora, lo vamos a cambiar para que ya no sea un comportamiento restrictivo
-- por defecto, ahora le vamos a poner el on delete restrict:

--COMENZAMOS:

-- A: eliminamos la restricción de tipo FK vieja: materias_ibfk_1
--Solo elimina la regla vieja, no elimina id_profesor ni borra los datos

ALTER TABLE materias
DROP FOREIGN KEY materias_ibfk_1;

-- Ahora, creamos la nueva FK con ON DELETE explícito

ALTER TABLE materias
ADD CONSTRAINT fk_materia_profesor
FOREIGN KEY(id_profesor)
REFERENCES profesores(id_profesor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

--Insertamos un nuevo profesor
INSERT INTO profesores(nombre)
VALUES('Luci Gonzalez');

SELECT * FROM materias;

INSERT INTO materias(nombre,id_profesor)
VALUES('lingüistica',3);

-- No nos debería dejar borrar al profesor luci, id 3
--porque justamente es la restricción que acabamos de modificar
DELETE FROM profesores
WHERE id_profesor = 1;

-- funciona el update profesores on cascade?
--cambiamos el id de profe luci de 3 a 10:

UPDATE profesores
SET id_profesor = 10
WHERE id_profesor = 3;

-- Tabla inscripciones
-- Se va a agregar la restricción ON DELETE CASCADE para que
--si se borra un alumno, todas las inscripciones suyas se borren
--ya que no nos sirve tener esos datos huérfanos.
-- NO va ON UPDATE CASCADE porque no tiene sentido que le cambiemos
--el id a un alumno. Directamente si no va, lo borramos.



-- SHOW CREATE TABLE.... muestra como fue creada la tabla, 
--en este caso necesitamos ver las constraints creadas automaticamente
--al hacer las referencias de fk, de integridad referencial, para
--borrarlas manualmente y cambiarlas.
SHOW CREATE TABLE inscripciones;

-- Eliminamos la constraint creada por mysql, que es: inscripciones_ibfk_1
--entre la tabla inscripciones, y la tabla alumnos
ALTER TABLE inscripciones
DROP FOREIGN KEY inscripciones_ibfk_1 ;

--esta constraint, es de TIPO foreign key. NO es la foreign key.

ALTER table inscripciones
ADD CONSTRAINT fk_inscripciones_alumnos
FOREIGN KEY (id_alumno)
REFERENCES alumnos(id_alumno)
ON DELETE CASCADE;

SELECT * FROM alumnos;

SELECT * FROM inscripciones;

DELETE FROM alumnos
WHERE id_alumno = 2;

-- Ahora borramos la segunda constraint creada automaticamente por mysql
-- referida a la tabla materias

ALTER table inscripciones 
DROP FOREIGN KEY inscripciones_ibfk_2;

-- Ahora escribimos la restricción manualmente, o sea que va a suceder
-- con inscripción, si se borra una materia

-- ON DELETE RESTRICT: no se puede eliminar materias, cuando ya
-- tengan inscripciones realizadas.

ALTER TABLE inscripciones
ADD CONSTRAINT fk_inscripciones_materias
FOREIGN KEY (id_materia)
REFERENCES materias(id_materia)
ON DELETE RESTRICT;

-- Ahora solo nos fijamos si funciona

SELECT * FROM materias;

DELETE FROM materias
WHERE id_materia = 2;


-- Tabla notas
-- ON DELETE CASCADE

-- a: buscar como se llama la restricción automática que se hace
--cuando haces la relación entre dos tablas al crearlas

SHOW CREATE TABLE notas;

-- b : borrar la restricción automática

ALTER TABLE notas
DROP FOREIGN KEY notas_ibfk_1;

-- c : Agregar la restricción

ALTER TABLE notas
ADD CONSTRAINT fk_notas_inscripcion
FOREIGN KEY (id_inscripcion)
REFERENCES inscripciones(id_inscripcion)
ON DELETE CASCADE;

-- D: probar que funcione

SELECT * FROM notas;

DELETE FROM inscripciones
WHERE id_inscripcion = 1;
