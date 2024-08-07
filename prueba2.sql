-- Active: 1722878612918@@127.0.0.1@5432@prueba_sql_claudia3
-- 1)Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.
CREATE DATABASE prueba_SQL_Claudia3;

--BORRAR PARA VOLVER A MOSTRAR EJERCICIO
Drop Table pelicula_tags, tags, peliculas;
Drop Table Respuestas, Usuarios, Preguntas;
ALTER TABLE Respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey;
ALTER TABLE Usuarios
DROP CONSTRAINT edad_mayor_igual_a_18;

CREATE TABLE peliculas 
(id SERIAL primary key, --SERIAL automáticamente asigna un tipo de entero (integer)
nombre varchar(255), 
anno INTEGER);


CREATE TABLE tags 
( id SERIAL primary key, 
tag varchar(32));

INSERT INTO peliculas ( nombre, anno)
VALUES 
('El Padrino', 1972),
( 'El mago de Oz', 1939),
('Dr. Strangelove', 1964),
( 'El ciudadano Kane', 1941),
('Pobres criaturas', 2023);



INSERT INTO tags ( tag)
VALUES 
( 'Drama'),
('Grandes directores'),
( 'Comedia'),
( 'Feminismo'),
( 'Clásico');


CREATE TABLE pelicula_tags(
  id SERIAL PRIMARY KEY,  
  peliculas_id int,
  tags_id int,
  foreign key(peliculas_id) references peliculas(id),
  foreign key(tags_id) references tags(id)
);



--2) Creo tabla asociada peliculas_tags, 
--la primera película debe tener 3 tags asociados, 
--la segunda película debe tener 2 tags asociados.
INSERT INTO pelicula_tags (peliculas_id, tags_id) 
VALUES 
(1, 1),  -- El Padrino >  Drama
(1, 2),  -- El Padrino > Grandes directores
(1, 5),  -- El Padrino > Clásico
(2, 1),  -- El mago de Oz > Drama
(2, 5),  -- El mago de Oz > Clásico
(3, 2),  -- Dr. Strangelove > Grandes directores
(3, 3),  -- Dr. Strangelove > Comedia
(4, 1),  -- El ciudadano Kane > Drama
(4, 2),  -- El ciudadano Kane > Grandes directores
(4, 5),  -- El ciudadano Kane > Clásico
(5, 1),  -- Pobres criaturas > Drama
(5, 3),  -- Pobres criaturas > Comedia
(5, 4);  -- Pobres criaturas > Feminismo
SELECT * FROM pelicula_tags;


--Quiero ver los nombres y las tags para concentrarme más 
ALTER TABLE pelicula_tags
ADD COLUMN pelicula_nombre VARCHAR,
ADD COLUMN tag_nombre VARCHAR;
UPDATE pelicula_tags
SET  pelicula_nombre = (SELECT p.nombre FROM peliculas p WHERE p.id = pelicula_tags.peliculas_id),
    tag_nombre = (SELECT t.tag FROM tags t WHERE t.id = pelicula_tags.tags_id);


--3) Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.


SELECT * FROM pelicula_tags;

SELECT                                             -- Selecciona
    peliculas.id,                                   -- el id de la tabla Peliculas 
    peliculas.nombre,  
                                 -- y el nombre de la tabla Peliculas
    COUNT(pelicula_tags.tags_id) AS cantidad_tags   -- Cuenta la cantidad de veces que se repite tags_id  tabla peliculas_tags
FROM peliculas
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.peliculas_id 
GROUP BY peliculas.id          
ORDER BY peliculas.id ASC;   
                    

--Dado el siguiente modelo:
-- 4) Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.
CREATE TABLE Usuarios (
  id SERIAL PRIMARY KEY,
  nombre varchar(255),
  edad integer
);

CREATE TABLE Preguntas (
  id SERIAL PRIMARY KEY,
  pregunta varchar(255),
  respuesta_correcta varchar(255)
);

CREATE TABLE respuestas (
  id serial PRIMARY KEY,         -- El ID será un campo serial autoincremental
  respuesta varchar(255) NOT NULL, -- No se permitirá que "respuesta" sea nulo
  usuario_id integer,
  pregunta_id integer,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE,
  FOREIGN KEY (pregunta_id) REFERENCES preguntas (id) ON DELETE CASCADE
);



--5) 

--Agrega 5 preguntas


