--Dominios
CREATE TYPE category AS ENUM ('A', 'I', 'G', 'S', 'T');
CREATE TYPE dedication AS ENUM ('TC', 'MT', 'TV');
CREATE TYPE statusProfessor AS ENUM ('A', 'R', 'P', 'J');
CREATE TYPE paymentMethods AS ENUM ('T', 'J', 'D');
CREATE TYPE currency AS ENUM ('B', 'D', 'P');
CREATE TYPE statusStudent AS ENUM ('A', 'R', 'N', 'E');
CREATE TYPE statusGrade AS ENUM ('A', 'R', 'E', 'X');
CREATE TYPE taxonomy AS ENUM ('TA1','TA2','TA3','TA4','TA5','TA6','TA7','TA8','TA9');
CREATE TYPE statusSubject AS ENUM ('V', 'R', 'E');

CREATE DOMAIN dom_nombre AS VARCHAR(50) NOT NULL;
CREATE DOMAIN dom_fecha AS DATE NOT NULL;

CREATE TYPE Profesores(
	--Atributos
	CedulaProf VARCHAR(8) PRIMARY KEY,
	NombreP dom_nombre,
	DireccionP VARCHAR(60) NOT NULL,
	TelefonoP VARCHAR(11) NULL,
	Categoria category NOT NULL,
	Dedicacion dedication NOT NULL,
	FechaIng dom_fecha,
	FechaEgr dom_fecha,
	StatusP StatusProfessor NOT NULL,
	CHECK(FechaIng < FechaEgr)
);

CREATE TABLE Secciones(
	--Atributos
	NRC VARCHAR(5) PRIMARY KEY,
	CodAsignatura VARCHAR(7) NOT NULL,
	Lapso VARCHAR(6) NOT NULL,
	CedulaProf VARCHAR(8) NOT NULL
);

CREATE TABLE Pagos_Realizados(
	--Atributos
	NumFactura VARCHAR(10) PRIMARY KEY,
	IdEstudiante SERIAL NOT NULL,
	FechaEmision dom_fecha NOT NULL,
	TipoPago paymentMethods NOT NULL,
	TipoMoneda currency NOT NULL,
	Monto DECIMAL NOT NULL CHECK(Monto > 0)
);

CREATE TABLE Estudiantes(
	--Atributos
	IdEstudiante SERIAL PRIMARY KEY,
	Cedula VARCHAR(8) UNIQUE NOT NULL,
	NombreEst dom_nombre,
	CodEscuela VARCHAR(10) NOT NULL,
	DireccionEst VARCHAR(60) NOT NULL,
	TelefonoEst VARCHAR(11) NULL,
	FechaNac dom_fecha,
	StatusEst statusStudent NOT NULL
);

--Indices
CREATE INDEX idx_nombre_est ON Estudiantes(NombreEst);
CREATE INDEX idx_cod_escuela ON Estudiantes(CodEscuela)
	
CREATE TABLE Escuela(
	--Atributos
	CodEscuela VARCHAR(10) PRIMARY KEY,
	NombreEsc VARCHAR(20) UNIQUE NOT NULL,
	FechaCreacion dom_fecha
);

--Indices
CREATE INDEX idx_nombre_esc ON Escuela(NombreEsc);

CREATE TABLE Calificaciones(
	--Atributos
	IdEstudiante SERIAL,
	NRC VARCHAR(5) NOT NULL,
	Calificacion integer NOT NULL CHECK(Calificacion >= 0 and Calificacion <=20),
	EstatusN statusGrade NOT NULL,
	PRIMARY KEY(IdEstudiante, NRC)
);

CREATE TABLE Asignaturas(
	--Atributos
	CodAsignatura VARCHAR(7) PRIMARY KEY,
	NombreAsig VARCHAR(30) UNIQUE NOT NULL,
	UC DECIMAL NOT NULL,
	Semestre INTEGER NOT NULL,
	Taxonomia taxonomy NOT NULL,
	StatusA statusSubject NOT NULL
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