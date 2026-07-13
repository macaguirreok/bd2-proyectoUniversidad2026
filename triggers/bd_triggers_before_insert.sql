
-- Trigger before insert
-- Recordando que before = "todavía no pasó" 
-- se utiliza normalmente para validar datos, corregirlos, completar automáticamente
-- no podemos usar historial_nota para los before porque no tiene sentido
-- los after si tienen sentido porque es para agregar, modificar y eliminar notas

USE universidad;

-- Este trigger no va a permitir que la nota que se intente ingresar
-- tenga una fecha posterior a la fecha de inscripción del alumno.

DELIMITER $$

CREATE TRIGGER trg_before_insert_fecha_notas
BEFORE INSERT
ON notas 
FOR EACH ROW 

BEGIN

DECLARE fecha_inscripcion DATE; --> Creamos variable fecha_inscripcion de tipo DATE.

-- NEW. = foto de cada uno de los dato ingresados a la tabla elegida despues de ON (en este caso notas).

-- De la tabla inscripciones, sacamos la fecha con la que vamos a comparar la fecha
-- con el id sacado de NEW.id_inscripcion del NEW cuando se hace el ingreso de datos a la tb notas 
SELECT fecha 
INTO fecha_inscripcion --> guarda la fecha encontrada en la tb inscripc. en la var fecha_inscripcion
--sino, sería un select normal (SELECT fecha FROM inscripciones WHERE ....)
-- al no mostrarse el select, se guarda la infro en la var fecha_inscripcion
FROM inscripciones
WHERE id_inscripcion = NEW.id_inscripcion;

 IF NEW.fecha < fecha_inscripcion THEN
        SIGNAL SQLSTATE '45000' --> lanzá un error, código de error definido por el programador.
        SET MESSAGE_TEXT = 'La fecha de la nota no puede ser anterior a la fecha de inscripción.';
    END IF;

END$$

DELIMITER ;


-- Verdadero trigger sin anotaciones, para ejecutar:
DELIMITER $$

CREATE TRIGGER trg_before_insert_fecha_notas
BEFORE INSERT
ON notas 
FOR EACH ROW 

BEGIN

DECLARE fecha_inscripcion DATE; 

SELECT fecha 
INTO fecha_inscripcion 
FROM inscripciones
WHERE id_inscripcion = NEW.id_inscripcion;

 IF NEW.fecha < fecha_inscripcion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la nota no puede ser anterior a la fecha de inscripción.';
    END IF;

END$$

DELIMITER ;

-- probamos si funciona:

SELECT * FROM inscripciones;

INSERT INTO notas
(id_inscripcion, nota, fecha)

VALUES

(2,9,'2026-06-10');

-- Funciona!! al intentar darle run a este insert into notas... sale el cartel de por que no se puede.