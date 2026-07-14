
-- Trigger: after update
-- Sobre la tabla notas.
-- (El trigger, se hace sobre tb notas, y que repercuta en historial_notas es otra cosa.)

-- El "NEW", ahora representa a la fila YA actualizada.
-- Acá en update, existen dos fotos. NEW y OLD. Para el valor actualizado es el NEW.

USE universidad;

DELIMITER $$

CREATE TRIGGER trg_after_update_notas
AFTER UPDATE
ON notas
FOR EACH ROW

BEGIN

INSERT INTO historial_notas(
fecha,
alumno,
materia,
nota,
accion
)

SELECT 
NOW(),
a.nombre,
m.nombre,
NEW.nota,
'UPDATE'

FROM inscripciones i
INNER JOIN alumnos a 
ON i.id_alumno = a.id_alumno

INNER JOIN materias m 
ON i.id_materia = m.id_materia

WHERE i.id_inscripcion = NEW.id_inscripcion;

END $$


DELIMITER ;


-- Hacemos un update notas para ver si el trigger funciona
-- recordemos, que queremos que cada vez que se modifica una nota, se registre en el historial

SELECT * FROM notas;
SELECT * FROM historial_notas;

UPDATE notas
SET nota = 10.00 WHERE id_nota = 6;

--NOTA: si se actualizó!! solo ver bien que exista el id_nota al q se quiere cambiar la nota.
-- UPDATE: son los únicos que tienen acceso al estado anterior (OLD) y al nuevo (NEW).
