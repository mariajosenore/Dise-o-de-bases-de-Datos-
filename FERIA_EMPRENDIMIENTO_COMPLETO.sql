
-- ===============================
-- SECCIÓN 1: CREACIÓN DE TABLAS
-- ===============================

-- Tabla de Clasificación Temática
CREATE TABLE Clasificacion_Tematica (
  ID_Clasificacion INT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL
);

-- Tabla de Stand
CREATE TABLE Stand (
  ID_Stand INT PRIMARY KEY,
  Ubicacion VARCHAR(100) NOT NULL
);

-- Tabla de Proyecto
CREATE TABLE Proyecto (
  ID_Proyecto INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Tipo_Negocio VARCHAR(50),
  Eslogan TEXT,
  Fecha_Inscripcion DATE,
  Estado_Aprobacion VARCHAR(20),
  FK_Clasificacion_Tematica INT,
  FK_Stand INT UNIQUE,
  FOREIGN KEY (FK_Clasificacion_Tematica) REFERENCES Clasificacion_Tematica(ID_Clasificacion),
  FOREIGN KEY (FK_Stand) REFERENCES Stand(ID_Stand)
);

-- Tabla de Agenda
CREATE TABLE Agenda (
  ID_Agenda INT PRIMARY KEY,
  FK_Stand INT UNIQUE,
  Fecha DATE NOT NULL,
  Hora_Inicio TIME,
  Hora_Fin TIME,
  Descripcion_Actividad TEXT,
  FOREIGN KEY (FK_Stand) REFERENCES Stand(ID_Stand)
);

-- Tabla de Equipo
CREATE TABLE Equipo (
  ID_Equipo INT PRIMARY KEY,
  FK_Proyecto INT UNIQUE,
  FOREIGN KEY (FK_Proyecto) REFERENCES Proyecto(ID_Proyecto)
);

-- Tabla de Estudiante
CREATE TABLE Estudiante (
  ID_Estudiante INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Correo VARCHAR(100),
  Es_Lider BOOLEAN DEFAULT FALSE
);

-- Tabla intermedia para N:M entre Estudiante y Equipo
CREATE TABLE Integrante_Equipo (
  FK_Estudiante INT,
  FK_Equipo INT,
  PRIMARY KEY (FK_Estudiante, FK_Equipo),
  FOREIGN KEY (FK_Estudiante) REFERENCES Estudiante(ID_Estudiante),
  FOREIGN KEY (FK_Equipo) REFERENCES Equipo(ID_Equipo)
);

-- Tabla de Producto
CREATE TABLE Producto (
  ID_Producto INT PRIMARY KEY,
  FK_Proyecto INT,
  Nombre VARCHAR(100) NOT NULL,
  Precio DECIMAL(10,2),
  Disponible BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (FK_Proyecto) REFERENCES Proyecto(ID_Proyecto)
);

-- Tabla de Transacción
CREATE TABLE Transaccion (
  ID_Transaccion INT PRIMARY KEY,
  FK_Producto INT,
  Cantidad INT,
  Valor DECIMAL(10,2),
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (FK_Producto) REFERENCES Producto(ID_Producto)
);

-- Tabla de Visitante
CREATE TABLE Visitante (
  ID_Visitante INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Correo VARCHAR(100),
  Tipo VARCHAR(20) CHECK (Tipo IN ('Estudiante', 'Externo'))
);

-- Tabla de Visita (N:M entre Visitante y Stand)
CREATE TABLE Visita (
  FK_Visitante INT,
  FK_Stand INT,
  Fecha_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (FK_Visitante, FK_Stand, Fecha_Hora),
  FOREIGN KEY (FK_Visitante) REFERENCES Visitante(ID_Visitante),
  FOREIGN KEY (FK_Stand) REFERENCES Stand(ID_Stand)
);

-- Tabla de Encuesta de Satisfacción
CREATE TABLE Encuesta_Satisfaccion (
  ID_Encuesta INT PRIMARY KEY,
  FK_Visitante INT,
  Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
  Comentario TEXT,
  Fecha DATE,
  FOREIGN KEY (FK_Visitante) REFERENCES Visitante(ID_Visitante)
);

