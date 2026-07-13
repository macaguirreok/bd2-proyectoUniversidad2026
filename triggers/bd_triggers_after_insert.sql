-- Triggers
-- Los triggers, son disparadores. 
-- es un código que se ejecuta automáticamente cuando ocurre algo en una tabla.
-- Yo no lo llamo, no hacemos CALL trigger... No.
-- se dispara solo, como una alarma.
-- como en la farmacia, cada ver que llamo a una persona, suena una alarma
-- yo no toco la alarma, se dispara sola.
-- El trigger es así, cuando alguien hace un insert, se dispara.
-- Cuando alguien hace un delete, se dispara. Etc.

-- Hay dos momentos: BEFOERE y AFTER.
-- BEFORE: se ejecuta antes que ocurra la acción.
-- "reviso una receta, si esta mal, no la guardo y la rechazo".
-- INSERT --> TRIGGER --> se inserta el dato
-- AFTER: se ejecuta DESPUÉS que ocurrió la acción.
-- "si una receta esta bien, la guardo y la clasifico en carpetas."
-- INSERT --> se inserta el dato --> TRIGGER.

-- Primero creamos la tabla Historial_nota que es sobre la que vamos a
-- agregar los triggers. 
-- NOTA: no tiene fk, porque no partcipa directamente del sistema univ.
USE universidad;

CREATE TABLE historial_notas(
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    alumno VARCHAR(80),
    materia VARCHAR(80),
    nota DECIMAL(4,2),
    accion VARCHAR(20)
)


-- Trigger after insert
-- NOTA: el trigger nunca reemplaza el INSERT normal
---¿hay que hacer un insert normal aparte? --> SI.
-- hacemos un insert notas normal y el trigger se va a ejecutar solito después de eso.
-- y va a haber dos insert. El insert de notas y el insert de historial_notas.

-- El trigger se crea una sola vez.

DELIMITER $$ --> "che, myqls: las instrucciones, terminalas con $$ xq hay muchos ; por eso en END$$ es donde se termina el trigger."
CREATE TRIGGER trg_historial_notas_insert
AFTER INSERT --> trigger de tipo after: después de que la nota sea insertada
ON notas --> la tabla de la cual se hace el trigger 
FOR EACH ROW --> por cada fila afectada: "Si se agregan varias filas juntas, ejecutame el trigger una vez por cada una".
-- O sea, INSERT INTO notas(id_inscripcion, nota) VALUES(1,8),(2,9),(3,10); --> son tres notas agregadas en un solo insert
BEGIN --> comenzamos...

-- Insert al historial
INSERT INTO historial_notas(
    fecha,
    alumno,
    materia,
    nota,
    accion
)

SELECT --> yo esperaba algo como INSERT INTO historial_notas VALUES(...), pero ¿De donde se sacaría el nombre del alumno?
-- Estamos trayendo o seleccionando los datos desde el verdadero insert de notas.
NOW(),
a.nombre,
m.nombre,
NEW.nota, --> NEW es una "foto de la fila recien creada de id_inscripcion y de nota"
-- al hacer NEW.nota la estamos trayendo de ahí a la nota de la fila recién insertada. Esto del NEW lo hace mysql.
'INSERT' --> es OTRA manera de hacer un insert. En vez de VALUES(...) , al poner 'INSERT' despues de NEW.nota,
-- significa: "Insertá lo que devuelva esta consulta" (que no olvidemos que es un select)

FROM inscripciones i --> empezamos con inscripciones, porque nota conoce solo id_inscripcion de la tabla inscripciones.
INNER JOIN alumnos a --> el orden de hacer los inner join con alumnos y materias hubiera sido indistinto.
ON i.id_alumno = a.id_alumno

INNER JOIN materias m 
ON i.id_materia = m.id_materia

WHERE i.id_inscripcion = NEW.id_inscripcion --> NEW.id_inscripcion es el id de la nueva inscripción, sacada de la "foto" NEW creada por mysql.
-- id de la tabla inscripciones = id de la fila nueva (como en NEW.id_inscripcion tenemos un valor ej = 5)
-- lo que realmente se ejecuta es WHERE i.id_inscripcion = 5
END$$ --> acá termina el trigger

DELIMITER ; --> DELIMITER; devuelve a mysql a la normalidad. Las instrucciones vuelven a terminar con ;



--CÓDIGO LIMPIO PARA EJECUTAR: 
DELIMITER $$

CREATE TRIGGER trg_historial_notas_insert

AFTER INSERT

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
    'INSERT'

FROM inscripciones i

INNER JOIN alumnos a
ON i.id_alumno = a.id_alumno

INNER JOIN materias m
ON i.id_materia = m.id_materia

WHERE i.id_inscripcion = NEW.id_inscripcion;

END$$

DELIMITER ;

--Lo hice para ver el id de las incripciones que habia
SELECT * FROM inscripciones;

--INSERT sencillito de notas
INSERT INTO notas(
    id_inscripcion,
    nota,
    fecha
)
VALUES(
    2,
    7.50,
    '2026-08-01'
);

--Ahora vemos si realmente se ejecutó el trigger:
SELECT * FROM historial_notas


