CREATE DATABASE 'C:\Univer\DB\Malika\TIMETABLE.FDB' user 'SYSDBA' password 'masterkey' default character set UTF8; 
SET GENERATOR SQL$DEFAULT TO 1000;


CREATE TABLE teachers(
	ID integer primary key,
	TEACHER varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_teachers FOR teachers
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE courses(
	ID integer primary key,
	COURSE varchar(50)
	);

SET TERM ^ ;
CREATE TRIGGER autoid_courses FOR courses
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^

CREATE TABLE groups(
	ID integer primary key,
	GROUPS varchar(50)
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
	WEEKDAY varchar(15),
	DAYINDEX integer
	);

SET TERM ^ ;
CREATE TRIGGER autoid_weekdays FOR weekdays
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN 
  if (NEW.ID is NULL) then NEW.ID = GEN_ID(SQL$DEFAULT, 1);
END^ SET TERM ; ^


CREATE TABLE pairs(
	ID integer primary key,
	PERIOD varchar(50)
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
INSERT INTO teachers VALUES (100, 'Жуплев Антон Сергеевич');
INSERT INTO teachers VALUES (101, 'Спорышев Максим Сергеевич');
INSERT INTO teachers VALUES (102, 'Пак Геннадий Константинович');
INSERT INTO teachers VALUES (103, 'Клевчихин Юрий Александрович');
INSERT INTO teachers VALUES (104, 'Кленин Александр Сергеевич');
INSERT INTO teachers VALUES (105, 'Лудов Игорь Юрьевич');
INSERT INTO teachers VALUES (106, 'Машенцев Владимир Юрьевич');
INSERT INTO teachers VALUES (107, 'Никольская Татьяна Владимировна');
INSERT INTO teachers VALUES (108, 'Физрук');
INSERT INTO teachers VALUES (109, 'Давыдов Денис Витальевич');
INSERT INTO teachers VALUES (110, 'Достовалов Валерий Николаевич');
INSERT INTO teachers VALUES (111, 'Щепелева Риорита Петровна');
INSERT INTO teachers VALUES (112, 'Романюк Мария Александровна');
INSERT INTO teachers VALUES (113, 'Пак Татьяна Владимировна');
INSERT INTO teachers VALUES (114, 'Бризицкий Роман Викторович');
INSERT INTO teachers VALUES (115, 'Пинько Ирина Викторовна');
INSERT INTO teachers VALUES (116, 'Кравцов Дмитрий Сергеевич');

--Группы
INSERT INTO groups VALUES (200, 'b8103a1');
INSERT INTO groups VALUES (201, 'b8103a2');
INSERT INTO groups VALUES (202, 'b8203a1');
INSERT INTO groups VALUES (203, 'b8203a2');

--Предметы
INSERT INTO courses VALUES (300, 'Алгебра и геометрия');
INSERT INTO courses VALUES (301, 'Математический анализ');
INSERT INTO courses VALUES (302, 'Практикум на ЭВМ');
INSERT INTO courses VALUES (303, 'Языки и методы программирования');
INSERT INTO courses VALUES (304, 'Физра');
INSERT INTO courses VALUES (305, 'English');
INSERT INTO courses VALUES (306, 'Дискретная математика');
INSERT INTO courses VALUES (307, 'Базы данных');
INSERT INTO courses VALUES (308, 'Экономика');
INSERT INTO courses VALUES (309, 'Объектно-ориентированный анализ');
INSERT INTO courses VALUES (310, 'Физика');
INSERT INTO courses VALUES (311, 'Дифференциальные уравнения');
INSERT INTO courses VALUES (312, 'Комплексный анализ');
INSERT INTO courses VALUES (313, 'Численные методы');
INSERT INTO courses VALUES (314, 'Безопасность жизнедеятельности');
INSERT INTO courses VALUES (315, 'Теория экономики');

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
INSERT INTO weekdays VALUES (501, 'Понедельник', 1);
INSERT INTO weekdays VALUES (502, 'Вторник', 2);
INSERT INTO weekdays VALUES (503, 'Среда', 3);
INSERT INTO weekdays VALUES (504, 'Четверг', 4);
INSERT INTO weekdays VALUES (505, 'Пятница', 5);
INSERT INTO weekdays VALUES (506, 'Суббота', 6);
INSERT INTO weekdays VALUES (507, 'Воскресенье', 7);

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
