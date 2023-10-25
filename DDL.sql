-- Crear la base de datos FacultadDB (si aún no se ha creado)
CREATE DATABASE IF NOT EXISTS FacultadDB2;
USE FacultadDB2;

-- Creación de la tabla Carrera
CREATE TABLE Carrera (
    Codigo INT PRIMARY KEY,
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

-- FUNCIONALIDADES
-- Inserción de datos en la tabla Carrera
INSERT INTO Carrera (Nombre, Codigo)
VALUES
    ('Ingeniería Mecánica2', 10),
    ('Ingeniería Eléctrica', 2),
    ('Ingeniería Electrónica', 3),
    ('Ingeniería en Ciencias y Sistemas', 4);

INSERT INTO Carrera (Nombre, Codigo)
VALUES
    ('AREA COMUN', 0);

-- Inserción de datos en la tabla Estudiante
INSERT INTO Estudiante (Carnet, Nombres, Apellidos, FechaNacimiento, Correo, Telefono, Direccion, DPI, Carrera)
VALUES
    (201807328, 'Rony Ormandy', 'Ortiz Alvarez', '2000-09-04', 'ormandyrony@gmail.com', 59265554, 'Santa Rosa 1', '3101716790614', 4),
    (201113851, 'Christtopher José', 'Chitay Coutiño', '2000-09-05', '201113851@gmail.com', 59265555, 'Santa Rosa 2', '3101716790615', 4),
    (201807100, 'Daniel Alejandro', 'Barillas Soberanis', '2000-09-06', '201807100@gmail.com', 59265556, 'Santa Rosa 3', '3101716790616', 4),
    (201313861, 'Walther Andree', 'Corado Paiz', '2000-09-07', '201313861@gmail.com', 59265557, 'Santa Rosa 4', '3101716790617', 4),
    (201900576, 'Brayan Alexander', 'Mejia Barrientos', '2000-09-08', '201900576@gmail.com', 59265558, 'Santa Rosa 5', '3101716790618', 4),
    (201900462, 'Xhunik Nikol', 'Miguel Mutzutz', '2000-09-09', '201900462@gmail.com', 59265559, 'Santa Rosa 6', '3101716790619', 4),
    (201900831, 'Jhonatan Josué', 'Tzunún Yax', '2000-09-10', '201900831@gmail.com', 59265560, 'Santa Rosa 7', '3101716790620', 4),
    (202000560, 'Marjorie Gissell', 'Reyes Franco', '2000-09-11', '202000560@gmail.com', 59265561, 'Santa Rosa 8', '3101716790621', 4),
    (201801290, 'Jefferson Gamaliel', 'Molina Barrios', '2000-09-12', '201801290@gmail.com', 59265562, 'Santa Rosa 9', '3101716790622', 4),
    (202000166, 'Gerson Rubén', 'Quiroa del Cid', '2000-09-13', '202000166@gmail.com', 59265563, 'Santa Rosa 10', '3101716790623', 4);


-- Inserción de datos en la tabla Docente
INSERT INTO Docente (Nombres, Apellidos, FechaNacimiento, Correo, Telefono, Direccion, DPI, RegistroSIIF)
VALUES
    ('CARLOS LEONEL', 'MUNOZ LEMUS', '1990-08-05', '2101716790623@gmail.com', 45403851, 'Guatemala 1', '2101716790623', '020080425'),
    ('PAMELA CRISTINA', 'SIKAHALL URIZAR', '1990-09-05', '2101716790624@gmail.com', 45403852, 'Guatemala 2', '2101716790624', '020080426'),
    ('ERICKA NATHALIE', 'LOPEZ TORRES', '1990-10-05', '2101716790625@gmail.com', 45403853, 'Guatemala 3', '2101716790625', '020080427'),
    ('SORAYA DEL ROSARIO', 'MARTINEZ SUM', '1990-11-05', '2101716790626@gmail.com', 45403854, 'Guatemala 4', '2101716790626', '020080428'),
    ('MONICA MARLENI', 'QUINONEZ ANDRADE', '1990-12-05', '2101716790627@gmail.com', 45403855, 'Guatemala 5', '2101716790627', '020080429');

-- Inserción de datos en la tabla Curso (Área Común)
INSERT INTO Curso (Codigo, Nombre, CreditosNecesarios, CreditosOtorga, Carrera, EsObligatorio)
VALUES
    (0006, 'IDIOMA TECNICO 1', 0, 2, 0, 1),
    (0008, 'IDIOMA TECNICO 2', 0, 2, 0, 1),
    (0009, 'IDIOMA TECNICO 3', 0, 2, 0, 1),
    (0011, 'IDIOMA TECNICO 4', 0, 2, 0, 1),
    (0017, 'AREA SOCIAL HUMANISTICA 1', 0, 4, 0, 1);

-- Inserción de datos en la tabla Curso (Ingeniería en Sistemas)
INSERT INTO Curso (Codigo, Nombre, CreditosNecesarios, CreditosOtorga, Carrera, EsObligatorio)
VALUES
    (0770, 'INTRODUCCION A LA PROGRAMACION Y COMPUTACION 1', 33, 4, 4, 1),
    (0771, 'INTRODUCCION A LA PROGRAMACION Y COMPUTACION 2', 33, 5, 4, 1),
    (0772, 'ESTRUCTURAS DE DATOS', 33, 5, 4, 1),
    (0773, 'MANEJO E IMPLEMENTACION DE ARCHIVOS', 33, 4, 4, 1),
    (0777, 'ORGANIZACION DE LENGUAJES Y COMPILADORES 1', 33, 5, 4, 1);


-- FUNCIONES
DELIMITER $$
CREATE FUNCTION registrarEstudiante(
    in_Carnet BIGINT,
    in_Nombres VARCHAR(255),
    in_Apellidos VARCHAR(255),
    in_FechaNacimiento DATE,
    in_Correo VARCHAR(255),
    in_Telefono NUMERIC,
    in_Direccion VARCHAR(255),
    in_NumeroDPI BIGINT,
    in_Carrera NUMERIC
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE estudiante_id INT;

    INSERT INTO Estudiante(Carnet, Nombres, Apellidos, FechaNacimiento, Correo, Telefono, Direccion, DPI, Carrera)
    VALUES (in_Carnet, in_Nombres, in_Apellidos, in_FechaNacimiento, in_Correo, in_Telefono, in_Direccion, in_NumeroDPI, in_Carrera);

    SET estudiante_id = LAST_INSERT_ID();

    RETURN estudiante_id;
END$$
DELIMITER ;


-- Ejemplo de registro de estudiante
SET @nuevoEstudianteID = registrarEstudiante(
    201900002,   -- Carnet
    'Juan2',       -- Nombres
    'Perez2',      -- Apellidos
    '2002-01-15', -- Fecha de Nacimiento (en formato 'YYYY-MM-DD')
    'juanperez2@email.com', -- Correo
    123456782,     -- Teléfono
    'Dirección de Juan Perez2', -- Dirección
    1234567890122, -- Número de DPI
    1            -- ID de la Carrera (por ejemplo, 1 para Ingeniería Mecánica)
);

-- Verifica si se registró el estudiante y muestra su ID
SELECT @nuevoEstudianteID;

-- PROCEDIMIENTOS
DROP PROCEDURE IF EXISTS crearCarrera;

DELIMITER $$
CREATE PROCEDURE crearCarrera(
    in_Nombre VARCHAR(255),
    in_Codigo INT
)
BEGIN
    INSERT INTO Carrera(Nombre, Codigo)
    VALUES (in_Nombre, in_Codigo);
END$$
DELIMITER ;

-- Ejemplo de llamada al procedimiento almacenado crearCarrera
CALL crearCarrera('Ingeniería en Informática', 5);

DELIMITER $$
CREATE PROCEDURE registrarDocente(
    in_Nombres VARCHAR(255),
    in_Apellidos VARCHAR(255),
    in_FechaNacimiento DATE,
    in_Correo VARCHAR(255),
    in_Telefono NUMERIC,
    in_Direccion VARCHAR(255),
    in_NumeroDPI BIGINT,
    in_RegistroSIIF NUMERIC
)
BEGIN
    INSERT INTO Docente(Nombres, Apellidos, FechaNacimiento, Correo, Telefono, Direccion, DPI, RegistroSIIF)
    VALUES (in_Nombres, in_Apellidos, in_FechaNacimiento, in_Correo, in_Telefono, in_Direccion, in_NumeroDPI, in_RegistroSIIF);
END$$
DELIMITER ;

-- Ejemplo de registro de un docente
CALL registrarDocente(
    'Ana María', -- Nombres del docente
    'González Pérez', -- Apellidos del docente
    '1980-05-15', -- Fecha de nacimiento
    'ana@gmail.com', -- Correo
    55512345, -- Teléfono
    'Dirección del docente', -- Dirección
    123456789, -- Número de DPI
    12345 -- Registro SIIF
);

DELIMITER $$
CREATE PROCEDURE crearCurso(
    in_Codigo NUMERIC,
    in_Nombre VARCHAR(255),
    in_CreditosNecesarios NUMERIC,
    in_CreditosOtorga NUMERIC,
    in_CarreraPertenece NUMERIC,
    in_EsObligatorio BOOLEAN
)
BEGIN
    INSERT INTO Curso(Codigo, Nombre, CreditosNecesarios, CreditosOtorga, Carrera, EsObligatorio)
    VALUES (in_Codigo, in_Nombre, in_CreditosNecesarios, in_CreditosOtorga, in_CarreraPertenece, in_EsObligatorio);
END$$
DELIMITER ;

-- Ejemplo de creación de un curso
CALL crearCurso(
    1234, -- Código del curso
    'Introducción a la Programación', -- Nombre del curso
    4, -- Créditos necesarios
    3, -- Créditos que otorga
    4, -- Carrera a la que pertenece (ajusta el valor según la carrera)
    1 -- Es obligatorio (0 = no, 1 = sí)
);

DELIMITER $$
CREATE PROCEDURE habilitarCurso(
    in_CodigoCurso NUMERIC,
    in_Ciclo VARCHAR(255),
    in_Docente NUMERIC,
    in_CupoMaximo NUMERIC,
    in_Seccion CHAR
)
BEGIN
    INSERT INTO CursoHabilitado(CodigoCurso, Ciclo, Docente, CupoMaximo, Seccion, AnioActual, CantidadEstudiantesAsignados)
    VALUES (in_CodigoCurso, in_Ciclo, in_Docente, in_CupoMaximo, in_Seccion, YEAR(NOW()), 0);
END$$
DELIMITER ;

-- Ejemplo de habilitación de un curso
CALL habilitarCurso(
    1234, -- Código del curso
    '1S', -- Ciclo (ajusta según el ciclo)
    12345, -- Docente (ajusta según el docente)
    30, -- Cupo máximo
    'A' -- Sección (ajusta según la sección)
);

DELIMITER $$
CREATE PROCEDURE agregarHorario(
    in_IdCursoHabilitado NUMERIC,
    in_Dia NUMERIC,
    in_Horario VARCHAR(255)
)
BEGIN
    INSERT INTO HorarioCurso(IdCursoHabilitado, Dia, Horario)
    VALUES (in_IdCursoHabilitado, in_Dia, in_Horario);
END$$
DELIMITER ;

-- Ejemplo de agregar un horario para un curso habilitado
CALL agregarHorario(
    1, -- ID del curso habilitado (ajusta según el curso habilitado)
    1, -- Día (1 representa el primer día de la semana)
    '9:00-10:40' -- Horario
);

DELIMITER $$
CREATE PROCEDURE asignarCurso(
    IN pCodigoCurso INT,
    IN pCiclo VARCHAR(3),
    IN pSeccion CHAR(1),
    IN pCarnetEstudiante BIGINT
)
BEGIN
    DECLARE vCupoMaximo INT;
    DECLARE vCantEstudiantes INT;

    -- Obtener el cupo máximo y la cantidad de estudiantes asignados al curso y sección
    SELECT CupoMaximo, CantidadEstudiantesAsignados
    INTO vCupoMaximo, vCantEstudiantes
    FROM CursoHabilitado
    WHERE CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;

    -- Validar si el estudiante ya está asignado a esa sección
    SELECT COUNT(*) INTO vCantEstudiantes
    FROM AsignacionEstudiante
    WHERE CarnetEstudiante = pCarnetEstudiante
        AND CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;

    -- Validar si el estudiante cumple con los requisitos
    SELECT CreditosNecesarios, Carrera
    INTO @CreditosNecesarios, @CarreraCurso
    FROM Curso
    WHERE Codigo = pCodigoCurso;

    SELECT Creditos, Carrera
    INTO @CreditosPosee, @CarreraEstudiante
    FROM Estudiante
    WHERE Carnet = pCarnetEstudiante;

    IF vCantEstudiantes >= vCupoMaximo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cupo máximo para esta sección ya ha sido alcanzado';
    END IF;

    IF @CarreraCurso <> 0 AND @CarreraCurso <> @CarreraEstudiante THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante no pertenece a la carrera correspondiente a este curso';
    END IF;

    -- Realizar la asignación del estudiante al curso
    INSERT INTO AsignacionEstudiante (CarnetEstudiante, CodigoCurso, Ciclo, Seccion)
    VALUES (pCarnetEstudiante, pCodigoCurso, pCiclo, pSeccion);

    -- Incrementar la cantidad de estudiantes asignados al curso y sección
    UPDATE CursoHabilitado
    SET CantidadEstudiantesAsignados = CantidadEstudiantesAsignados + 1
    WHERE CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;
END $$
DELIMITER ;

DROP PROCEDURE  IF EXISTS  asignarCurso;
-- Ejemplo de asignación de curso
CALL asignarCurso(
    6, -- Código de curso (ajusta según el curso)
    '1S', -- Ciclo (ajusta según el ciclo)
    'A', -- Sección (ajusta según la sección)
    201807328 -- Carnet del estudiante (ajusta según el estudiante)
);

-- Ejemplo de habilitación de un curso
CALL habilitarCurso(
    6, -- Código del curso
    '1S', -- Ciclo (ajusta según el ciclo)
    12345, -- Docente (ajusta según el docente)
    30, -- Cupo máximo
    'A' -- Sección (ajusta según la sección)
);

-- Ejemplo de agregar un horario para un curso habilitado
CALL agregarHorario(
    2, -- ID del curso habilitado (ajusta según el curso habilitado)
    1, -- Día (1 representa el primer día de la semana)
    '9:00-10:40' -- Horario
);

DELIMITER $$
CREATE PROCEDURE desasignarCurso(
    IN pCodigoCurso INT,
    IN pCiclo VARCHAR(3),
    IN pSeccion CHAR(1),
    IN pCarnetEstudiante BIGINT
)
BEGIN
    DECLARE vCantEstudiantes INT;
    DECLARE vCarreraEstudiante INT;
    DECLARE vCarreraCurso INT;

    -- Verificar si el estudiante está asignado al curso y sección especificados
    SELECT COUNT(*) INTO vCantEstudiantes
    FROM AsignacionEstudiante
    WHERE CarnetEstudiante = pCarnetEstudiante
        AND CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;

    IF vCantEstudiantes = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante no está asignado a este curso y sección';
    END IF;

    -- Obtener la carrera del estudiante
    SELECT Carrera INTO vCarreraEstudiante
    FROM Estudiante
    WHERE Carnet = pCarnetEstudiante;

    -- Obtener la carrera del curso
    SELECT Carrera INTO vCarreraCurso
    FROM Curso
    WHERE Codigo = pCodigoCurso;

    -- Realizar la desasignación del estudiante al curso
    INSERT INTO DesasignacionEstudiante (CarnetEstudiante, CodigoCurso, Ciclo, Seccion, UsuarioQueRealizoAccion)
    VALUES (pCarnetEstudiante, pCodigoCurso, pCiclo, pSeccion, 'RONY ORTIZ');

    -- Realizar la desasignación del estudiante del curso y sección
    DELETE FROM AsignacionEstudiante
    WHERE CarnetEstudiante = pCarnetEstudiante
        AND CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;

    -- Decrementar la cantidad de estudiantes asignados al curso y sección
    UPDATE CursoHabilitado
    SET CantidadEstudiantesAsignados = CursoHabilitado.CantidadEstudiantesAsignados - 1
    WHERE CodigoCurso = pCodigoCurso
        AND Ciclo = pCiclo
        AND Seccion = pSeccion;
END $$
DELIMITER ;

DROP PROCEDURE desasignarCurso;
-- hay que insertar l estudiante a la tabla desasignacion
CALL desasignarCurso(6, '1S', 'A', 201807328);

DELIMITER //

CREATE PROCEDURE ingresarNota(
  IN p_CodigoCurso INT,
  IN p_Ciclo VARCHAR(3),
  IN p_Seccion CHAR(1),
  IN p_Carnet BIGINT,
  IN p_Nota NUMERIC(5, 2)
)
BEGIN
  DECLARE v_CreditosCurso INT;
  DECLARE v_CreditosEstudiante INT;
  DECLARE v_Aprobado BOOLEAN;

  -- Verificar si el estudiante está asignado al curso y sección especificados
  SELECT CreditosNecesarios INTO v_CreditosCurso
  FROM Curso
  WHERE Codigo = p_CodigoCurso;

  SELECT Creditos INTO v_CreditosEstudiante
  FROM Estudiante
  WHERE Carnet = p_Carnet;

  IF v_CreditosCurso IS NULL OR v_CreditosEstudiante IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede ingresar la nota. El curso o el estudiante no existen.';
  ELSE
    -- Verificar si el estudiante está asignado al curso y sección
    IF (SELECT COUNT(*) FROM AsignacionEstudiante
        WHERE CodigoCurso = p_CodigoCurso
        AND Ciclo = p_Ciclo
        AND Seccion = p_Seccion
        AND CarnetEstudiante = p_Carnet) = 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No se puede ingresar la nota. El estudiante no está asignado a este curso o sección.';
    ELSE
      -- Verificar si la nota es positiva
      IF p_Nota < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede ingresar una nota negativa.';
      ELSE
        -- Insertar la nota en la tabla Notas
        INSERT INTO Notas (CodigoCurso, Ciclo, Seccion, CarnetEstudiante, Nota)
        VALUES (p_CodigoCurso, p_Ciclo, p_Seccion, p_Carnet, ROUND(p_Nota));

        -- Verificar si el estudiante aprobó el curso
        IF p_Nota >= 61 THEN
          SET v_Aprobado = 1;
        ELSE
          SET v_Aprobado = 0;
        END IF;

        -- Actualizar la cantidad de créditos del estudiante si aprobó el curso
        IF v_Aprobado = 1 THEN
          UPDATE Estudiante
          SET Creditos = v_CreditosEstudiante + v_CreditosCurso
          WHERE Carnet = p_Carnet;
        END IF;
      END IF;
    END IF;
  END IF;
END //
DELIMITER ;

CALL ingresarNota(6, '1S', 'A', 201807328, 70);

DELIMITER //

CREATE PROCEDURE generarActa(
  IN p_CodigoCurso INT,
  IN p_Ciclo VARCHAR(3),
  IN p_Seccion CHAR(1)
)
BEGIN
  DECLARE v_ActaGenerada INT;

  -- Verificar si ya se han ingresado notas para todos los estudiantes asignados
  SELECT COUNT(*) INTO v_ActaGenerada
  FROM Notas
  WHERE CodigoCurso = p_CodigoCurso AND Ciclo = p_Ciclo AND Seccion = p_Seccion;

  IF v_ActaGenerada = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede generar el acta. No se han ingresado notas para todos los estudiantes asignados.';
  ELSE
    -- Insertar un registro en la tabla Actas
    INSERT INTO Acta (CodigoCurso, Ciclo, Seccion, FechaHoraGeneracion)
    VALUES (p_CodigoCurso, p_Ciclo, p_Seccion, NOW());
  END IF;
END //
DELIMITER ;

CALL generarActa(6, '1S', 'A');

DELIMITER $$
CREATE TRIGGER HistorialTransacciones
AFTER INSERT ON Estudiante
FOR EACH ROW
BEGIN
    INSERT INTO HistorialTransacciones(Fecha, Descripcion, Tipo)
    VALUES (NOW(), 'Se ha realizado una accion en la tabla Estudiante', 'INSERT');
END$$
DELIMITER ;

-- PROCESAMIENTO DE DATOS
-- Consultar pensum
DELIMITER $$
CREATE PROCEDURE ConsultarPensum(IN codigoCarrera INT)
BEGIN
    SELECT C.Codigo AS CodigoCurso, C.Nombre AS NombreCurso, C.CreditosNecesarios AS CreditosNecesarios,
           C.CreditosOtorga AS CreditosQueOtorga, C.Carrera AS CarreraPertenece, C.EsObligatorio AS EsObligatorio
    FROM Curso AS C
    WHERE C.Carrera = codigoCarrera OR C.Carrera = 0;
END$$
DELIMITER ;

CALL ConsultarPensum(4);

-- Consultar estudiante
DELIMITER $$
CREATE PROCEDURE consultarEstudiante(IN carnetEstudiante BIGINT)
BEGIN
    SELECT Carnet, CONCAT(Nombres, ' ', Apellidos) AS NombreCompleto, FechaNacimiento, Correo, Telefono, Direccion, DPI, Carrera, Creditos
    FROM Estudiante
    WHERE Carnet = carnetEstudiante;
END$$
DELIMITER ;

CALL consultarEstudiante(201807329);

-- Consultar docente
DELIMITER $$
CREATE PROCEDURE consultarDocente(IN registroSIIF_ BIGINT)
BEGIN
    SELECT RegistroSIIF, CONCAT(Nombres, ' ', Apellidos) AS NombreCompleto, FechaNacimiento, Correo, Telefono, Direccion, DPI
    FROM Docente
    WHERE RegistroSIIF = registroSIIF_;
END$$
DELIMITER ;


CALL consultarDocente(20080425);

-- Consultar estudiantes asignados
DELIMITER $$
CREATE PROCEDURE consultarAsignados(IN codigoCurso_ INT, IN ciclo_ VARCHAR(2), IN anio INT, IN seccion_ CHAR(1))
BEGIN
    SELECT E.Carnet, CONCAT(E.Nombres, ' ', E.Apellidos) AS NombreCompleto, E.Creditos
    FROM Estudiante AS E
    INNER JOIN AsignacionEstudiante AS A ON E.Carnet = A.CarnetEstudiante
    INNER JOIN CursoHabilitado AS CH ON A.CodigoCurso = CH.CodigoCurso
    WHERE CH.CodigoCurso = codigoCurso_ AND CH.Ciclo = ciclo_ AND CH.AnioActual = anio AND CH.Seccion = seccion_;
END$$
DELIMITER ;

DROP PROCEDURE consultarAsignados;

CALL consultarAsignados(6, '1S', 2023, 'A');

-- Consultar aprobaciones
DELIMITER $$
CREATE PROCEDURE consultarAprobacion(IN codigoCurso_ INT, IN ciclo_ VARCHAR(2), IN anio INT, IN seccion_ CHAR(1))
BEGIN
    SELECT E.Carnet, CONCAT(E.Nombres, ' ', E.Apellidos) AS NombreCompleto,
    CASE
        WHEN N.Nota >= 61 THEN 'APROBADO'
        ELSE 'DESAPROBADO'
    END AS Estado
    FROM Estudiante AS E
    INNER JOIN Notas AS N ON E.Carnet = N.CarnetEstudiante
    INNER JOIN CursoHabilitado AS CH ON N.CodigoCurso = CH.CodigoCurso
    WHERE CH.CodigoCurso = codigoCurso_ AND CH.Ciclo = ciclo_ AND CH.AnioActual = anio AND CH.Seccion = seccion_;
END$$
DELIMITER ;

CALL consultarAprobacion(6, '1S', 2023, 'A');

-- Consultar actas
DELIMITER $$
CREATE PROCEDURE ConsultarActas(IN codigoCurso_ INT)
BEGIN
    SELECT CH.CodigoCurso, CH.Seccion, CH.Ciclo, CH.AnioActual, COUNT(N.CarnetEstudiante) AS CantidadEstudiantes, A.FechaHoraGeneracion
    FROM CursoHabilitado AS CH
    LEFT JOIN Acta AS A ON CH.CodigoCurso = A.CodigoCurso
    LEFT JOIN Notas AS N ON CH.CodigoCurso = N.CodigoCurso
    WHERE CH.CodigoCurso = codigoCurso_
    GROUP BY CH.CodigoCurso, CH.Seccion, CH.Ciclo, CH.AnioActual, A.FechaHoraGeneracion
    ORDER BY A.FechaHoraGeneracion;
END$$
DELIMITER ;

DROP PROCEDURE consultarActas;
CALL consultarActas(6);

-- Consultar tasa de desasignación
DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(IN codigoCurso_ INT, IN ciclo_ VARCHAR(2), IN anio_ INT, IN seccion_ CHAR(1))
BEGIN
    SELECT CH.CodigoCurso, CH.Seccion,
    CASE
        WHEN CH.Ciclo = '1S' THEN 'PRIMER SEMESTRE'
        WHEN CH.Ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
        WHEN CH.Ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
        WHEN CH.Ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
    END AS Ciclo, CH.AnioActual,
    COUNT(D.CarnetEstudiante) AS CantidadEstudiantesLlevaronCurso,
    (COUNT(D.CarnetEstudiante) - COUNT(A.CarnetEstudiante)) AS CantidadEstudiantesDesasignados,
    (COUNT(A.CarnetEstudiante) / COUNT(D.CarnetEstudiante)) * 100 AS TasaDesasignacion
    FROM CursoHabilitado AS CH
    LEFT JOIN AsignacionEstudiante AS A ON CH.CodigoCurso = A.CodigoCurso
    LEFT JOIN DesasignacionEstudiante AS D ON CH.CodigoCurso = D.CodigoCurso
    WHERE CH.CodigoCurso = codigoCurso_ AND CH.Ciclo = ciclo_ AND CH.AnioActual = anio_ AND CH.Seccion = seccion_;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ConsultarTasaDesasignacion(IN codigoCurso_ INT, IN seccion_ CHAR(1), IN anio_ INT, IN ciclo_ VARCHAR(2))
BEGIN
    SELECT CH.CodigoCurso, CH.Seccion, CH.Ciclo, CH.AnioActual,
           COUNT(D.CarnetEstudiante) AS CantidadEstudiantesLlevaronCurso,
           COUNT(A.CarnetEstudiante) AS CantidadEstudiantesAsignados,
           COUNT(D.CarnetEstudiante) AS CantidadEstudiantesDesasignados,
           (COUNT(D.CarnetEstudiante) / COUNT(A.CarnetEstudiante)) * 100 AS TasaDesasignacion
    FROM CursoHabilitado AS CH
    LEFT JOIN AsignacionEstudiante AS A ON CH.CodigoCurso = A.CodigoCurso
    LEFT JOIN DesasignacionEstudiante AS D ON CH.CodigoCurso = D.CodigoCurso
    WHERE CH.CodigoCurso = codigoCurso_ AND CH.Seccion = seccion_ AND CH.AnioActual = anio_ AND CH.Ciclo = ciclo_
    GROUP BY CH.CodigoCurso, CH.Seccion, CH.Ciclo, CH.AnioActual;
END$$
DELIMITER ;


DROP PROCEDURE ConsultarTasaDesasignacion;
CALL ConsultarTasaDesasignacion(6, 'A', 2023, '1S');
