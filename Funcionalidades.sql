
-- FUNCIONALIDADES
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