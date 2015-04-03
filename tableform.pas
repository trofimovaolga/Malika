unit TableForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, Connect, MetaUnit;

type

  { TTableForm }

  TTableForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    SQLQuery: TSQLQuery;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure MakeForm(FormID: Integer);

var
  //TableForm: TTableForm;
  MassOfForms: array of TTableForm;

implementation

{$R *.lfm}

procedure MakeForm(FormID: Integer);
begin
  if MassOfForms[FormID] = nil then begin
    Application.CreateForm(TTableForm, MassOfForms[FormID]);
    MassOfForms[FormID].Tag := FormID;
    MassOfForms[FormID].Show;
  end
  else MassOfForms[FormID].ShowOnTop;
end;

{ TTableForm }

procedure TTableForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  MassOfForms[Tag] := nil;
end;

procedure TTableForm.FormActivate(Sender: TObject);
var
  i: integer;
begin
  SQLQuery.Close;
  SQLQuery.SQL.Text := MassOfTables[Tag].GetSQL();
  SQLQuery.Open;

  Caption := MassOfTables[Tag].Caption;
  for i := 0 to High(MassOfTables[Tag].MassOfFields) do
    with DBGrid.Columns.Items[i] do begin
      Title.Caption := MassOfTables[Self.Tag].MassOfFields[i].Caption;
      Width := MassOfTables[Self.Tag].MassOfFields[i].Width;
    end;
end;

initialization

  SetLength(MassOfForms, 9);

end.
