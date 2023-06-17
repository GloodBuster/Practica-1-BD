--------------------------------------------------------------------------------------
-- Table: public.asignaturas

-- DROP TABLE IF EXISTS public.asignaturas;

CREATE TABLE IF NOT EXISTS public.asignaturas
(
    codasignatura text COLLATE pg_catalog."default" NOT NULL,
    nombreasig text COLLATE pg_catalog."default" NOT NULL,
    uc numeric NOT NULL,
    semestre integer NOT NULL,
    taxonomia text COLLATE pg_catalog."default" NOT NULL,
    statusa text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT asignaturas_pkey PRIMARY KEY (codasignatura),
    CONSTRAINT asignaturas_nombreasig_key UNIQUE (nombreasig),
    CONSTRAINT restricciontaxonomia CHECK (taxonomia ~ '^TA[1-9]$'::text),
    CONSTRAINT restriccionstatusa CHECK (statusa = ANY (ARRAY['V'::text, 'R'::text, 'E'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.asignaturas
    OWNER to postgres;
-- Index: idx_nombre_asig

-- DROP INDEX IF EXISTS public.idx_nombre_asig;

CREATE INDEX IF NOT EXISTS idx_nombre_asig
    ON public.asignaturas USING btree
    (nombreasig COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
--------------------------------------------------------------------------------------
-- Table: public.calificaciones

-- DROP TABLE IF EXISTS public.calificaciones;

CREATE TABLE IF NOT EXISTS public.calificaciones
(
    idestudiante integer NOT NULL DEFAULT nextval('calificaciones_idestudiante_seq'::regclass),
    nrc text COLLATE pg_catalog."default" NOT NULL,
    calificacion integer NOT NULL,
    estatusn text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT calificaciones_pkey PRIMARY KEY (idestudiante, nrc),
    CONSTRAINT fk_id_estudiante_calificaciones FOREIGN KEY (idestudiante)
        REFERENCES public.estudiantes (idestudiante) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_nrc FOREIGN KEY (nrc)
        REFERENCES public.secciones (nrc) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT restriccioncalificacion CHECK (calificacion >= 0 AND calificacion <= 20),
    CONSTRAINT restriccionestatusn CHECK (estatusn = ANY (ARRAY['A'::text, 'R'::text, 'E'::text, 'X'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.calificaciones
    OWNER to postgres;
--------------------------------------------------------------------------------------
-- Table: public.escuela

-- DROP TABLE IF EXISTS public.escuela;

CREATE TABLE IF NOT EXISTS public.escuela
(
    codescuela text COLLATE pg_catalog."default" NOT NULL,
    nombreesc text COLLATE pg_catalog."default" NOT NULL,
    fechacreacion dom_fecha,
    CONSTRAINT escuela_pkey PRIMARY KEY (codescuela),
    CONSTRAINT escuela_nombreesc_key UNIQUE (nombreesc)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.escuela
    OWNER to postgres;
-- Index: idx_nombre_esc

-- DROP INDEX IF EXISTS public.idx_nombre_esc;

CREATE INDEX IF NOT EXISTS idx_nombre_esc
    ON public.escuela USING btree
    (nombreesc COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
--------------------------------------------------------------------------------------
--- Table: public.estudiantes

-- DROP TABLE IF EXISTS public.estudiantes;

CREATE TABLE IF NOT EXISTS public.estudiantes
(
    idestudiante integer NOT NULL DEFAULT nextval('estudiantes_idestudiante_seq'::regclass),
    cedula text COLLATE pg_catalog."default" NOT NULL,
    nombreest dom_nombre COLLATE pg_catalog."default",
    direccionest text COLLATE pg_catalog."default",
    telefonoest text COLLATE pg_catalog."default",
    fechanac dom_fecha,
    statusest text COLLATE pg_catalog."default" NOT NULL,
    codescuela text COLLATE pg_catalog."default",
    CONSTRAINT estudiantes_pkey PRIMARY KEY (idestudiante),
    CONSTRAINT estudiantes_cedula_key UNIQUE (cedula),
    CONSTRAINT estudiantes_codescuela_fkey FOREIGN KEY (codescuela)
        REFERENCES public.escuela (codescuela) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT restriccionstatusest CHECK (statusest = ANY (ARRAY['Activo'::text, 'Retirado'::text, 'No Inscrito'::text, 'Egresado'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.estudiantes
    OWNER to postgres;
-- Index: idx_nombre_est

-- DROP INDEX IF EXISTS public.idx_nombre_est;

CREATE INDEX IF NOT EXISTS idx_nombre_est
    ON public.estudiantes USING btree
    (nombreest COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
--------------------------------------------------------------------------------------
-- Table: public.pagos_realizados

-- DROP TABLE IF EXISTS public.pagos_realizados;

CREATE TABLE IF NOT EXISTS public.pagos_realizados
(
    numfactura text COLLATE pg_catalog."default" NOT NULL,
    idestudiante integer NOT NULL DEFAULT nextval('pagos_realizados_idestudiante_seq'::regclass),
    fechaemision dom_fecha NOT NULL,
    tipopago text COLLATE pg_catalog."default" NOT NULL,
    tipomoneda text COLLATE pg_catalog."default" NOT NULL,
    monto numeric NOT NULL,
    CONSTRAINT pagos_realizados_pkey PRIMARY KEY (numfactura),
    CONSTRAINT fk_id_estudiante_pagos FOREIGN KEY (idestudiante)
        REFERENCES public.estudiantes (idestudiante) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT restriccionpago CHECK (tipopago = ANY (ARRAY['T'::text, 'J'::text, 'D'::text])),
    CONSTRAINT restriccionmoneda CHECK (tipomoneda = ANY (ARRAY['B'::text, 'D'::text, 'P'::text])),
    CONSTRAINT restriccionmonto CHECK (monto > 0::numeric)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pagos_realizados
    OWNER to postgres;
--------------------------------------------------------------------------------------
-- Table: public.profesores

-- DROP TABLE IF EXISTS public.profesores;

CREATE TABLE IF NOT EXISTS public.profesores
(
    cedulaprof text COLLATE pg_catalog."default" NOT NULL,
    nombrep dom_nombre COLLATE pg_catalog."default",
    direccionp text COLLATE pg_catalog."default" NOT NULL,
    telefonop text COLLATE pg_catalog."default",
    categoria text COLLATE pg_catalog."default" NOT NULL,
    dedicacion text COLLATE pg_catalog."default" NOT NULL,
    fechaing dom_fecha,
    fechaegr dom_fecha,
    statusp text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT profesores_pkey PRIMARY KEY (cedulaprof),
    CONSTRAINT restriccioncategoria CHECK (categoria = ANY (ARRAY['A'::text, 'I'::text, 'G'::text, 'S'::text, 'T'::text])),
    CONSTRAINT restricciondedicacion CHECK (dedicacion = ANY (ARRAY['TC'::text, 'MT'::text, 'TV'::text])),
    CONSTRAINT restriccionstatusp CHECK (statusp = ANY (ARRAY['A'::text, 'R'::text, 'P'::text, 'J'::text])),
    CONSTRAINT restriccionfecha CHECK (fechaing::date < fechaegr::date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.profesores
    OWNER to postgres;
--------------------------------------------------------------------------------------
-- Table: public.secciones

-- DROP TABLE IF EXISTS public.secciones;

CREATE TABLE IF NOT EXISTS public.secciones
(
    nrc text COLLATE pg_catalog."default" NOT NULL,
    codasignatura text COLLATE pg_catalog."default" NOT NULL,
    lapso text COLLATE pg_catalog."default" NOT NULL,
    cedulaprof text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT secciones_pkey PRIMARY KEY (nrc),
    CONSTRAINT fk_cedula_prof FOREIGN KEY (cedulaprof)
        REFERENCES public.profesores (cedulaprof) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_cod_asignatura FOREIGN KEY (codasignatura)
        REFERENCES public.asignaturas (codasignatura) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.secciones
    OWNER to postgres;
--------------------------------------------------------------------------------------