
-- MISMO archiov que bd-universidad.sql, solo que en limpio
-- CREACIÓN DE BASE DE DATOS

CREATE DATABASE universidad
DEFAULT CHARACTER SET = 'utf8mb4';

USE universidad;


-- TABLA PROFESORES

CREATE TABLE profesores(
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


-- TABLA ALUMNOS

CREATE TABLE alumnos(
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL CHECK(edad > 0 AND edad <= 150)
);


-- TABLA MATERIAS

CREATE TABLE materias(
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,

    FOREIGN KEY(id_profesor)
    REFERENCES profesores(id_profesor)  --integriadad referencial
);


-- TABLA INSCRIPCIONES

CREATE TABLE inscripciones(
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL,
    fecha DATE NOT NULL,
    anio_cursada INT NOT NULL,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_materia)
    REFERENCES materias(id_materia),

    CONSTRAINT unica_inscripcion
    UNIQUE(id_alumno, id_materia, anio_cursada)
);


-- TABLA NOTAS

CREATE TABLE notas(
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    nota DECIMAL(4,2) NOT NULL CHECK(nota >= 1 AND nota <= 10),
    fecha DATE NOT NULL,

    FOREIGN KEY(id_inscripcion)
    REFERENCES inscripciones(id_inscripcion)
);



-- =========================
-- CARGA DE DATOS DE PRUEBA
-- =========================


-- PROFESORES

INSERT INTO profesores(nombre)
VALUES
('Juan Perez'),
('Ana Gomez');


-- ALUMNOS

INSERT INTO alumnos(nombre, edad)
VALUES
('Macarena Aguirre', 28),
('Pedro Diaz', 25);



-- MATERIAS

INSERT INTO materias(nombre, id_profesor)
VALUES
('Base de Datos', 1),
('Programacion', 1),
('Matematica', 2);



-- INSCRIPCIONES

INSERT INTO inscripciones(
    id_alumno,
    id_materia,
    fecha,
    anio_cursada
)
VALUES
(1, 1, '2026-06-16', 2026),
(1, 2, '2026-06-16', 2026),
(2, 1, '2026-06-16', 2026);



-- NOTAS

INSERT INTO notas(
    id_inscripcion,
    nota,
    fecha
)
VALUES
(1, 9.00, '2026-06-20'),
(1, 8.50, '2026-07-20'),
(2, 10.00, '2026-06-20');



-- =========================
-- CONSULTAS PARA VER DATOS
-- =========================

SELECT * FROM profesores;

SELECT * FROM alumnos;

SELECT * FROM materias;

SELECT * FROM inscripciones;

SELECT * FROM notas;