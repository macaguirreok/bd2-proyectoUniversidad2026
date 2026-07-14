-- Trigger after delete
-- En delete, no existe estado NEW. SOLO existe OLD.
-- porque no hay ninguna fila nueva, si justamente fue borrada.

DELIMITER $$

CREATE TRIGGER trg_after_delete_notas
AFTER DELETE
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
OLD.nota,
'DELETE'

FROM inscripciones i 
INNER JOIN alumnos a 
ON i.id_alumno = a.id_alumno

INNER JOIN materias m 
ON i.id_materia = m.id_materia

WHERE i.id_inscripcion = OLD.id_inscripcion;

END$$

DELIMITER ;

-- Probamos si funciona

SELECT * FROM notas;
SELECT * FROM historial_notas ;
DELETE FROM notas
WHERE id_nota = 7;

-- FUNCIONA!!

