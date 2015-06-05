@echo off
del TIMETABLE.FDB
cd /d C:\Program Files\Firebird\Firebird_2_1\bin
isql.exe -i C:\Univer\DB\Malika\timetable_create.sql
pause>nul