unit TableForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, ExtCtrls, StdCtrls, Menus, MetaUnit, EditForm;

type

  TFilter = record
    Field : Integer;
    Operation : Integer;
    Constant : String;
  end;

  { TTableForm }

  TTableForm = class(TForm)
    AddFilter: TButton;
    DescBox: TCheckBox;
    MainMenu: TMainMenu;
    MenuEdit: TMenuItem;
    MenuAdd: TMenuItem;
    MenuChange: TMenuItem;
    MenuDel: TMenuItem;
    SortField: TComboBox;
    DeleteFilters: TButton;
    FilterFields: TComboBox;
    FilterOps: TComboBox;
    FilterConst: TComboBox;
    FiltersList: TListBox;
    Retrieve: TButton;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    SQLQuery: TSQLQuery;
    procedure DBGridDblClick(Sender: TObject);
    function GetFilterExpr(FilterID: Integer): string;
    procedure MenuAddClick(Sender: TObject);
    procedure MenuDelClick(Sender: TObject);
    procedure RetrieveData();
    procedure RetrieveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure AddFilterClick(Sender: TObject);
    procedure DeleteFiltersClick(Sender: TObject);
    procedure FilterConstKeyPress(Sender: TObject; var Key: char);
    procedure FilterPartChange(Sender: TObject);
    procedure FiltersListSelectionChange(Sender: TObject; User: boolean);
    procedure UpdateFilter(FilterID: Integer);
    procedure AddCell(Aid: integer);
    procedure DelCell(Aid: integer);
  public
    ArrOfFilters: array of TFilter;
    ArrFormEdit : array of TFormEdit;
  end;
  
  procedure MakeForm(FormID: Integer);

  var
    ArrOfForms: array of TTableForm;

implementation

{$R *.lfm}

procedure MakeForm(FormID: Integer);
begin
  if ArrOfForms[FormID] = nil then
  begin
    Application.CreateForm(TTableForm, ArrOfForms[FormID]);
    ArrOfForms[FormID].Tag := FormID;
    ArrOfForms[FormID].Show;
  end
  else ArrOfForms[FormID].ShowOnTop;
end;

{ TTableForm }

procedure TTableForm.RetrieveData;
var
  i: Integer;
  Query, Str: String;
begin
  Query := ArrOfTables[Tag].GetSQL();
  for i := 0 to High(ArrOfFilters) do
  begin
    if i = 0 then Query += ' Where '
    else Query += ' and ';
    Query += GetFilterExpr(i);
  end;

  if SortField.ItemIndex > 0 then begin
    with ArrOfTables[Tag] do begin
      if ArrOfFields[SortField.ItemIndex-1].JoinTable = nil then
        Str := Name
      else
        Str := ArrOfFields[SortField.ItemIndex-1].JoinTable.Name;
        Str += '.' + ArrOfFields[SortField.ItemIndex-1].Order;
      Query += ' Order By ' + Str;
      if DescBox.Checked then Query += ' Desc';
    end;
  end;

  SQLQuery.Close;
  SQLQuery.SQL.Text := Query;
  SQLQuery.Open;

  for i := 0 to High(ArrOfTables[Tag].ArrOfFields) do
  begin
    with DBGrid.Columns.Items[i] do
    begin
      Title.Caption := ArrOfTables[Self.Tag].ArrOfFields[i].Caption;
      Width := ArrOfTables[Self.Tag].ArrOfFields[i].Width;
    end;
  end;
end;

procedure TTableForm.RetrieveClick(Sender: TObject);
begin
  RetrieveData();
end;

procedure TTableForm.FormShow(Sender: TObject);
var
  i: Integer;
  FieldName: String;
begin
  Caption := ArrOfTables[Tag].Caption;
  RetrieveData();
  for i := 0 to High(ArrOfTables[Tag].ArrOfFields) do
  begin
    FieldName := ArrOfTables[Tag].ArrOfFields[i].Caption;
    FilterFields.Items.Add(FieldName);
    FilterConst.Items.Add(ArrOfTables[Tag].GetFieldName(i));
    SortField.Items.Add(FieldName);
  end;
  FilterFields.ItemIndex := 0;
  FilterConst.ItemIndex := 0;
  SortField.ItemIndex := 0;
end;

procedure TTableForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  ArrOfForms[Tag] := nil;
end;

