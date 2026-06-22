-- ON DELETE.


--Primero, intentamos borrar un profesor que ya está incripto
-- en una materia, nos debería dar error, no se debería poder borrar
-- porque profesor es (FK) de la tabla materias.

USE universidad;

SELECT * FROM profesores;

DELETE FROM profesores WHERE id_profesor = 1 ;

--La bd no permite borrarlo, porque rompería la integridad referencial.

