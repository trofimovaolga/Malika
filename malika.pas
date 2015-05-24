unit Malika;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBCtrls, StdCtrls, Menus, ExtCtrls, MetaUnit, TableForm, ScheduleForm;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Memo: TMemo;
    ScheduleMenu: TMenuItem;
    Reference: TMenuItem;
    MenuAbout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure Exception(Sender: TObject; E: Exception);
    procedure ScheduleMenuClick(Sender: TObject);
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
  for i := 0 to High(ArrOfTables) do
  begin
    NewItem := TMenuItem.Create(nil);
    with NewItem do
    begin
      Caption := ArrOfTables[i].Caption;
      Name := ArrOfTables[i].Name;
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

procedure TMainForm.ScheduleMenuClick(Sender: TObject);
begin
  Schedule.Show;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  ShowMessage('Работа с расписанием в формате базы данных' + #13#10
                      + 'Разработчик - Трофимова О.Н.' + #13#10
                      + 'Преподаватель - Кленин А.С.');
end;
end.