INSERT INTO preguntas (pregunta, respuesta_correcta)
VALUES
('¿Quién protagonizó El mago de Oz?', 'Judy Garland'),
('¿Cuántos premios Oscar tiene la saga del Padrino?', 'Tres'),
('¿Cuántos personajes actúa Peter Sellers en Doctor Strangelove?', 'Tres'),
('¿Qué año se estrenó el Ciudadano Kane?', '1941'),
('¿Quién está a cargo de la dirección de arte de Pobre Criaturas?', 'Shona Heath');


--Agrega 5 usuarios
INSERT INTO Usuarios ( nombre, edad)
VALUES
('Ana Gómez', 28),
( 'Luis Martínez', 34),
( 'María Fernández', 22),
('Carlos Pérez', 40),
('Laura Díaz', 30);

--a)La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
--b)La segunda pregunta debe estar contestada correctamente solo por un usuario.
--c)Las otras tres preguntas deben tener respuestas incorrectas.
INSERT INTO Respuestas (respuesta, usuario_id, pregunta_id)
VALUES
( 'Judy Garland', 3, 1), ---> usuario 3, pregunta 1, correcta
( 'Judy Garland', 4, 1), ---> usuario 4, pregunta 1, correcta
( 'Tres', 1, 2),         ---> usuario 1, pregunta 2, correcta
( 'Ocho', 2, 2),         ---> usuario 2, pregunta 2, incorrecta
( 'Cinco', 5, 3),        ---> usuario 5, pregunta 3, incorrecta
( 'Uno', 1, 3),          ---> usuario 1, pregunta 3, incorrecta
( '1955', 3, 4),         ---> usuario 3, pregunta 4, inorrecta
( 'Emma Stone', 4, 5);   ---> usuario 4, pregunta 5, incorrecta




--6 Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).



SELECT 
    u.nombre AS usuario, -- Selecciona el nombre del usuario
    COUNT(*) AS cantidad_respuestas_correctas -- Cuenta las respuestas correctas
FROM Respuestas r INNER JOIN Preguntas p -- Une Respuestas con Preguntas
ON r.pregunta_id = p.id -- para asegurar que la pregunta coincide
    AND r.respuesta = p.respuesta_correcta -- Asegura que la respuesta es correcta
INNER JOIN Usuarios u ON r.usuario_id = u.id -- Une Respuestas con Usuarios en r.usuario_id = u.id
GROUP BY u.nombre; -- Agrupa por nombre 


--7 Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.

SELECT Preguntas.pregunta, --selecciona campo preguntas de Preguntas
    COUNT(Respuestas.usuario_id) AS numero_usuarios_correctos --cuenta veces usuario_id se repite bajo estas condiciones
FROM Preguntas LEFT JOIN Respuestas  ----De la Tabla Preguntas haciendo un LEFT JOIN con tabla Respuestas
ON Respuestas.pregunta_id = Preguntas.id ---De todos los registros de Respuestas.pregunta_id y sus concidendias con Preguntas.id
AND Respuestas.respuesta = Preguntas.respuesta_correcta --Y que la col Respuestas.respuesta = Preguntas.respuesta_correcta
GROUP BY Preguntas.pregunta, Preguntas.id ---Ese resultado agrupalo por Preguntas.pregunta y ordenalo por Preguntas.id ASC
ORDER BY Preguntas.id ASC;


                            

--8 Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.

ALTER TABLE Respuestas --Altera tabla Respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey --Agrega un Constraint llamado asi
FOREIGN KEY (usuario_id) ----en el FK usuario_id
REFERENCES Usuarios (id) --Referencia id de Usuarios
ON DELETE CASCADE;       --para que se borre con efecto cascada

DELETE FROM Usuarios WHERE id = 1;---borro el usuario con id=1
Select * From usuarios;
Select * From respuestas;
 

--9 Crea una restricción de incluir a usuarios menores de 18 años

ALTER TABLE Usuarios                      --altera la tabla "Usuarios"
ADD CONSTRAINT edad_mayor_igual_a_18      ---agrega resctricción  "edad_mayor_igual_a_18" 
CHECK (edad >= 18);                       --chequeando que el campo "edad" solo permita >= 18

--Verifico
INSERT INTO Usuarios (id, nombre, edad)
VALUES (6, 'Juan Pérez', 17);

--10) Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.

ALTER TABLE Usuarios
ADD COLUMN email varchar(255) UNIQUE;---Unique es un constraint que obliga a que se ocupe un valor único

