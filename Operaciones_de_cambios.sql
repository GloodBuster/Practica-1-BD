--Eliminar la restricción de StatusEst de la tabla estudiantes--
ALTER TABLE Estudiantes ALTER COLUMN StatusEst TYPE VARCHAR(1);

--Eliminar el atributo CodEscuela de la tabla estudiantes--
ALTER TABLE Estudiantes DROP COLUMN CodEscuela;

--Hacer nulo el atributo DireccionEst de la tabla estudiantes--
ALTER TABLE Estudiantes ALTER COLUMN DireccionEst DROP NOT NULL;

--Establecer los nuevos valores admitidos por la columna StatusEst--
CREATE TYPE statusStudent2 AS ENUM ('Activo', 'Retirado', 'No inscrito', 'Egresado');

--Cambiar los valores admitidos por la columna StatusEst--
ALTER TABLE Estudiantes ALTER COLUMN StatusEst TYPE statusStudent2 USING StatusEst :: statusStudent2;

--Volver a añadir la columna CodEscuela a la tabla estudiantes--
ALTER TABLE Estudiantes ADD COLUMN CodEscuela VARCHAR(10) NOT NULL;