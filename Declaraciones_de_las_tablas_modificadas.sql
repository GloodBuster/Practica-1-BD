--Dominios
CREATE DOMAIN dom_nombre AS TEXT NOT NULL;
CREATE DOMAIN dom_fecha AS DATE NOT NULL;

CREATE TABLE Profesores(
  --Atributos
  CedulaProf TEXT PRIMARY KEY,
  NombreP dom_nombre,
  DireccionP TEXT NOT NULL,
  TelefonoP TEXT NULL,
  Categoria TEXT NOT NULL
    CONSTRAINT restriccionCategoria
    CHECK(Categoria IN ('A', 'I', 'G', 'S', 'T')),
  Dedicacion TEXT NOT NULL 
    CONSTRAINT restriccionDedicacion 
    CHECK(Dedicacion IN ('TC', 'MT', 'TV')),
  FechaIng dom_fecha,
  FechaEgr dom_fecha,
  StatusP TEXT NOT NULL
    CONSTRAINT restriccionStatusP
    CHECK(StatusP IN ('A', 'R', 'P', 'J')),
  CONSTRAINT restriccionFecha CHECK(FechaIng < FechaEgr)
);

CREATE TABLE Secciones(
  --Atributos
  NRC TEXT PRIMARY KEY,
  CodAsignatura TEXT NOT NULL,
  Lapso TEXT NOT NULL,
  CedulaProf TEXT NOT NULL
);

CREATE TABLE Pagos_Realizados(
  --Atributos
  NumFactura TEXT PRIMARY KEY,
  IdEstudiante SERIAL NOT NULL,
  FechaEmision dom_fecha NOT NULL,
  TipoPago TEXT NOT NULL
    CONSTRAINT restriccionPago
    CHECK(TipoPago IN('T', 'J', 'D')),
  TipoMoneda TEXT NOT NULL
    CONSTRAINT restriccionMoneda
    CHECK(TipoMoneda IN('B', 'D', 'P')),
  Monto DECIMAL NOT NULL 
    CONSTRAINT restriccionMonto
    CHECK(Monto > 0)
);

CREATE TABLE Estudiantes(
  --Atributos
  IdEstudiante SERIAL PRIMARY KEY,
  Cedula TEXT UNIQUE NOT NULL,
  NombreEst dom_nombre,
  CodEscuela TEXT NOT NULL,
  DireccionEst TEXT NULL,
  TelefonoEst TEXT NULL,
  FechaNac dom_fecha,
  StatusEst TEXT NOT NULL
    CONSTRAINT restriccionStatusEst
    CHECK(StatusEst IN('Activo', 'Retirado', 'No Inscrito', 'Egresado'))
);

--Indices
CREATE INDEX idx_nombre_est ON Estudiantes(NombreEst);
CREATE INDEX idx_cod_escuela ON Estudiantes(CodEscuela);
  
CREATE TABLE Escuela(
  --Atributos
  CodEscuela TEXT PRIMARY KEY,
  NombreEsc TEXT UNIQUE NOT NULL,
  FechaCreacion dom_fecha
);

--Indices
CREATE INDEX idx_nombre_esc ON Escuela(NombreEsc);

CREATE TABLE Calificaciones(
  --Atributos
  IdEstudiante SERIAL,
  NRC TEXT NOT NULL,
  Calificacion integer NOT NULL 
    CONSTRAINT restriccionCalificacion
    CHECK(Calificacion >= 0 and Calificacion <=20),
  EstatusN TEXT NOT NULL
    CONSTRAINT restriccionEstatusN
    CHECK(EstatusN IN('A', 'R', 'E', 'X')),
  PRIMARY KEY(IdEstudiante, NRC)
);

CREATE TABLE Asignaturas(
  --Atributos
  CodAsignatura TEXT PRIMARY KEY,
  NombreAsig TEXT UNIQUE NOT NULL,
  UC DECIMAL NOT NULL,
  Semestre INTEGER NOT NULL,
  Taxonomia TEXT NOT NULL
    CONSTRAINT restriccionTaxonomia
    CHECK(Taxonomia ~ '^TA[1-9]$'),
  StatusA TEXT NOT NULL
    CONSTRAINT restriccionStatusA
    CHECK(StatusA IN('V', 'R', 'E'))
);

--Indices
CREATE INDEX idx_nombre_asig on Asignaturas(NombreAsig);

--Declaración de llaves foráneas 
ALTER TABLE Calificaciones 
  ADD CONSTRAINT fk_nrc FOREIGN KEY (NRC) REFERENCES Secciones(NRC) 
    ON UPDATE cascade 
    ON DELETE restrict;

ALTER TABLE Calificaciones 
  ADD CONSTRAINT fk_id_estudiante_calificaciones FOREIGN KEY (IdEstudiante) REFERENCES Estudiantes(IdEstudiante) 
    ON UPDATE cascade 
    ON DELETE restrict;

ALTER TABLE Estudiantes 
  ADD CONSTRAINT fk_cod_escuela FOREIGN KEY (CodEscuela) REFERENCES Escuela(CodEscuela) 
    ON UPDATE cascade 
    ON DELETE restrict;

ALTER TABLE Pagos_Realizados 
  ADD CONSTRAINT fk_id_estudiante_pagos FOREIGN KEY (IdEstudiante) REFERENCES Estudiantes(IdEstudiante) 
    ON UPDATE cascade 
    ON DELETE restrict;

ALTER TABLE Secciones 
  ADD CONSTRAINT fk_cedula_prof FOREIGN KEY (CedulaProf) REFERENCES Profesores(CedulaProf) 
    ON UPDATE cascade 
    ON DELETE restrict;

ALTER TABLE Secciones 
  ADD CONSTRAINT fk_cod_asignatura FOREIGN KEY (CodAsignatura) REFERENCES Asignaturas(CodAsignatura) 
    ON UPDATE cascade 
    ON DELETE restrict;