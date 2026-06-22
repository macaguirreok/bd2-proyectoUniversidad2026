-- ON DELETE.


--Primero, intentamos borrar un profesor que ya está incripto
-- en una materia, nos debería dar error, no se debería poder borrar
-- porque profesor es (FK) de la tabla materias.

USE universidad;

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