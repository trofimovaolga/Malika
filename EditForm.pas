unit EditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls, metaunit, Connect, Clipbrd;

type
  { TMyComboBox }
  TRefresh = procedure of object;

  TMyComboBox = class(TComboBox)
  private
    MySQLQuery: TSQLQuery;
    MyDataSource: TDataSource;
  public
    DataName: array of string;
    DataId: array of integer;
    constructor Create(AWidth, AHeight, ATop, ALeft, AID: integer;
      AScrollBox: TScrollBox; ATableName, AFieldName, AMainT, AMainF: string);
  end;

  { TMyEdit }

  TMyEdit = class(TEdit)
  private
    MySQLQuery: TSQLQuery;
    MyDataSource: TDataSource;
  public
    procedure MyBtnPress(Sender: TObject; var Key: char);
    constructor Create(AWidth, AHeight, ATop, ALeft, AID: integer;
      AScrollBox: TScrollBox; AMainT, AMainF: string; AFieldType: TFieldType);
  end;


  { TFormEdit }

  TFormEdit = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    DataSource: TDataSource;
    ScrollBox: TScrollBox;
    SQLQuery: TSQLQuery;
    MyComboBox: TDBComboBox;
    procedure BtnCancelClick(Sender: TObject);
    procedure CreateEditField();
    procedure BtnOKClick(Sender: TObject);
    constructor Create(ATable: TMyTable; AId: integer; ARefresh: TRefresh);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FTable: TMyTable;
  public
    FId: integer;
    ArrComboBox: array of TMyComboBox;
    ArrEdit: array of TMyEdit;
    Refr: TRefresh;
  end;

var
  FormEdit: TFormEdit;
  ArrFormEdit: array of TFormEdit;

  procedure AddCell(Aid, ATag: integer; ARefresh: TRefresh);
  procedure DelCell(Aid: integer);

implementation

{$R *.lfm}

procedure AddCell(Aid, ATag: integer; ARefresh: TRefresh);
var
  i: integer;
begin
  for i := 0 to High(ArrFormEdit) do
    if AId = ArrFormEdit[i].FId then
    begin
      ArrFormEdit[i].Show;
      Exit;
    end;
  SetLength(ArrFormEdit, Length(ArrFormEdit) + 1);
  ArrFormEdit[High(ArrFormEdit)] := TFormEdit.Create(ArrOfTables[ATag], AId, ARefresh);
  ArrFormEdit[High(ArrFormEdit)].CreateEditField;
  ArrFormEdit[High(ArrFormEdit)].Show;
end;

{после ОК убирает закрытую форму из массива открытых форм и обновляет данные в таблице}
procedure DelCell(Aid: integer);
var
  i, j: integer;
begin
  for i := 0 to High(ArrFormEdit) do
  begin
    if ArrFormEdit[i].FId = Aid then
    begin
      for j := i + 1 to High(ArrFormEdit) do  //которую надо удал., смещаем на позицию те
        ArrFormEdit[j - 1] := ArrFormEdit[j];  //что идут после удаляемой
    end;
  end;
  SetLength(ArrFormEdit, Length(ArrFormEdit) - 1);
end;

{ TMyEdit }

procedure TMyEdit.MyBtnPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9', #13]) then
    key := ' ';    //#13 - backspace
end;

constructor TMyEdit.Create(AWidth, AHeight, ATop, ALeft, AID: integer;
  AScrollBox: TScrollBox; AMainT, AMainF: string; AFieldType: TFieldType);
var
  i, kId: integer;
begin
  inherited Create(AScrollBox);
  Parent := AScrollBox;
  MySQLQuery := TSQLQuery.Create(AScrollBox);
  MyDataSource := TDataSource.Create(AScrollBox);
  MyDataSource.DataSet := MySQLQuery;
  with MySQLQuery do
  begin
    Transaction := Connection.SQLTransaction;
    DataBase := Connection.IBConnection;
  end;

  if AFieldType = ftInteger then
    OnKeyPress := @MyBtnPress;
  Width := AWidth;
  Height := AHeight;
  Top := ATop;
  Left := ALeft;
  if AID = -1 then
    Exit;
  MySQLQuery.Close;
  MySQLQuery.SQL.Text := Format('Select %s from %s where ID = %d',
    [AMainF, AMainT, AID]);
  MySQLQuery.Open;
  Text := MySQLQuery.FieldByName(AMainF).AsString;
end;

{ TMyComboBox }

constructor TMyComboBox.Create(AWidth, AHeight, ATop, ALeft, AID: integer;
  AScrollBox: TScrollBox; ATableName, AFieldName, AMainT, AMainF: string);
var
  i, kId: integer;
