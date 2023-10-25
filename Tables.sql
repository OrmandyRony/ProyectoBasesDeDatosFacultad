-- Crear la base de datos FacultadDB (si aún no se ha creado)
CREATE DATABASE IF NOT EXISTS FacultadDB2;
USE FacultadDB2;

-- Creación de la tabla Carrera
CREATE TABLE Carrera (
    Codigo INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(255) NOT NULL
);

-- Creación de la tabla Estudiante
CREATE TABLE Estudiante (
    Carnet BIGINT PRIMARY KEY,
    Nombres VARCHAR(255) NOT NULL,
    Apellidos VARCHAR(255) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Telefono INT,
    Direccion VARCHAR(255),
    DPI BIGINT NOT NULL,
    Carrera INT,
    Creditos INT DEFAULT 0,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Carrera) REFERENCES Carrera(Codigo)
);

-- Creación de la tabla Docente
CREATE TABLE Docente (
    RegistroSIIF BIGINT PRIMARY KEY,
    Nombres VARCHAR(255) NOT NULL,
    Apellidos VARCHAR(255) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Telefono INT,
    Direccion VARCHAR(255),
    DPI BIGINT NOT NULL
);

-- Creación de la tabla Curso
CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    CreditosNecesarios INT NOT NULL,
    CreditosOtorga INT NOT NULL,
    Carrera INT,
    EsObligatorio TINYINT(1) NOT NULL,
    FOREIGN KEY (Carrera) REFERENCES Carrera(Codigo)
);

-- Creación de un índice compuesto en la tabla CursoHabilitado
CREATE UNIQUE INDEX idx_CursoHabilitado
ON CursoHabilitado (CodigoCurso, Ciclo, Seccion);


-- Creación de la tabla CursoHabilitado
CREATE TABLE CursoHabilitado (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    CodigoCurso INT,
    Ciclo ENUM('1S', '2S', 'VJ', 'VD') NOT NULL,
    Docente BIGINT,
    CupoMaximo INT NOT NULL,
    Seccion CHAR(1) NOT NULL,
    AnioActual YEAR,
    CantidadEstudiantesAsignados INT DEFAULT 0,
    FOREIGN KEY (CodigoCurso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Docente) REFERENCES Docente(RegistroSIIF)
);


-- Creación de la tabla HorarioCurso
CREATE TABLE HorarioCurso (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    IDCursoHabilitado INT,
    Dia INT,
    Horario VARCHAR(255) NOT NULL,
    FOREIGN KEY (IDCursoHabilitado) REFERENCES CursoHabilitado(ID)
);

-- Creación de la tabla AsignacionEstudiante
CREATE TABLE AsignacionEstudiante (
    CodigoCurso INT,
    Ciclo ENUM('1S', '2S', 'VJ', 'VD') NOT NULL,
    Seccion CHAR(1) NOT NULL,
    CarnetEstudiante BIGINT,
    PRIMARY KEY (CodigoCurso, Ciclo, Seccion, CarnetEstudiante),
    FOREIGN KEY (CodigoCurso, Ciclo, Seccion) REFERENCES CursoHabilitado(CodigoCurso, Ciclo, Seccion),
    FOREIGN KEY (CarnetEstudiante) REFERENCES Estudiante(Carnet)
);

-- Creación de la tabla Notas
CREATE TABLE Notas (
    CodigoCurso INT,
    Ciclo ENUM('1S', '2S', 'VJ', 'VD') NOT NULL,
    Seccion CHAR(1) NOT NULL,
    CarnetEstudiante BIGINT,
    Nota DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (CodigoCurso, Ciclo, Seccion, CarnetEstudiante),
    FOREIGN KEY (CodigoCurso, Ciclo, Seccion) REFERENCES CursoHabilitado(CodigoCurso, Ciclo, Seccion),
    FOREIGN KEY (CarnetEstudiante) REFERENCES Estudiante(Carnet)
);

-- Creación de la tabla Acta
CREATE TABLE Acta (
    CodigoCurso INT,
    Ciclo ENUM('1S', '2S', 'VJ', 'VD') NOT NULL,
    Seccion CHAR(1) NOT NULL,
    FechaHoraGeneracion DATETIME,
    PRIMARY KEY (CodigoCurso, Ciclo, Seccion),
    FOREIGN KEY (CodigoCurso, Ciclo, Seccion) REFERENCES CursoHabilitado(CodigoCurso, Ciclo, Seccion)
);

-- Creación de la tabla HistorialTransacciones
CREATE TABLE HistorialTransacciones (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATETIME,
    Descripcion VARCHAR(255) NOT NULL,
    Tipo ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL
);

-- Creación de la tabla DesasignacionEstudiante
CREATE TABLE DesasignacionEstudiante (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    CodigoCurso INT,
    Ciclo ENUM('1S', '2S', 'VJ', 'VD') NOT NULL,
    Seccion CHAR(1) NOT NULL,
    CarnetEstudiante BIGINT,
    FechaHoraDesasignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    UsuarioQueRealizoAccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (CodigoCurso, Ciclo, Seccion) REFERENCES CursoHabilitado(CodigoCurso, Ciclo, Seccion),
    FOREIGN KEY (CarnetEstudiante) REFERENCES Estudiante(Carnet)
);