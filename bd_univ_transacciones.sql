-- TRANSACCIONES

-- En este proyecto tenemos una transacción:
-- Se crea la inscripción, y se registra el evento en un historial
-- Las dos operaciones deben hacerse juntas. Si una falla, no se hace ninguna

USE universidad;

-- a : Agrega una tabla "historial"

CREATE TABLE historial_inscripciones(
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL, 
    fecha DATETIME NOT NULL,
    accion VARCHAR(100) NOT NULL
);

SELECT * FROM alumnos;

SELECT * FROM materias;

SELECT * FROM historial_inscripciones;

SELECT * FROM inscripciones;

-- Transacción:

START TRANSACTION;

INSERT INTO inscripciones(
    id_alumno,
    id_materia,
    fecha,
    anio_cursada
)
VALUES(
    1,
    2,
    CURDATE(),
    2027
);

INSERT INTO historial_inscripciones(
    id_alumno,
    id_materia,
    fecha,
    accion
)
VALUES(
    1,
    2,
    NOW(),
    'Nueva inscripción'
);

COMMIT;

-- Si bien esto es suficiente para aprender commit, no sirve para
--aprender un rollback real, para eso hay que agregarle una fk a
-- la tabla de historia.

ALTER TABLE historial_inscripciones
ADD CONSTRAINT fk_historial_alumno
FOREIGN KEY(id_alumno)
REFERENCES alumnos(id_alumno);

-- Ahora si podríamos probar que el rollback va a dar error,
--al no encontrar el alumno 999

START TRANSACTION;

INSERT INTO inscripciones(
    id_alumno,
    id_materia,
    fecha,
    anio_cursada
)
VALUES(
    1,
    2,
    CURDATE(),
    2029
);

INSERT INTO historial_inscripciones(
    id_alumno,
    id_materia,
    fecha,
    accion
)
VALUES(
    999,
    2,
    NOW(),
    'Nueva inscripción'
);

ROLLBACK;