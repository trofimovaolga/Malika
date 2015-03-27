unit TableUnit;
{$mode objfpc}{$H+}
    interface
uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, Connect, metaunit;
type

  { TTableForm }

  TTableForm = class(TForm)
      DataSource: TDataSource;
      DBGrid: TDBGrid;
      DBNavigator: TDBNavigator;
      SQLQuery: TSQLQuery;
      procedure FormCreate(Sender: TObject);
      constructor Create(FormCaption: string; index: integer);
  end;

  var
    //TableForm: TTableForm;
    MassOfForms: array of TTableForm;
implementation

procedure TTableForm.FormCreate(Sender: TObject);
begin
  DBGrid := TDBGrid.Create(Sender as TTableForm);
  with DBGrid do begin
    Align := alClient;
    Parent := Sender as TTableForm;
    Color := clWindow;
    DataSource := DataSource;
  end;

  SQLQuery := TSQLQuery.Create(Sender as TTableForm);
  with SQLQuery do begin
    Database := Connection.SQLTransaction.DataBase;
    Transaction := Connection.SQLTransaction;
    Close;
    SQL.Clear;
    SQL.Text := 'Select * from teachers';
    Open;
  end;

  DBNavigator := TDBNavigator.Create(Sender as TTableForm);
  with DBNavigator do begin
    Align := alClient;
    Parent := Sender as TTableForm;
    DataSource := DataSource;
  end;

  DataSource := TDataSource.Create(Sender as TTableForm);
  DataSource.DataSet := SQLQuery;
end;

constructor TTableForm.Create(FormCaption: string; index: integer);
begin
  CreateNew(Application);
  Caption := FormCaption;
  Tag := index;
  FormCreate(Self);
end;

initialization

SetLength(MassOfForms, 9);
end.


