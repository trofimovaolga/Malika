unit TableForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DBCtrls, ExtCtrls, StdCtrls, Menus, MetaUnit, EditForm, Clipbrd;

type

  TFilter = record
    Field: integer;
    Operation: integer;
    Constant: string;
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
    function GetFilterExpr(FilterID: integer): string;
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
    procedure UpdateFilter(FilterID: integer);
  public
    ArrOfFilters: array of TFilter;
  end;

procedure MakeForm(FormID: integer);

var
  ArrOfForms: array of TTableForm;

implementation

{$R *.lfm}

procedure MakeForm(FormID: integer);
begin
  if ArrOfForms[FormID] = nil then
  begin
    Application.CreateForm(TTableForm, ArrOfForms[FormID]);
    ArrOfForms[FormID].Tag := FormID;
    ArrOfForms[FormID].Show;
  end
  else
    ArrOfForms[FormID].ShowOnTop;
end;

{ TTableForm }

procedure TTableForm.RetrieveData;
var
  i: integer;
  Query, Str: string;
begin
  Query := ArrOfTables[Tag].GetSQL();
  for i := 0 to High(ArrOfFilters) do
  begin
    if i = 0 then
      Query += ' Where '
    else
      Query += ' and ';
    Query += GetFilterExpr(i);
  end;

  if SortField.ItemIndex > 0 then
  begin
    with ArrOfTables[Tag] do
    begin
      if ArrOfFields[SortField.ItemIndex - 1].JoinTable = nil then
        Str := ArrOfFields[SortField.ItemIndex - 1].Name
      else
      begin
        Str := ArrOfFields[SortField.ItemIndex - 1].JoinTable.Name;
        Str += '.' + ArrOfFields[SortField.ItemIndex - 1].Order;
      end;
      Query += ' Order By ' + Str;
      if DescBox.Checked then
        Query += ' Desc';
    end;
  end;

  SQLQuery.Close;
  Clipboard.AsText := Query;
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
  i: integer;
  FieldName: string;
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

function TTableForm.GetFilterExpr(FilterID: integer): string;
begin
  with ArrOfFilters[FilterID] do
    Result := ArrOfTables[Tag].GetFieldName(Field) + ' ' +
      FilterOps.Items.Strings[Operation] + ' ' + Constant;
end;

procedure TTableForm.MenuAddClick(Sender: TObject);
begin
  AddCell(-1, Tag, @RetrieveData);
end;

procedure TTableForm.MenuDelClick(Sender: TObject);
var
  ID: string;
begin
  if SQLQuery.EOF or (MessageDlgPos('Удалить?', mtWarning, [mbOK, mbCancel],
    0, Self.Left + 100, Self.Top + 100) = mrCancel) then
    Exit;

  ID := SQLQuery.FieldByName('ID').AsString;

  SQLQuery.Close;
  SQLQuery.SQL.Text := Format(' DELETE FROM %s WHERE ID = %s ',
    [ArrOfTables[Tag].Name, ID]);
  SQLQuery.ExecSQL;

  RetrieveData;
end;

procedure TTableForm.DBGridDblClick(Sender: TObject);
var
  id: integer;
begin
  if SQLQuery.EOF then
    Exit;
  id := SQLQuery.FieldByName('ID').AsInteger;   //станд. ф-я скла вытаскивает
  AddCell(id, Tag, @RetrieveData);              //поле по имени

end;

procedure TTableForm.UpdateFilter(FilterID: integer);
begin
  with ArrOfFilters[FilterID] do
  begin
    Field := FilterFields.ItemIndex;
    Operation := FilterOps.ItemIndex;
    Constant := FilterConst.Text;
    if (FilterConst.ItemIndex = -1) and
      (ArrOfTables[Tag].ArrOfFields[Field].FieldType = ftString) then
      Constant := '''' + Constant + '''';
  end;
  FiltersList.Items.Strings[FilterID] := GetFilterExpr(FilterID);
end;

procedure TTableForm.AddFilterClick(Sender: TObject);
begin
  SetLength(ArrOfFilters, Length(ArrOfFilters) + 1);
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
    with ArrOfFilters[FiltersList.ItemIndex] do
    begin
      FilterFields.ItemIndex := Field;
      FilterOps.ItemIndex := Operation;
      FilterConst.Text := Constant;
    end;
end;

initialization
  SetLength(ArrOfForms, 9);

end.
