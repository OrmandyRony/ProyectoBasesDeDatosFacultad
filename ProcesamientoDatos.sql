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
