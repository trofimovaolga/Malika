unit metaunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db;
const
  ScheduleFildsNum = 6;

type
  TMyTable = class;

  { TMyField }

  TMyField = class
    Caption, Name, Order: string;
    Width: integer;
    FieldType: TFieldType;
    JoinTable: TMyTable;
    JoinField: string;
    JoinKey: string;
    constructor Create(MyCaption, MyName: string; MyWidth: integer;
      MyFieldType: TFieldType; MyJoinTable: TMyTable; MyJoinField: string;
      MyJoinKey: string; MyOrder: string);
  end;

  { TMyTable }

  TMyTable = class
    Caption, Name: string;
    ArrOfFields: array of TMyField;
    constructor Create(MyCaption, MyName: string);
    function AddField(MyCaption, MyName: string; MyWidth: integer;
             MyFieldType: TFieldType; MyJoinTable: TMyTable = nil;
             MyJoinField: string = ''; MyJoinKey: string = '';
             MyOrder: string = ''): TMyField;
    function GetSQL(): string;
    function GetFieldName(FieldID: Integer): string;
  end;

var
  ArrOfTables: array of TMyTable;
  ScheduleTable: TMyTable;

implementation

constructor TMyTable.Create(MyCaption, MyName: string);
begin
   Caption := MyCaption;
   Name := MyName;
end;

function TMyTable.AddField(MyCaption, MyName: string; MyWidth: integer;
  MyFieldType: TFieldType; MyJoinTable: TMyTable; MyJoinField: string;
  MyJoinKey: string; MyOrder: string): TMyField;
begin
  SetLength(ArrOfFields, Length(ArrOfFields) + 1);
  ArrOfFields[High(ArrOfFields)] := TMyField.Create(MyCaption, MyName, MyWidth,
                             MyFieldType, MyJoinTable, MyJoinField, MyJoinKey, MyOrder);
  Result := ArrOfFields[High(ArrOfFields)];
end;

function TMyTable.GetSQL(): string;
var
  i: integer;
begin
  Result := 'Select ';
  for i := 0 to High(ArrOfFields) do begin
    if i > 0 then Result += ', ';
    Result += GetFieldName(i);
  end;
  Result += ' from ' + Name;
  for i := 0 to High(ArrOfFields) do begin
    if ArrOfFields[i].JoinTable <> nil then
      Result += ' inner join ' + ArrOfFields[i].JoinTable.Name
      + ' on ' + Name + '.' + ArrOfFields[i].JoinField
      + ' = ' + ArrOfFields[i].JoinTable.Name + '.' + ArrOfFields[i].JoinKey;
  end;
end;

function TMyTable.GetFieldName(FieldID: Integer): string;
begin
  if ArrOfFields[FieldID].JoinTable = nil then
    Result := Name
  else
    Result := ArrOfFields[FieldID].JoinTable.Name;
    Result += '.' + ArrOfFields[FieldID].Name;
end;

constructor TMyField.Create(MyCaption, MyName: string; MyWidth: integer;
  MyFieldType: TFieldType; MyJoinTable: TMyTable; MyJoinField: string;
  MyJoinKey: string; MyOrder: string);
  begin
     Caption := MyCaption;
     Name := MyName;
     Order := MyOrder;
     Width := MyWidth;
     FieldType := MyFieldType;
     JoinTable := MyJoinTable;
     JoinField := MyJoinField;
     JoinKey := MyJoinKey;
  end;

initialization

SetLength(ArrOfTables, 9);

ArrOfTables[0] := TMyTable.Create('Учителя', 'teachers');
ArrOfTables[1] := TMyTable.Create('Предметы', 'courses');
ArrOfTables[2] := TMyTable.Create('Группы', 'groups');
ArrOfTables[3] := TMyTable.Create('Аудитории', 'classrooms');
ArrOfTables[4] := TMyTable.Create('Преподаватели предметов', 'teachers_courses');
ArrOfTables[5] := TMyTable.Create('Предметы группы', 'groups_courses');
ArrOfTables[6] := TMyTable.Create('Дни недели', 'weekdays');
ArrOfTables[7] := TMyTable.Create('Пары', 'pairs');
ArrOfTables[8] := TMyTable.Create('Расписание', 'lessons');

with ArrOfTables[0] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Учитель', 'TEACHER', 185, ftString);
end;
with ArrOfTables[1] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Предмет', 'COURSE', 185, ftString);
end;
with ArrOfTables[2] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Группа', 'GROUPS', 70, ftString);
end;
with ArrOfTables[3] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Аудитория', 'CLASSROOM', 70, ftString);
end;
with ArrOfTables[4] do begin
  AddField('id Учителя', 'TEACHER_ID', 65, ftInteger);
  AddField('id Предмета', 'COURSE_ID', 75, ftInteger);
end;
with ArrOfTables[5] do begin
  AddField('id Группы', 'GROUP_ID', 60, ftInteger);
  AddField('id Предмета', 'COURSE_ID', 75, ftInteger);
end;
with ArrOfTables[6] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('День недели', 'WEEKDAY', 80, ftString);
  AddField('Индекс дня', 'DAYINDEX', 80, ftInteger);
end;
with ArrOfTables[7] do begin
  AddField('id', 'ID', 25, ftInteger);
  AddField('Время', 'PERIOD', 80, ftString);
end;
with ArrOfTables[8] do begin
  AddField('id', 'id', 45, ftInteger);
  AddField('День недели', 'WEEKDAY', 75, ftString, ArrOfTables[6], 'WEEKDAY_ID', 'ID', 'DAYINDEX');
  AddField('Группа', 'GROUPS', 60, ftString, ArrOfTables[2], 'GROUP_ID', 'ID', 'GROUPS');
  AddField('Предмет', 'COURSE', 215, ftString, ArrOfTables[1], 'COURSE_ID', 'ID', 'COURSE');
  AddField('Аудитория', 'CLASSROOM', 65, ftString, ArrOfTables[3], 'CLASS_ID', 'ID', 'CLASSROOM');
  AddField('Учитель', 'TEACHER', 200, ftString, ArrOfTables[0], 'TEACHER_ID', 'ID', 'TEACHER');
end;

ScheduleTable := ArrOfTables[8];
end.

