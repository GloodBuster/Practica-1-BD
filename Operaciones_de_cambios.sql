-- Elimina la restriccion que valida el StatusEst en la tabla estudiantes
ALTER TABLE estudiantes DROP CONSTRAINT restriccionStatusEst;

-- Eliminar el atributo CodEscuela de estudiantes
ALTER TABLE estudiantes DROP COLUMN CodEscuela;

-- Hacer que el atributo DireccionEst sea nulo
ALTER TABLE estudiantes ALTER COLUMN DireccionEst DROP NOT NULL;

-- Modificar las restricciones de StatusEst para que sus valores tomen las palabras completas
ALTER TABLE estudiantes ADD CONSTRAINT restriccionStatusEst CHECK(StatusEst IN('Activo', 'Retirado', 'No Inscrito', 'Egresado'));

-- Agregar nuevamente el atributo CodEscuela
ALTER TABLE estudiantes ADD COLUMN CodEscuela TEXT REFERENCES escuela(CodEscuela);