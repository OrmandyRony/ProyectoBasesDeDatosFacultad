
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
