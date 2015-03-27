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
  Application.CreateForm(TTableForm, MassOfForms[FormID]);
  with MassOfForms[FormID] do begin
    SQLQuery.Close;
    SQLQuery.SQL.Clear;
    SQLQuery.SQL.Text := 'Select * from teachers';
    SQLQuery.Open;
  end;
end;

initialization

  SetLength(MassOfForms, 9);

end.
