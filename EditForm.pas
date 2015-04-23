unit EditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  metaunit, Connect;

type
  TUpdateBase = procedure() of object;

  { TFormEdit }

  TFormEdit = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    ScrollBox: TScrollBox;
    procedure CreateControls(ATable: TMyTable; AId: integer; AUpdate: TUpdateBase);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormEdit: TFormEdit;

implementation

{$R *.lfm}

{ TFormEdit }

procedure TFormEdit.CreateControls(ATable: TMyTable; AId: integer; AUpdate: TUpdateBase);
var
  i: integer;
begin
  for i := 1 to High(ATable.MassOfFields) do begin

  end;
end;

end.