function TTableForm.GetFilterExpr(FilterID: Integer): string;
begin
  with ArrOfFilters[FilterID] do
    Result := ArrOfTables[Tag].GetFieldName(Field)
            + ' ' + FilterOps.Items.Strings[Operation]
            + ' ' + Constant;
end;

procedure TTableForm.MenuAddClick(Sender: TObject);
begin
  AddCell(-1);
end;

procedure TTableForm.MenuDelClick(Sender: TObject);
var
  ID: string;
begin
  if SQLQuery.EOF or (MessageDlgPos('Удалить?', mtWarning, [mbOK,mbCancel], 0,
     Self.Left + 100, Self.Top + 100) = mrCancel) then Exit;

  ID := SQLQuery.FieldByName('ID').AsString;

  SQLQuery.Close;
  SQLQuery.SQL.Text:=Format(' DELETE FROM %s WHERE ID = %s ', [ArrOfTables[Tag].Name,ID]);
  SQLQuery.ExecSQL;

  RetrieveData;
end;

procedure TTableForm.DBGridDblClick(Sender: TObject);
var
  id: integer;
begin
  if SQLQuery.EOF then Exit;
  id := SQLQuery.FieldByName('ID').AsInteger;
  AddCell(id);                                  //станд. ф-я скла вытаскивает
end;                                            //поле по имени

procedure TTableForm.UpdateFilter(FilterID: Integer);
begin
  with ArrOfFilters[FilterID] do begin
    Field := FilterFields.ItemIndex;
    Operation := FilterOps.ItemIndex;
    Constant := FilterConst.Text;
    if (FilterConst.ItemIndex = -1) and
       (ArrOfTables[Tag].ArrOfFields[Field].FieldType = ftString)
    then
      Constant := '''' + Constant + '''';
  end;
  FiltersList.Items.Strings[FilterID] := GetFilterExpr(FilterID);
end;

procedure TTableForm.AddCell(Aid: integer);
var
  i: integer;
begin
  for i := 0 to High(ArrFormEdit) do
      if AId = ArrFormEdit[i].FId then begin
        ArrFormEdit[i].Show;
        Exit;
      end;
  SetLength(ArrFormEdit, Length(ArrFormEdit) + 1);
  ArrFormEdit[High(ArrFormEdit)] := TFormEdit.Create(ArrOfTables[Tag], AId, @DelCell);
  ArrFormEdit[High(ArrFormEdit)].CreateEditField;
  ArrFormEdit[High(ArrFormEdit)].Show;
end;
{после ОК убирает закрытую форму из массива открытых форм и обновляет данные в таблице}
procedure TTableForm.DelCell(Aid: integer);
var
  i, j: integer;
begin
  for i := 0 to High(ArrFormEdit) do begin
    if ArrFormEdit[i].FId = Aid then begin //когда находим среди всех элементов массива ту
      for j:=i+1 to High(ArrFormEdit) do  //которую надо удал., смещаем на позицию те
        ArrFormEdit[j-1]:= ArrFormEdit[j]; //что идут после удаляемой
    end;
  end;
  SetLength(ArrFormEdit,Length(ArrFormEdit) - 1);
  RetrieveData;
end;

procedure TTableForm.AddFilterClick(Sender: TObject);
begin
  SetLength(ArrOfFilters, Length(ArrOfFilters)+1);
  FiltersList.Items.Add('');
  FiltersList.ItemIndex := High(ArrOfFilters);
  UpdateFilter(High(ArrOfFilters));
end;

procedure TTableForm.DeleteFiltersClick(Sender: TObject);
begin
  SetLength(ArrOfFilters, 0);
  FiltersList.Clear();
end;

procedure TTableForm.FilterConstKeyPress(Sender: TObject; var Key: char);
begin
  FilterConst.ItemIndex := -1;
end;

procedure TTableForm.FilterPartChange(Sender: TObject);
begin
  if Length(ArrOfFilters) > 0 then
    UpdateFilter(FiltersList.ItemIndex);
end;

procedure TTableForm.FiltersListSelectionChange(Sender: TObject; User: boolean);
begin
  if User then
    with ArrOfFilters[FiltersList.ItemIndex] do begin
      FilterFields.ItemIndex := Field;
      FilterOps.ItemIndex := Operation;
      FilterConst.Text := Constant;
    end;
end;

initialization

SetLength(ArrOfForms, 9);

end.
