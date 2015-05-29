CREATE DATABASE 'C:\Malika\TIMETABLE.FDB' user 'SYSDBA' password 'masterkey'; 
SET GENERATOR SQL$DEFAULT TO 1000;


CREATE TABLE teachers(
	ID integer primary key,
	NAME varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_teachers FOR teachers
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE courses(
	ID integer primary key,
	NAME varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_courses FOR courses
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^

CREATE TABLE groups(
	ID integer primary key,
	NAME varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_groups FOR groups
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^

	
CREATE TABLE classrooms(
	ID integer primary key,
	CLASSROOM varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_classrooms FOR classrooms
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE teachers_courses(
	TEACHER_ID integer,
	COURSE_ID integer
	);


CREATE TABLE groups_courses(
	GROUP_ID integer,
	COURSE_ID integer
	);


CREATE TABLE weekdays (
	ID integer primary key,
	weekday varchar(15),
	dayindex integer
	);

SET TERM ^ ;
CREATE TRIGGER autoid_weekdays FOR weekdays
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE pairs(
	id integer primary key,
	period varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_pairs FOR pairs
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE lessons(
	id integer primary key,
	weekday_id integer,
	group_id integer,
	course_id integer,
	class_id integer,
	teacher_id integer
);

SET TERM ^ ;
CREATE TRIGGER autoid_lessons FOR lessons
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^

--Преподаватели	
INSERT INTO teachers VALUES (100, 'Juplev Anton Sergeevich');
INSERT INTO teachers VALUES (101, 'Sporyshev Maksim Sergeevich');
INSERT INTO teachers VALUES (102, 'Pak Gennadiy Konstantinovich');
INSERT INTO teachers VALUES (103, 'Klevchikhin Yuriy Aleksandrovich');
INSERT INTO teachers VALUES (104, 'Klenin Aleksandr Sergeevich');
INSERT INTO teachers VALUES (105, 'Ludov Igor Yurevich');
INSERT INTO teachers VALUES (106, 'Mashencev Vladimir Yurevich');
INSERT INTO teachers VALUES (107, 'Nikolskaya Tatiana Vladimorivna');
INSERT INTO teachers VALUES (108, 'Odin Obshchiy Fizruk');
INSERT INTO teachers VALUES (109, 'Davidiv Denis Vitalievich');
INSERT INTO teachers VALUES (110, 'Dostovalov Valeriy Nikolayevich');
INSERT INTO teachers VALUES (111, 'Shepeleva Riorita Petrovna');
INSERT INTO teachers VALUES (112, 'Romanyuk Mariya Aleksandrovna');
INSERT INTO teachers VALUES (113, 'Pak Tatiana Vladimirovna');
INSERT INTO teachers VALUES (114, 'Brizitskiy Roman Viktorovich');
INSERT INTO teachers VALUES (115, 'Pinko Irina Viktorovna');
INSERT INTO teachers VALUES (116, 'Kravcov Dmitriy Sergeevich');

--Группы
INSERT INTO groups VALUES (200, 'b8103a1');
INSERT INTO groups VALUES (201, 'b8103a2');
INSERT INTO groups VALUES (202, 'b8203a1');
INSERT INTO groups VALUES (203, 'b8203a2');

--Предметы
INSERT INTO courses VALUES (300, 'Algebra and Geometry');
INSERT INTO courses VALUES (301, 'Mathematical analysis');
INSERT INTO courses VALUES (302, 'Workshop on Computer');
INSERT INTO courses VALUES (303, 'Languages and methods of programming');
INSERT INTO courses VALUES (304, 'PhysicalEducation');
INSERT INTO courses VALUES (305, 'English');
INSERT INTO courses VALUES (306, 'Discrete Mathematics');
INSERT INTO courses VALUES (307, 'Databases');
INSERT INTO courses VALUES (308, 'Economy');
INSERT INTO courses VALUES (309, 'Object-oriented analysis');
INSERT INTO courses VALUES (310, 'Physics');
INSERT INTO courses VALUES (311, 'Differential Equations');
INSERT INTO courses VALUES (312, 'Comprehensive analysis');
INSERT INTO courses VALUES (313, 'Numerical Methods');
INSERT INTO courses VALUES (314, 'Life safety');
INSERT INTO courses VALUES (315, 'Economic theory');

--Аудитории
INSERT INTO classrooms VALUES (401, 'D401');
INSERT INTO classrooms VALUES (402, 'D402');
INSERT INTO classrooms VALUES (403, 'D403');
INSERT INTO classrooms VALUES (404, 'D404');
INSERT INTO classrooms VALUES (405, 'D405');
INSERT INTO classrooms VALUES (406, 'D406');
INSERT INTO classrooms VALUES (407, 'D407');
INSERT INTO classrooms VALUES (408, 'D408');
INSERT INTO classrooms VALUES (409, 'D409');
INSERT INTO classrooms VALUES (410, 'D410');
INSERT INTO classrooms VALUES (411, 'D411');
INSERT INTO classrooms VALUES (412, 'D412');
INSERT INTO classrooms VALUES (413, 'D413');
INSERT INTO classrooms VALUES (414, 'D414');

--Дни недели
INSERT INTO weekdays VALUES (501, 'Monday', 1);
INSERT INTO weekdays VALUES (502, 'Tuesday', 2);
INSERT INTO weekdays VALUES (503, 'Wednesday', 3);
INSERT INTO weekdays VALUES (504, 'Thursday', 4);
INSERT INTO weekdays VALUES (505, 'Friday', 5);
INSERT INTO weekdays VALUES (506, 'Satarday', 6);
INSERT INTO weekdays VALUES (507, 'Sunday', 7);

--Отношение Группы-Предметы
INSERT INTO groups_courses VALUES (200, 300);
INSERT INTO groups_courses VALUES (200, 301);
INSERT INTO groups_courses VALUES (200, 302);
INSERT INTO groups_courses VALUES (200, 303);
INSERT INTO groups_courses VALUES (200, 304);
INSERT INTO groups_courses VALUES (200, 305);
INSERT INTO groups_courses VALUES (200, 306);
INSERT INTO groups_courses VALUES (200, 307);
INSERT INTO groups_courses VALUES (200, 309);
INSERT INTO groups_courses VALUES (200, 311);
INSERT INTO groups_courses VALUES (200, 312);
INSERT INTO groups_courses VALUES (201, 300);
INSERT INTO groups_courses VALUES (201, 301);
INSERT INTO groups_courses VALUES (201, 302);
INSERT INTO groups_courses VALUES (201, 303);
INSERT INTO groups_courses VALUES (201, 304);
INSERT INTO groups_courses VALUES (201, 305);
INSERT INTO groups_courses VALUES (201, 306);
INSERT INTO groups_courses VALUES (201, 309);
INSERT INTO groups_courses VALUES (201, 311);
INSERT INTO groups_courses VALUES (201, 312);
INSERT INTO groups_courses VALUES (201, 313);
INSERT INTO groups_courses VALUES (202, 300);
INSERT INTO groups_courses VALUES (202, 301);
INSERT INTO groups_courses VALUES (202, 302);
INSERT INTO groups_courses VALUES (202, 303);
INSERT INTO groups_courses VALUES (202, 304);
INSERT INTO groups_courses VALUES (202, 305);
INSERT INTO groups_courses VALUES (202, 306);
INSERT INTO groups_courses VALUES (202, 307);
INSERT INTO groups_courses VALUES (202, 308);
INSERT INTO groups_courses VALUES (202, 309);
INSERT INTO groups_courses VALUES (202, 311);
INSERT INTO groups_courses VALUES (202, 312);
INSERT INTO groups_courses VALUES (202, 313);
INSERT INTO groups_courses VALUES (202, 314);
INSERT INTO groups_courses VALUES (202, 315);
INSERT INTO groups_courses VALUES (203, 300);
INSERT INTO groups_courses VALUES (203, 301);
INSERT INTO groups_courses VALUES (203, 302);
INSERT INTO groups_courses VALUES (203, 303);
INSERT INTO groups_courses VALUES (203, 304);
INSERT INTO groups_courses VALUES (203, 305);
INSERT INTO groups_courses VALUES (203, 306);
INSERT INTO groups_courses VALUES (203, 307);
INSERT INTO groups_courses VALUES (203, 308);
INSERT INTO groups_courses VALUES (203, 309);
INSERT INTO groups_courses VALUES (203, 310);
INSERT INTO groups_courses VALUES (203, 311);
INSERT INTO groups_courses VALUES (203, 312);
INSERT INTO groups_courses VALUES (203, 313);
INSERT INTO groups_courses VALUES (203, 314);

--Отношение Преподаватели-Предметы
INSERT INTO teachers_courses VALUES (100, 302);
INSERT INTO teachers_courses VALUES (101, 303);
INSERT INTO teachers_courses VALUES (102, 300);
INSERT INTO teachers_courses VALUES (103, 301);
INSERT INTO teachers_courses VALUES (104, 307);
INSERT INTO teachers_courses VALUES (105, 312);
INSERT INTO teachers_courses VALUES (106, 304);
INSERT INTO teachers_courses VALUES (107, 305);
INSERT INTO teachers_courses VALUES (108, 304);
INSERT INTO teachers_courses VALUES (109, 308);
INSERT INTO teachers_courses VALUES (110, 309);
INSERT INTO teachers_courses VALUES (111, 310);
INSERT INTO teachers_courses VALUES (112, 311);
INSERT INTO teachers_courses VALUES (113, 313);
INSERT INTO teachers_courses VALUES (114, 314);
INSERT INTO teachers_courses VALUES (115, 315);
INSERT INTO teachers_courses VALUES (116, 305);

--Время
INSERT INTO pairs VALUES (1, '8:30-10:00');
INSERT INTO pairs VALUES (2, '10:10-11:40');
INSERT INTO pairs VALUES (3, '11:50-13:20');
INSERT INTO pairs VALUES (4, '13:30-15:00');
INSERT INTO pairs VALUES (5, '15:10-16:40');
INSERT INTO pairs VALUES (6, '16:50-18:20');
INSERT INTO pairs VALUES (7, '18:30-20:00');
INSERT INTO pairs VALUES (8, '20:10-21:40');
INSERT INTO pairs VALUES (9, '21:50-23:20');
INSERT INTO pairs VALUES (10, '23:30-01:00');

--Первые 2 группы
--Уроки
--Понедельник
INSERT INTO lessons VALUES(NULL, 501, 200, 302, 401, 100);
INSERT INTO lessons VALUES(NULL, 501, 201, 302, 402, 106);
INSERT INTO lessons VALUES(NULL, 501, 200, 302, 401, 100);
INSERT INTO lessons VALUES(NULL, 501, 201, 302, 402, 106);
INSERT INTO lessons VALUES(NULL, 501, 200, 303, 403, 101);
INSERT INTO lessons VALUES(NULL, 501, 200, 303, 403, 101);
                                
--Вторник                       
INSERT INTO lessons VALUES(NULL, 502, 200, 300, 401, 102);
INSERT INTO lessons VALUES(NULL, 502, 201, 300, 401, 102);
INSERT INTO lessons VALUES(NULL, 502, 200, 306, 402, 102);
INSERT INTO lessons VALUES(NULL, 502, 201, 306, 402, 102);
INSERT INTO lessons VALUES(NULL, 502, 200, 301, 403, 103);
INSERT INTO lessons VALUES(NULL, 502, 201, 301, 403, 103);
INSERT INTO lessons VALUES(NULL, 502, 200, 306, 401, 102);
INSERT INTO lessons VALUES(NULL, 502, 201, 306, 401, 102);
                                
--Среда                         
INSERT INTO lessons VALUES(NULL, 503, 200, 306, 401, 102);
INSERT INTO lessons VALUES(NULL, 503, 201, 306, 401, 102);
INSERT INTO lessons VALUES(NULL, 503, 200, 300, 401, 102);
INSERT INTO lessons VALUES(NULL, 503, 201, 300, 401, 102);
INSERT INTO lessons VALUES(NULL, 503, 200, 300, 403, 102);
INSERT INTO lessons VALUES(NULL, 503, 201, 300, 403, 102);
INSERT INTO lessons VALUES(NULL, 503, 200, 304, 414, 108);
INSERT INTO lessons VALUES(NULL, 503, 201, 304, 414, 108);
                                
--Четверг                       
INSERT INTO lessons VALUES(NULL, 504, 200, 307, 401, 104);
INSERT INTO lessons VALUES(NULL, 504, 201, 307, 401, 104);
INSERT INTO lessons VALUES(NULL, 504, 200, 307, 402, 104);
INSERT INTO lessons VALUES(NULL, 504, 201, 303, 403, 101);
INSERT INTO lessons VALUES(NULL, 504, 200, 303, 404, 105);
INSERT INTO lessons VALUES(NULL, 504, 201, 303, 404, 105);
                                
--Пятница                       
INSERT INTO lessons VALUES(NULL, 505, 200, 301, 401, 103);
INSERT INTO lessons VALUES(NULL, 505, 201, 301, 401, 103);
INSERT INTO lessons VALUES(NULL, 505, 200, 301, 402, 103);
INSERT INTO lessons VALUES(NULL, 505, 201, 301, 402, 103);
                                
--Суббота                       
INSERT INTO lessons VALUES(NULL, 506, 201, 307, 401, 104);
INSERT INTO lessons VALUES(NULL, 506, 201, 307, 401, 104);
INSERT INTO lessons VALUES(NULL, 506, 200, 305, 403, 107);
INSERT INTO lessons VALUES(NULL, 506, 201, 305, 403, 107);
INSERT INTO lessons VALUES(NULL, 506, 200, 304, 414, 108);
INSERT INTO lessons VALUES(NULL, 506, 201, 304, 414, 108);
                                
--Вторые 2 группы               
--Понедельник                   
INSERT INTO lessons VALUES(NULL, 501, 202, 308, 405, 109);
INSERT INTO lessons VALUES(NULL, 501, 203, 308, 405, 109);
INSERT INTO lessons VALUES(NULL, 501, 202, 308, 405, 109);
INSERT INTO lessons VALUES(NULL, 501, 203, 308, 405, 109);
INSERT INTO lessons VALUES(NULL, 501, 202, 309, 406, 100);
INSERT INTO lessons VALUES(NULL, 501, 203, 309, 406, 100);
INSERT INTO lessons VALUES(NULL, 501, 202, 302, 407, 104);
INSERT INTO lessons VALUES(NULL, 501, 203, 309, 408, 100);
INSERT INTO lessons VALUES(NULL, 501, 202, 302, 407, 104);
INSERT INTO lessons VALUES(NULL, 501, 203, 309, 408, 100);
                                
--Вторник                       
INSERT INTO lessons VALUES(NULL, 502, 202, 304, 414, 108);
INSERT INTO lessons VALUES(NULL, 502, 203, 304, 414, 108);
                                
--Среда                         
INSERT INTO lessons VALUES(NULL, 503, 202, 310, 406, 110);
INSERT INTO lessons VALUES(NULL, 503, 203, 310, 406, 110);
INSERT INTO lessons VALUES(NULL, 503, 202, 311, 405, 111);
INSERT INTO lessons VALUES(NULL, 503, 203, 311, 405, 111);
INSERT INTO lessons VALUES(NULL, 503, 202, 311, 405, 111);
INSERT INTO lessons VALUES(NULL, 503, 203, 311, 405, 111);
INSERT INTO lessons VALUES(NULL, 503, 202, 310, 407, 110);
INSERT INTO lessons VALUES(NULL, 503, 203, 310, 407, 110);
INSERT INTO lessons VALUES(NULL, 503, 202, 305, 406, 112);
INSERT INTO lessons VALUES(NULL, 503, 203, 305, 406, 112);
                                
--Четверг                       
INSERT INTO lessons VALUES(NULL, 504, 202, 312, 405, 103);
INSERT INTO lessons VALUES(NULL, 504, 203, 312, 405, 103);
INSERT INTO lessons VALUES(NULL, 504, 202, 313, 406, 113);
INSERT INTO lessons VALUES(NULL, 504, 203, 313, 406, 113);
INSERT INTO lessons VALUES(NULL, 504, 202, 312, 407, 103);
INSERT INTO lessons VALUES(NULL, 504, 203, 312, 407, 103);
INSERT INTO lessons VALUES(NULL, 504, 202, 313, 408, 114);
INSERT INTO lessons VALUES(NULL, 504, 203, 313, 408, 114);
INSERT INTO lessons VALUES(NULL, 504, 202, 314, 409, 115);
INSERT INTO lessons VALUES(NULL, 504, 203, 314, 409, 115);
                                
--Пятница                       
INSERT INTO lessons VALUES(NULL, 505, 202, 309, 405, 100);
INSERT INTO lessons VALUES(NULL, 505, 203, 302, 405, 104);
INSERT INTO lessons VALUES(NULL, 505, 202, 309, 405, 100);
INSERT INTO lessons VALUES(NULL, 505, 203, 302, 405, 104);
INSERT INTO lessons VALUES(NULL, 505, 202, 315, 406, 116);
INSERT INTO lessons VALUES(NULL, 505, 203, 315, 406, 116);
INSERT INTO lessons VALUES(NULL, 505, 202, 304, 414, 108);
INSERT INTO lessons VALUES(NULL, 505, 203, 304, 414, 108);

--Суббота





	
