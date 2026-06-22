CREATE DATABASE universidad
    DEFAULT CHARACTER SET = 'utf8mb4';


USE universidad;

CREATE TABLE profesores(
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE alumnos(
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, 
    edad INT NOT NULL CHECK(edad > 0 AND edad <= 150)
);

CREATE TABLE materias(
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL, 

    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor)
);

CREATE TABLE inscripciones(
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL,
    fecha DATE NOT NULL,

    FOREIGN KEY(id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY(id_materia) REFERENCES materias(id_materia)
);

CREATE TABLE notas(
    id_notas INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    nota DECIMAL(4,2) NOT NULL,
    fecha DATE NOT NULL,

    FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion)
);


INSERT INTO profesores(nombre)
VALUES ('Juan Perez');

INSERT INTO materias(nombre, id_profesor)
VALUES ('Base de datos' , 1);

INSERT INTO alumnos(nombre, edad)
VALUES ('Macarena Aguirre' , 28);

INSERT INTO inscripciones(
id_alumno,
id_materia,
fecha,
anio_cursada
)
VALUES(
1,
1,
'2026-06-16',
2027
);

--NOTAS: no permite agregar una nota de una inscripción
-- que no exista :D

INSERT INTO notas(
    id_inscripcion,
    nota,
    fecha
)VALUES(
    5,
    9.00 ,
    '2026-06-16'
);

DESCRIBE notas;

SHOW CREATE TABLE notas;

--* PROBLEMA: sin querer presioné dos veces la misma fila de inscripción
-- que estaba agregando, y se guardaron dos veces la misma.

-- Nueva regla:
-- anio_cursada no va a permitir que existan dos inscripciones iguales.
-- Primero agregamos la columna anio_cursada

-- A la tabla inscripciones que ya existe, agregale una columna
-- llamada anio_cursada de tipo entero y obligatoria

ALTER TABLE inscripciones
ADD COLUMN anio_cursada INT NOT NULL;

--Traducido del idioma SQL al idioma humano:
--Vamos a agregar una restricción(CONSTRAINT) y quiero llamarla unica_inscripcion
--"La universidad tiene una regla: un alumno no puede anotarse dos
-- veces a la misma materia en el mismo año. La base de datos va a 
-- cuidar esa regla por mí."

ALTER TABLE inscripciones
ADD CONSTRAINT unica_inscripcion -- Le ponemos un NOMBRE a la regla que estamos creando.
UNIQUE(id_alumno, id_materia, anio_cursada);


-- Intentamos romper la bd
SELECT * FROM inscripciones;

SELECT * FROM profesores;

SELECT * FROM materias;

SELECT * FROM alumnos;

SELECT * FROM notas;

-- PRUEBA INTEGRIDAD : intengar agregar una materia, con una profesora
-- que no existe.
-- Insertamos tres materias al mismo tiempo, pero el id:2 de profesora no existe
-- deberia saltar un mensaje de que no se puede agregar la materia matematica
INSERT INTO materias(id_profesor,nombre)
VALUES
(1,'Base de Datos'),
(1,'Programacion'),
(2,'Matematica');

-- si, nos da error justamente porque no existe el id 2, ahora intento
--agregar sin el id 2

INSERT INTO materias(id_profesor,nombre)
VALUES
(1,'Programacion'),
(1,'Matematica');


--PRUEBA
-- Intentamos romper la FK
-- Debería pasar que al intentar agregar na materia con profesor 99
--(que no existe), deberia saltar un cartel que diga no existe el prof 99

INSERT INTO materias(id_profesor, nombre)
VALUES
( 99 , 'Juana perez');

-- Éxito ! no se puede agregar el prof. con id 99 porque no existe.