-- Tabla de Jurado
CREATE TABLE Jurado (
  ID_Jurado INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Especialidad VARCHAR(100),
  Contacto VARCHAR(100)
);

-- Tabla de Evaluación por Jurado
CREATE TABLE Evaluacion_Jurado (
  ID_Evaluacion INT PRIMARY KEY,
  FK_Proyecto INT,
  FK_Jurado INT,
  Puntaje INT CHECK (Puntaje BETWEEN 1 AND 5),
  Comentarios TEXT,
  FOREIGN KEY (FK_Proyecto) REFERENCES Proyecto(ID_Proyecto),
  FOREIGN KEY (FK_Jurado) REFERENCES Jurado(ID_Jurado)
);

-- Tabla de Evaluación de Stand
CREATE TABLE Evaluacion_Stand (
  ID_Evaluacion_Stand INT PRIMARY KEY,
  FK_Stand INT,
  Puntaje INT CHECK (Puntaje BETWEEN 1 AND 5),
  Comentario TEXT,
  FOREIGN KEY (FK_Stand) REFERENCES Stand(ID_Stand)
);

-- Tabla de Logística del Evento
CREATE TABLE Logistica_Evento (
  ID_Evento INT PRIMARY KEY,
  Fecha_Inicio DATE NOT NULL,
  Fecha_Fin DATE NOT NULL,
  Lugar VARCHAR(100)
);

-- Tabla de Patrocinador
CREATE TABLE Patrocinador (
  ID_Patrocinador INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  FK_Evento INT,
  FOREIGN KEY (FK_Evento) REFERENCES Logistica_Evento(ID_Evento)
);


-- ===============================
-- SECCIÓN 2: INSERCIÓN DE DATOS
-- ===============================

-- Clasificación temática
INSERT INTO Clasificacion_Tematica (ID_Clasificacion, Nombre) VALUES (1, 'Tecnología');
INSERT INTO Clasificacion_Tematica (ID_Clasificacion, Nombre) VALUES (2, 'Moda');

-- Stands
INSERT INTO Stand (ID_Stand, Ubicacion) VALUES (1, 'Pasillo A');
INSERT INTO Stand (ID_Stand, Ubicacion) VALUES (2, 'Pasillo B');

-- Proyecto
INSERT INTO Proyecto (ID_Proyecto, Nombre, Tipo_Negocio, Eslogan, Fecha_Inscripcion, Estado_Aprobacion, FK_Clasificacion_Tematica, FK_Stand)
VALUES (1, 'EcoBot', 'Tecnología Verde', 'Reinventa el reciclaje', SYSDATE, 'Aprobado', 1, 1);

