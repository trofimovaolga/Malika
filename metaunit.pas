unit metaunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db;

type
  TMyTable = class
    Caption, Name: string;
    constructor Create(MyCaption, MyName: string);
  end;
//
//  TMyField = class
//    Caption, Name: string;
//    Width: integer;
//    FieldType: TFieldType;
//    constructor Create(MyCaption, MyName: string; MyWidth: integer; MyFieldType: TFieldType);
//  end;

var
  MassOfTables: array of TMyTable;
  //MassOfFields: array of TMyField;
  i, n: integer;

implementation

constructor  TMyTable.Create(MyCaption, MyName: string);
  begin
     Caption := MyCaption;
     Name := MyName;
  end;
//
//constructor TMyField.Create(MyCaption, MyName: string; MyWidth: integer; MyFieldType: TFieldType);
//  begin
//     Caption := MyCaption;
//     Name := MyName;
//     Width := MyWidth;
//     FieldType := MyFieldType;
//  end;

initialization

SetLength(MassOfTables, 9);

MassOfTables[0] := TMyTable.Create('Учителя', 'teachers');
MassOfTables[1] := TMyTable.Create('Предметы', 'subjects');
MassOfTables[2] := TMyTable.Create('Группы', 'groups');
MassOfTables[3] := TMyTable.Create('Аудитории', 'classrooms');
MassOfTables[4] := TMyTable.Create('Преподаватели предметов', 'teachers_subjects');
MassOfTables[5] := TMyTable.Create('Предметы группы', 'groups_subjects');
MassOfTables[6] := TMyTable.Create('Дни недели', 'weekday');
MassOfTables[7] := TMyTable.Create('Пары', 'pair');
MassOfTables[8] := TMyTable.Create('Расписание', 'lessons');
end.

