unit metaunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db;

type
  TMyField = class
    Caption, Name: string;
    Width: integer;
    FieldType: TFieldType;
    constructor Create(MyCaption, MyName: string; MyWidth: integer; MyFieldType: TFieldType);
  end;

  { TMyTable }

  TMyTable = class
    Caption, Name: string;
    MassOfFields: array of TMyField;
    constructor Create(MyCaption, MyName: string);
    function AddField(MyCaption, MyName: string; MyWidth: integer; MyFieldType: TFieldType): TMyField;
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
  MyFieldType: TFieldType): TMyField;
begin
  SetLength(MassOfFields, Length(MassOfFields)+1);
  MassOfFields[High(MassOfFields)] := TMyField.Create(MyCaption, MyName, MyWidth, MyFieldType);
  Result := MassOfFields[High(MassOfFields)];
end;

constructor TMyField.Create(MyCaption, MyName: string; MyWidth: integer; MyFieldType: TFieldType);
  begin
     Caption := MyCaption;
     Name := MyName;
     Width := MyWidth;
     FieldType := MyFieldType;
  end;

initialization

SetLength(MassOfTables, 9);

MassOfTables[0] := TMyTable.Create('Учителя', 'teachers');
with MassOfTables[0] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[1] := TMyTable.Create('Предметы', 'subjects');
with MassOfTables[1] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[2] := TMyTable.Create('Группы', 'groups');
with MassOfTables[2] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[3] := TMyTable.Create('Аудитории', 'classrooms');
with MassOfTables[3] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[4] := TMyTable.Create('Преподаватели предметов', 'teachers_subjects');
with MassOfTables[4] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[5] := TMyTable.Create('Предметы группы', 'groups_subjects');
with MassOfTables[5] do begin
  AddField('id группы', 'GROUP_ID', 15, ftInteger);
  AddField('id предмета', 'SUBJECT_ID', 15, ftInteger);
end;
MassOfTables[6] := TMyTable.Create('Дни недели', 'weekday');
with MassOfTables[6] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[7] := TMyTable.Create('Пары', 'pair');
with MassOfTables[7] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;
MassOfTables[8] := TMyTable.Create('Расписание', 'lessons');
with MassOfTables[8] do begin
  AddField('id', 'ID', 15, ftInteger);
  AddField('Имя', 'Name', 100, ftString);
end;

end.

