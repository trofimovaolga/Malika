unit ForThePoor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, StdCtrls, Menus, MetaUnit, TableForm, Connect;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Memo: TMemo;
    Reference: TMenuItem;
    MenuAbout: TMenuItem;
    MenuExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure Error(E: exception);
    procedure MenuItemClick(Sender: TObject);
  private
    { private declarations }
    MemoUsed: boolean;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  newitem: TMenuItem;
begin
  for i := 0 to 8 do begin { TODO 1 : autodetect count of tables }
    newitem := TMenuItem.Create(nil);
    with newitem do begin
      Caption := MassOfTables[i].Caption;
      Name := MassOfTables[i].Name;
      Tag := i;
      OnClick := @Self.MenuItemClick;
    end;
    Reference.Add(newitem);
  end;
end;

procedure TMainForm.MenuItemClick(Sender: TObject);
begin
  MakeForm((Sender as TMenuItem).tag);
end;

procedure TMainForm.MemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); inline;
begin
  if not MemoUsed then begin
    Memo.Lines.Text := '';
    MemoUsed := true;
  end;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  ShowMessage('Разработчик - Трофимова О.Н.'+#13#10+'Преподаватель - Кленин А.С.');
end;

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.Error(E: exception);
begin
  Memo.Lines.Text := E.Message;
  ShowOnTop;
end;

end.
