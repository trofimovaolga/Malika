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
var
  i: integer;
begin
  if MassOfForms[FormID] = nil then begin
    Application.CreateForm(TTableForm, MassOfForms[FormID]);
    with MassOfForms[FormID] do begin
      Tag := FormID;
      SQLQuery.Close;
      SQLQuery.SQL.Text := 'Select * from ' + MassOfTables[FormID].Name;
      SQLQuery.Open;
      Caption := MassOfTables[FormID].Caption;
    end;
    for i := 0 to High(MassOfTables[FormID].MassOfFields) do
      with MassOfForms[FormID].DBGrid.Columns.Items[i] do begin
        Title.Caption := MassOfTables[FormID].MassOfFields[i].Caption;
        Width := MassOfTables[FormID].MassOfFields[i].Width;
      end;
  end
  else begin
    MassOfForms[FormID].ShowOnTop;
  end;
end;

{ TTableForm }

procedure TTableForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  MassOfForms[Tag] := nil;
end;

initialization

  SetLength(MassOfForms, 9);

end.