begin
  inherited Create(AScrollBox);
  Parent := AScrollBox;
  MySQLQuery := TSQLQuery.Create(AScrollBox);
  MyDataSource := TDataSource.Create(AScrollBox);
  MyDataSource.DataSet := MySQLQuery;
  with MySQLQuery do
  begin
    Transaction := Connection.SQLTransaction;
    DataBase := Connection.IBConnection;
    Close;
    SQL.Text := Format('Select * from %s', [ATableName]);
    Open;

    while not EOF do
    begin
      SetLength(DataId, Length(DataId) + 1);
      SetLength(DataName, Length(DataName) + 1);
      DataName[High(DataName)] := FieldByName(AFieldName).AsString;
      DataId[High(DataId)] := FieldByName('ID').AsInteger;
      Next;
    end;
  end;

  Width := AWidth;
  Height := AHeight;
  Top := ATop;
  Left := ALeft;
  Items.AddStrings(DataName);
  ReadOnly := True;
  if AID = -1 then
    Exit;
  MySQLQuery.Close;
  MySQLQuery.SQL.Text := Format('Select %s from %s where ID = %d',
    [AMainF, AMainT, AID]);
  MySQLQuery.Open;
  kId := MySQLQuery.FieldByName(AMainF).AsInteger;
  i := 0;
  while DataId[i] <> kId do
    Inc(i);
  ItemIndex := i;
end;

{ TFormEdit }

constructor TFormEdit.Create(ATable: TMyTable; AId: integer; ARefresh: TRefresh);
begin
  inherited Create(nil);
  FTable := ATable;
  FId := AId;
  Refr := ARefresh;
end;

procedure TFormEdit.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DelCell(FId);
  Refr;
end;

procedure TFormEdit.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEdit.CreateEditField;
var
  i: integer;
  lable: TStaticText;
begin
  if FId = -1 then
    Self.Caption := 'Добавление'
  else
    Self.Caption := 'Изменение';
  for i := 1 to High(FTable.ArrOfFields) do
    with FTable.ArrOfFields[i] do
    begin
      lable := TStaticText.Create(ScrollBox);
      with lable do
      begin
        Parent := ScrollBox;
        Top := 40 * i;
        Left := 5;
        Height := 24;
        Width := 50;
        Caption := FTable.ArrOfFields[i].Caption;
      end;
      if JoinTable <> nil then
      begin
        SetLength(ArrComboBox, Length(ArrComboBox) + 1);
        ArrComboBox[High(ArrComboBox)] :=
          TMyComboBox.Create(300, 100, 40 * i, 100,
          FId, ScrollBox, JoinTable.Name, Name, FTable.Name,
          JoinField);
      end
      else
      begin
        SetLength(ArrEdit, Length(ArrEdit) + 1);
        ArrEdit[High(ArrEdit)] :=
          TMyEdit.Create(300, 100, 40 * i, 100, FId,
          ScrollBox, FTable.Name, Name, FieldType);
      end;
    end;
end;

procedure TFormEdit.BtnOKClick(Sender: TObject);
var
  Str: string;
  i, j: integer;
begin
  i := 0;        //бежит по эдитам
  j := 0;        //бежит по комбобоксам
  SQLQuery.Close;
  if FId = -1 then
  begin                        //триггер заменит НУЛ на ключ
    Str := Format('INSERT INTO %s VALUES ( NULL ', [FTable.Name]);
    while i + j + 1 < Length(FTable.ArrOfFields) do
    begin
      if FTable.ArrOfFields[i + j + 1].JoinTable = nil then
      begin
        Str += ', :param' + IntToStr(i);
        Inc(i);
      end
      else
      begin
        if ArrComboBox[j].ItemIndex = -1 then
        begin
          ShowMessage('Заполните поля');
          Exit;
        end;
        Str += Format(' , %d ', [ArrComboBox[j].DataId[ArrComboBox[j].ItemIndex]]);
        Inc(j);
      end;
    end;
    SQLQuery.SQL.Text := Str + ' );';
  end
  else
  begin
    Str := Format('update %s set ', [FTable.Name]);
    while i + j + 1 < Length(FTable.ArrOfFields) do
    begin
      if FTable.ArrOfFields[i + j + 1].JoinTable = nil then
      begin
        Str += Format(' %s = :param%d ,', [FTable.ArrOfFields[i + j + 1].Name, i]);
        Inc(i);
      end
      else
      begin
        Str += Format(' %s = %d , ', [FTable.ArrOfFields[i + j + 1].JoinField,
          ArrComboBox[j].DataId[ArrComboBox[j].ItemIndex]]);
        Inc(j);
      end;
    end;               //-2 из-за лишних " ,", заменяем на where id...
    SQLQuery.SQL.Text := Copy(Str, 1, Length(str) - 2) + Format(' where ID = %d ', [FId]);
  end;

  for i := 0 to High(ArrEdit) do
    SQLQuery.ParamByName('param' + IntToStr(i)).AsString := ArrEdit[i].Text;
  Clipboard.AsText := SQLQuery.SQL.Text; //кладет запрос в буфер
  SQLQuery.ExecSQL;  //Выполнить запрос

  Self.Close;
end;

end.
