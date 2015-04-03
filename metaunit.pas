unit metaunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db;

type
  TMyTable = class;

  TMyField = class
    Caption: string;
    Name: string;
    Width: integer;
    FieldType: TFieldType;
    JoinTable: TMyTable;
    JoinField: string;
    JoinKey: string;
    constructor Create(MyCaption, MyName: string; MyWidth: integer;
      MyFieldType: TFieldType; MyJoinTable: TMyTable; MyJoinField: string; MyJoinKey: string);
  end;

  { TMyTable }

  TMyTable = class
    Caption, Name: string;
    MassOfFields: array of TMyField;
    constructor Create(MyCaption, MyName: string);
    function AddField(MyCaption, MyName: string; MyWidth: integer;
      MyFieldType: TFieldType; MyJoinTable: TMyTable = nil; MyJoinField: string = ''; MyJoinKey: string): TMyField;
    function GetSQL(): string;
  end;

var
  MassOfTables: array of TMyTable;

implementation

constructor TMyTable.Create(MyCaption, MyName: string);
  begin
     Caption := MyCaption;
     Name := MyName;
  end;

function TMyTable.AddField(MyCaption, MyName: string; MyWidth: integer;
  MyFieldType: TFieldType; MyJoinTable: TMyTable = nil; MyJoinField: string = ''; MyJoinKey: string): TMyField;
begin
  SetLength(MassOfFields, Length(MassOfFields)+1);
  MassOfFields[High(MassOfFields)] := TMyField.Create(MyCaption, MyName, MyWidth, MyFieldType, MyJoinTable, MyJoinField, MyJoinKey);
  Result := MassOfFields[High(MassOfFields)];
end;

function TMyTable.GetSQL(): string;
var
  i: integer;
begin
  Result := 'Select ';
  for i := 0 to High(MassOfFields) do begin
    if i > 0 then Result += ', ';
    Result += MassOfFields[i].Name;
  end;
  Result += '* from ' + Name;
  for i := 0 to High(MassOfFields) do begin
    if MassOfFields[i].JoinTable <> nil then
      Result += ' inner join ' + MassOfFields[i].JoinTable.Name
      + ' on ' + MassOfFields[i].JoinField
      + ' = ' + MassOfFields[i].JoinKey;
  end;
end;

constructor TMyField.Create(MyCaption, MyName: string; MyWidth: integer;
  MyFieldType: TFieldType; MyJoinTable: TMyTable; MyJoinField: string; MyJoinKey: string);
  begin
     Caption := MyCaption;
     Name := MyName;
     Width := MyWidth;
     FieldType := MyFieldType;
     JoinTable := MyJoinTable;
     JoinField := MyJoinField;
     JoinKey := MyJoinKey;
  end;

initialization

SetLength(MassOfTables, 9);

MassOfTables[0] := TMyTable.Create('Учителя', 'teachers');
MassOfTables[1] := TMyTable.Create('Предметы', 'courses');
MassOfTables[2] := TMyTable.Create('Группы', 'groups');
MassOfTables[3] := TMyTable.Create('Аудитории', 'classrooms');
MassOfTables[4] := TMyTable.Create('Преподаватели предметов', 'teachers_courses');
MassOfTables[5] := TMyTable.Create('Предметы группы', 'groups_courses');
MassOfTables[6] := TMyTable.Create('Дни недели', 'weekdays');
MassOfTables[7] := TMyTable.Create('Пары', 'pairs');
MassOfTables[8] := TMyTable.Create('Расписание', 'lessons');


with MassOfTables[0] do begin
  AddField('id', 'ID', 25, ftString, MassOfTables[4], 'TEACHER_ID');
  AddField('Учитель', 'COURSE_ID', 185, ftString, MassOfTables[1], MassOfTables[1].Name + '.ID');
end;
with MassOfTables[1] do begin
  AddField('id', 'ID', 25, ftString, MassOfTables[5], 'COURSE_ID');
  AddField('Предмет', 'GROUP_ID', 185, ftString, MassOfTables[2], MassOfTables[2].Name + '.ID');
end;
with MassOfTables[2] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Группа', 'Name', 70, ftString);
end;
with MassOfTables[3] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Аудитория', 'CLASSROOM', 70, ftString);
end;
with MassOfTables[4] do begin
  AddField('id Учителя', 'TEACHER_ID', 65, ftInteger);
  AddField('id Предмета', 'COURSE_ID', 75, ftInteger);
end;
with MassOfTables[5] do begin
  AddField('id Группы', 'GROUP_ID', 60, ftInteger);
  AddField('id Предмета', 'COURSE_ID', 75, ftInteger);
end;
with MassOfTables[6] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('День недели', 'WEEKDAY', 80, ftString);
end;
with MassOfTables[7] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Время', 'PERIOD', 80, ftString);
end;
with MassOfTables[8] do begin
  AddField('id Пары', 'PAIR_ID', 50, ftInteger);
  AddField('id Дня недели', 'WEEKDAY_ID', 85, ftInteger);
  AddField('id Группы', 'GROUP_ID', 60, ftInteger);
  AddField('id Предмета', 'COURSE_ID', 75, ftInteger);
  AddField('id Аудитории', 'CLASS_ID', 80, ftInteger);
  AddField('id Учителя', 'TEACHER_ID', 65, ftInteger);
end;
end.

