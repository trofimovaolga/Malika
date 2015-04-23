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
      MyFieldType: TFieldType; MyJoinTable: TMyTable = nil; MyJoinField: string = ''; MyJoinKey: string = ''): TMyField;
    function GetSQL(): string;
    function GetFieldName(FieldID: Integer): string;
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
  MyFieldType: TFieldType; MyJoinTable: TMyTable = nil; MyJoinField: string = '';
  MyJoinKey: string = ''): TMyField;
begin
  SetLength(MassOfFields, Length(MassOfFields) + 1);
  MassOfFields[High(MassOfFields)] := TMyField.Create(MyCaption, MyName, MyWidth,
    MyFieldType, MyJoinTable, MyJoinField, MyJoinKey);
  Result := MassOfFields[High(MassOfFields)];
end;

function TMyTable.GetSQL(): string;
var
  i: integer;
begin
  Result := 'Select ';
  for i := 0 to High(MassOfFields) do begin
    if i > 0 then Result += ', ';
    Result += GetFieldName(i);
  end;
  Result += ' from ' + Name;
  for i := 0 to High(MassOfFields) do begin
    if MassOfFields[i].JoinTable <> nil then
      Result += ' inner join ' + MassOfFields[i].JoinTable.Name
      + ' on ' + Name + '.' + MassOfFields[i].JoinField
      + ' = ' + MassOfFields[i].JoinTable.Name + '.' + MassOfFields[i].JoinKey;
  end;
end;

function TMyTable.GetFieldName(FieldID: Integer): string;
begin
  if MassOfFields[FieldID].JoinTable = nil then
    Result := Name
  else
    Result := MassOfFields[FieldID].JoinTable.Name;
    Result += '.' + MassOfFields[FieldID].Name;
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
  AddField('id', 'ID', 25, ftInteger);
  AddField('Учитель', 'NAME', 185, ftString);
end;
with MassOfTables[1] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Предмет', 'NAME', 185, ftString);
end;
with MassOfTables[2] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Группа', 'NAME', 70, ftString);
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
  AddField('Время', 'PERIOD', 50, ftString, MassOfTables[7], 'PAIR_ID', 'ID');
  AddField('День недели', 'WEEKDAY', 85, ftString, MassOfTables[6], 'WEEKDAY_ID', 'ID');
  AddField('Группа', 'NAME', 60, ftString, MassOfTables[2], 'GROUP_ID', 'ID');
  AddField('Предмет', 'NAME', 75, ftString, MassOfTables[1], 'COURSE_ID', 'ID');
  AddField('Аудитория', 'CLASSROOM', 80, ftString, MassOfTables[3], 'CLASS_ID', 'ID');
  AddField('Учитель', 'NAME', 65, ftString, MassOfTables[0], 'TEACHER_ID', 'ID');
end;
end.