-- Agenda
INSERT INTO Agenda (ID_Agenda, FK_Stand, Fecha, Hora_Inicio, Hora_Fin, Descripcion_Actividad)
VALUES (1, 1, SYSDATE, TO_DATE('10:00', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI'), 'Demostración de EcoBot');

-- Equipo
INSERT INTO Equipo (ID_Equipo, FK_Proyecto) VALUES (1, 1);

-- Estudiantes
INSERT INTO Estudiante (ID_Estudiante, Nombre, Correo, Es_Lider) VALUES (1, 'Ana Torres', 'ana@mail.com', 1);
INSERT INTO Estudiante (ID_Estudiante, Nombre, Correo, Es_Lider) VALUES (2, 'Luis Pérez', 'luis@mail.com', 0);

-- Integrantes
INSERT INTO Integrante_Equipo (FK_Estudiante, FK_Equipo) VALUES (1, 1);
INSERT INTO Integrante_Equipo (FK_Estudiante, FK_Equipo) VALUES (2, 1);

-- Productos
INSERT INTO Producto (ID_Producto, FK_Proyecto, Nombre, Precio, Disponible) VALUES (1, 1, 'EcoBot Mini', 150.00, 1);
INSERT INTO Producto (ID_Producto, FK_Proyecto, Nombre, Precio, Disponible) VALUES (2, 1, 'EcoBot Pro', 300.00, 1);

-- Transacciones
INSERT INTO Transaccion (ID_Transaccion, FK_Producto, Cantidad, Valor, Fecha) VALUES (1, 1, 2, 300.00, SYSDATE);
INSERT INTO Transaccion (ID_Transaccion, FK_Producto, Cantidad, Valor, Fecha) VALUES (2, 2, 1, 300.00, SYSDATE);

-- Visitantes
INSERT INTO Visitante (ID_Visitante, Nombre, Correo, Tipo) VALUES (1, 'Carlos Gómez', 'carlos@mail.com', 'Estudiante');
INSERT INTO Visitante (ID_Visitante, Nombre, Correo, Tipo) VALUES (2, 'Lucía Ríos', 'lucia@mail.com', 'Externo');

-- Visitas
INSERT INTO Visita (FK_Visitante, FK_Stand, Fecha_Hora) VALUES (1, 1, SYSDATE);
INSERT INTO Visita (FK_Visitante, FK_Stand, Fecha_Hora) VALUES (2, 1, SYSDATE);

-- Encuestas
INSERT INTO Encuesta_Satisfaccion (ID_Encuesta, FK_Visitante, Calificacion, Comentario, Fecha)
VALUES (1, 1, 5, 'Muy innovador', SYSDATE);
INSERT INTO Encuesta_Satisfaccion (ID_Encuesta, FK_Visitante, Calificacion, Comentario, Fecha)
VALUES (2, 2, 4, 'Buen proyecto', SYSDATE);

-- Jurado
INSERT INTO Jurado (ID_Jurado, Nombre, Especialidad, Contacto) VALUES (1, 'Dra. Lina Ruiz', 'Ingeniería', 'lina@mail.com');

-- Evaluaciones de Jurado
INSERT INTO Evaluacion_Jurado (ID_Evaluacion, FK_Proyecto, FK_Jurado, Puntaje, Comentarios)
VALUES (1, 1, 1, 5, 'Excelente ejecución');

-- Evaluación del Stand
INSERT INTO Evaluacion_Stand (ID_Evaluacion_Stand, FK_Stand, Puntaje, Comentario)
VALUES (1, 1, 4, 'Bien organizado');

-- Logística del evento
INSERT INTO Logistica_Evento (ID_Evento, Fecha_Inicio, Fecha_Fin, Lugar)
VALUES (1, SYSDATE, SYSDATE + 2, 'Plaza Central');

-- Patrocinadores
INSERT INTO Patrocinador (ID_Patrocinador, Nombre, FK_Evento)
VALUES (1, 'Fundación Eco', 1);


-- ===============================
-- SECCIÓN 3: CONSULTAS SQL
-- ===============================

-- 1. Ranking de proyectos según promedio ponderado
SELECT p.Nombre, 
       ROUND(AVG(e.Puntaje) * COUNT(e.ID_Evaluacion), 2) AS Ponderado_Evaluacion
FROM Proyecto p
JOIN Evaluacion_Jurado e ON p.ID_Proyecto = e.FK_Proyecto
GROUP BY p.Nombre
ORDER BY Ponderado_Evaluacion DESC;

-- 2. Top 3 productos más vendidos
SELECT *
FROM (
    SELECT pr.Nombre AS Producto, SUM(t.Cantidad) AS Total_Unidades
    FROM Producto pr
    JOIN Transaccion t ON pr.ID_Producto = t.FK_Producto
    GROUP BY pr.Nombre
    ORDER BY Total_Unidades DESC
)
WHERE ROWNUM <= 3;

-- 3. Visitantes que generaron más ingresos indirectos
SELECT v.Nombre, SUM(t.Valor) AS Total_Compras
FROM Visitante v
JOIN Visita vi ON v.ID_Visitante = vi.FK_Visitante
JOIN Stand s ON vi.FK_Stand = s.ID_Stand
JOIN Proyecto p ON p.FK_Stand = s.ID_Stand
JOIN Producto pr ON pr.FK_Proyecto = p.ID_Proyecto
JOIN Transaccion t ON t.FK_Producto = pr.ID_Producto
GROUP BY v.Nombre
ORDER BY Total_Compras DESC;

-- 4. Horas pico de visitas
SELECT TO_CHAR(Fecha_Hora, 'HH24') AS Hora, COUNT(*) AS Total_Visitas
FROM Visita
GROUP BY TO_CHAR(Fecha_Hora, 'HH24')
ORDER BY Total_Visitas DESC FETCH FIRST 5 ROWS ONLY;

-- 5. Proyectos con evaluación superior a la media
SELECT p.Nombre, AVG(e.Puntaje) AS Promedio
FROM Proyecto p
JOIN Evaluacion_Jurado e ON p.ID_Proyecto = e.FK_Proyecto
GROUP BY p.Nombre
HAVING AVG(e.Puntaje) > (SELECT AVG(Puntaje) FROM Evaluacion_Jurado);

-- 6. Visitantes que evaluaron y también compraron
SELECT DISTINCT v.Nombre
FROM Visitante v
WHERE EXISTS (
    SELECT 1 FROM Encuesta_Satisfaccion e WHERE e.FK_Visitante = v.ID_Visitante
)
AND EXISTS (
    SELECT 1
    FROM Visita vi
    JOIN Stand s ON vi.FK_Stand = s.ID_Stand
    JOIN Proyecto p ON p.FK_Stand = s.ID_Stand
    JOIN Producto pr ON pr.FK_Proyecto = p.ID_Proyecto
    JOIN Transaccion t ON t.FK_Producto = pr.ID_Producto
    WHERE vi.FK_Visitante = v.ID_Visitante
);

-- 7. Gasto promedio por tipo de visitante
SELECT v.Tipo, ROUND(AVG(t.Valor), 2) AS Gasto_Promedio
FROM Visitante v
JOIN Visita vi ON v.ID_Visitante = vi.FK_Visitante
JOIN Stand s ON vi.FK_Stand = s.ID_Stand
JOIN Proyecto p ON s.ID_Stand = p.FK_Stand
JOIN Producto pr ON p.ID_Proyecto = pr.FK_Proyecto
JOIN Transaccion t ON pr.ID_Producto = t.FK_Producto
GROUP BY v.Tipo;

-- 8. Productos disponibles sin transacciones
SELECT p.Nombre AS Proyecto, pr.Nombre AS Producto
FROM Proyecto p
JOIN Producto pr ON p.ID_Proyecto = pr.FK_Proyecto
LEFT JOIN Transaccion t ON pr.ID_Producto = t.FK_Producto
WHERE pr.Disponible = 1 AND t.ID_Transaccion IS NULL;

-- 9. Proyectos con más visitantes únicos
SELECT p.Nombre, COUNT(DISTINCT vi.FK_Visitante) AS Visitantes_Unicos
FROM Proyecto p
JOIN Stand s ON p.FK_Stand = s.ID_Stand
JOIN Visita vi ON s.ID_Stand = vi.FK_Stand
GROUP BY p.Nombre
ORDER BY Visitantes_Unicos DESC;

-- 10. Promedio de puntaje y mejor proyecto evaluado por cada jurado
SELECT j.Nombre AS Jurado, 
       ROUND(AVG(e.Puntaje), 2) AS Promedio,
       (
         SELECT p2.Nombre
         FROM Evaluacion_Jurado ej2
         JOIN Proyecto p2 ON p2.ID_Proyecto = ej2.FK_Proyecto
         WHERE ej2.FK_Jurado = j.ID_Jurado
         AND ej2.Puntaje = (
             SELECT MAX(ej3.Puntaje)
             FROM Evaluacion_Jurado ej3
             WHERE ej3.FK_Jurado = j.ID_Jurado
         )
         FETCH FIRST 1 ROWS ONLY
       ) AS Proyecto_Top
FROM Jurado j
JOIN Evaluacion_Jurado e ON j.ID_Jurado = e.FK_Jurado
GROUP BY j.Nombre, j.ID_Jurado;

