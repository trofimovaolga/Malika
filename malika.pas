unit Malika;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  DbCtrls, StdCtrls, Menus, ExtCtrls, MetaUnit, TableForm;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Memo: TMemo;
    Reference: TMenuItem;
    MenuAbout: TMenuItem;
    MenuExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure Exception(Sender: TObject; E: Exception);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  NewItem: TMenuItem;
  i: integer;
begin
  for i := 0 to High(MassOfTables) do begin
    NewItem := TMenuItem.Create(nil);
    with NewItem do begin
      Caption := MassOfTables[i].Caption;
      Name := MassOfTables[i].Name;
      Tag := i;
      OnClick := @Self.MenuItemClick;
    end;
    Reference.Add(NewItem);
  end;
  Application.OnException := @Exception;
end;

procedure TMainForm.MenuItemClick(Sender: TObject);
begin
  MakeForm((Sender as TMenuItem).tag);
end;

procedure TMainForm.Exception(Sender: TObject; E: Exception);
begin
  ShowOnTop;
  Memo.Text := E.Message;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  ShowMessage('Разработчик - Трофимова О.Н.'+#13#10+'Преподаватель - Кленин А.С.');
end;

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  close;
end;

end.
