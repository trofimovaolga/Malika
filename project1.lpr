program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Malika, metaunit, Connect, TableForm, EditForm;

{$R *.res}

begin
  Application.Title:='Malika';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConnection, Connection);
  Application.CreateForm(TFormEdit, FormEdit);
  Application.Run;
end.

