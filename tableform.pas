unit TableForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, ExtCtrls, StdCtrls, MetaUnit;

type

  TFilter = record
    Field : Integer;
    Operation : Integer;
    Constant : String;
  end;

  { TTableForm }

  TTableForm = class(TForm)
    AddFilter: TButton;
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
    DescTBox: TToggleBox;
    function GetFilterExpr(FilterID: Integer): string;
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
  public
    MassOfFilters: array of TFilter;
  end;
  
  procedure MakeForm(FormID: Integer);

var
  MassOfForms: array of TTableForm;


implementation

{$R *.lfm}

procedure MakeForm(FormID: Integer);
begin
  if MassOfForms[FormID] = nil then
  begin
    Application.CreateForm(TTableForm, MassOfForms[FormID]);
    MassOfForms[FormID].Tag := FormID;
    MassOfForms[FormID].Show;
  end
  else MassOfForms[FormID].ShowOnTop;
end;

{ TTableForm }

procedure TTableForm.RetrieveData;
var
  i: Integer;
  Query: String;
begin
  Query := MassOfTables[Tag].GetSQL();

  for i := 0 to High(MassOfFilters) do
  begin
    if i = 0 then Query += ' Where '
      else Query += ' and ';
    Query += GetFilterExpr(i);
  end;

  if SortField.ItemIndex > 0 then begin
    Query += ' Order By ' + MassOfTables[Tag].GetFieldName(SortField.ItemIndex-1);
    if DescTBox.Checked then Query += ' Desc';
  end;

  SQLQuery.Close;
  SQLQuery.SQL.Text := Query;
  SQLQuery.Open;

  for i := 0 to High(MassOfTables[Tag].MassOfFields) do
  begin
    with DBGrid.Columns.Items[i] do
      begin
        Title.Caption := MassOfTables[Self.Tag].MassOfFields[i].Caption;
        Width := MassOfTables[Self.Tag].MassOfFields[i].Width;
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
  Caption := MassOfTables[Tag].Caption;
  RetrieveData();

  for i := 0 to High(MassOfTables[Tag].MassOfFields) do
  begin
    FieldName := MassOfTables[Tag].MassOfFields[i].Caption;
    FilterFields.Items.Add(FieldName);
    FilterConst.Items.Add(MassOfTables[Tag].GetFieldName(i));
    SortField.Items.Add(FieldName);
  end;

  FilterFields.ItemIndex := 0;
  FilterConst.ItemIndex := 0;
  SortField.ItemIndex := 0;
end;

procedure TTableForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  MassOfForms[Tag] := nil;
end;

function TTableForm.GetFilterExpr(FilterID: Integer): string;
begin
  with MassOfFilters[FilterID] do
    Result := MassOfTables[Tag].GetFieldName(Field)
            + ' ' + FilterOps.Items.Strings[Operation]
            + ' ' + Constant;
end;

procedure TTableForm.UpdateFilter(FilterID: Integer);
begin
  with MassOfFilters[FilterID] do begin
    Field := FilterFields.ItemIndex;
    Operation := FilterOps.ItemIndex;
    Constant := FilterConst.Text;

    if (FilterConst.ItemIndex = -1) and
       (MassOfTables[Tag].MassOfFields[Field].FieldType = ftString) then
         Constant := '''' + Constant + '''';
  end;
  
  FiltersList.Items.Strings[FilterID] := GetFilterExpr(FilterID);
end;

procedure TTableForm.AddFilterClick(Sender: TObject);
begin
  SetLength(MassOfFilters, Length(MassOfFilters)+1);
  FiltersList.Items.Add('');
  FiltersList.ItemIndex := High(MassOfFilters);
  UpdateFilter(High(MassOfFilters));
end;

procedure TTableForm.DeleteFiltersClick(Sender: TObject);
begin
  SetLength(MassOfFilters, 0);
  FiltersList.Clear();
end;

procedure TTableForm.FilterConstKeyPress(Sender: TObject; var Key: char);
begin
  FilterConst.ItemIndex := -1;
end;

procedure TTableForm.FilterPartChange(Sender: TObject);
begin
  if Length(MassOfFilters) > 0 then
    UpdateFilter(FiltersList.ItemIndex);
end;

procedure TTableForm.FiltersListSelectionChange(Sender: TObject; User: boolean);
begin
  if User then
    with MassOfFilters[FiltersList.ItemIndex] do begin
      FilterFields.ItemIndex := Field;
      FilterOps.ItemIndex := Operation;
      FilterConst.Text := Constant;
    end;
end;

initialization

SetLength(MassOfForms, 9);

end.
