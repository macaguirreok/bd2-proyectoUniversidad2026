USE universidad;

-- Una view (vista) es una consulta guardada.
-- es para no estar haciendo

-- VISTA 1
-- Alumnos con sus materias

CREATE VIEW vista_alumnos_materias AS --quiero crear una vista, de nombre vista...
SELECT
a.id_alumno, --de la tabla alumnos, select id alumno
a.nombre AS alumno, --tabla alumno, slct nombre del alumno AS alumno
m.nombre AS materia, -- tabla materia, slct nombre de la materia AS materia
i.anio_cursada -- de la tabla inscripciones, mostrar el año de cursada
FROM alumnos a -- Todos esos datos, los sacamos de la tabla alumnos, que se va a llamar "a"
INNER JOIN inscripciones i -- une la tabla alumnos, a la de inscripciones, y la llama i a la tabla inscripciones
ON a.id_alumno = i.id_alumno --mediante estos id las unimos
INNER JOIN materias m --también unimos con la tabla materias, llamada "m"
ON i.id_materia = m.id_materia; -- mediante esos id

SELECT * FROM vista_alumnos_materias;

-- INNER JOIN:
-- inner significa "unime las filas que coincidan". Porque si existe el alumno pedro, pero nunca se inscribió, pedro no aparece.
-- Las (FK) no solo sirven para impedir errores, tambien sirven para
-- poder hacer los join.
-- Las (FK) tienen dos trabajos, la primera es mantener la integridad referencial,
-- y el otro es permitir relacionar tablas.


-- VISTA 2
-- Profesores con materias

CREATE VIEW vista_profesores_materias AS
SELECT
p.nombre AS profesor,
m.nombre AS materia
FROM profesores p
INNER JOIN materias m
ON p.id_profesor = m.id_profesor;

SELECT * FROM vista_profesores_materias;


--NOTA: las vistas NO guardan datos.
-- Las vistas guardan una CONSULTA.
-- Es como hacer un select común, no guardas ningún dato, simplemente
-- te muestra los datos que le pedis, acá igual, solo te muestra los datos
-- lo que guardas en la view, es la FLOR de consulta, para no estar
-- escribiendo a cada rato ese SUPER SELECT LARGUISIMO.