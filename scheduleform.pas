unit ScheduleForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, types, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, MetaUnit, TableForm, Connect, Clipbrd;

type
  TFieldsValues = array [0..ScheduleFildsNum + 1] of string;

  TMyGridItem = array of TFieldsValues;

  TGridElem = record
    GridElem: TMyGridItem;
    AllUsed: boolean;
  end;

  TMyGrid = array of array of TGridElem;

  TAxisElem = array of array [1..2] of string;
  { TSchedule }

  TSchedule = class(TForm)
    ScheduleShow: TButton;
    CheckGroup: TCheckGroup;
    HorComboBox: TComboBox;
    VertComboBox: TComboBox;
    DataSource: TDataSource;
    DrawGrid: TDrawGrid;
    SQLQuery: TSQLQuery;
    procedure DrawGridDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure ScheduleShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateGrid;
    procedure ComboBoxChange(Sender: TObject);
  private
    procedure AddValue(var Vert, Hor: integer);
    function GetArray(AField: TMyField): TAxisElem;
    { private declarations }
  public
    { public declarations }
  end;

var
  Select, Order: string;
  Schedule: TSchedule;
  HorFieldsValues, VertFieldsValues: TAxisElem;
  HorComboBoxIndex, VertComboBoxIndex, VisibleFieldNum: integer;
  GridData: TMyGrid;

implementation

{$R *.lfm}

{ TSchedule }

procedure TSchedule.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ScheduleFildsNum - 1 do
  begin
    CheckGroup.Items.Add(ScheduleTable.ArrOfFields[i].Caption);
    CheckGroup.Checked[i] := True;
    if i = 0 then
      Continue;
    HorComboBox.Items.Add(ScheduleTable.ArrOfFields[i].Caption);
    VertComboBox.Items.Add(ScheduleTable.ArrOfFields[i].Caption);
  end;
  HorComboBox.ItemIndex := 0;
  VertComboBox.ItemIndex := 1;
  ComboBoxChange(VertComboBox);

  Select := ScheduleTable.GetSQL();
end;

procedure TSchedule.AddValue(var Vert, Hor: integer);
var
  FieldName: string;
  Values: TFieldsValues;
  i: integer;
begin
  for i := 0 to High(ScheduleTable.ArrOfFields) do
  begin
    FieldName := ScheduleTable.ArrOfFields[i].Name;
    Values[i] := SQLQuery.FieldByName(FieldName).AsString;
  end;

  while (HorFieldsValues[Hor, 1] <> Values[HorComboBoxIndex]) or
    (VertFieldsValues[Vert, 1] <> Values[VertComboBoxIndex]) do
  begin
    Inc(Vert);
    if Vert > High(VertFieldsValues) then
    begin
      Vert := 0;
      Inc(Hor);
    end;
  end;

  SetLength(GridData[Hor+1][Vert+1].GridElem, Length(GridData[Hor+1][Vert+1].GridElem)+1);
  GridData[Hor+1][Vert+1].GridElem[High(GridData[Hor+1][Vert+1].GridElem)]:= Values;
end;

procedure TSchedule.UpdateGrid;
var
  i, j, Vert, Hor: integer;
begin
  SQLQuery.Close;
  Clipboard.AsText:=Select + Order;
  SQLQuery.SQL.Text := Select + Order;
  SQLQuery.Open;

  Vert := 0;
  Hor := 0;
  for i := 0 to High(GridData) do
    for j := 0 to High(GridData[i]) do
      SetLength(GridData[i][j].GridElem, 0);
  while not SQLQuery.EOF do
  begin
    AddValue(Vert, Hor);
    SQLQuery.Next;
  end;

  DrawGrid.Invalidate;
end;


procedure TSchedule.DrawGridDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
var
  i, j, y: integer;
  Str: string;
begin
  if (aCol + aRow = 0) or (Length(GridData) = 0) then
    Exit;
  if (aRow = 0) then
  begin
    TDrawGrid(Sender).Canvas.TextOut(aRect.Left, aRect.Top,
      HorFieldsValues[aCol - 1, 1]);
    Exit;
  end;
  if (aCol = 0) then
  begin
    TDrawGrid(Sender).Canvas.TextOut(aRect.Left, aRect.Top,
      VertFieldsValues[aRow - 1, 1]);
    Exit;
  end;

  y := 0;
  for i := 0 to High(GridData[aCol][aRow].GridElem) do
  begin
    for j := 0 to ScheduleFildsNum - 1 do
      if (CheckGroup.Checked[j]) and (CheckGroup.CheckEnabled[j]) then
      begin
        Str := Format('%s : %s ', [CheckGroup.Items[j],
          GridData[aCol][aRow].GridElem[i][j]]);
        TDrawGrid(Sender).Canvas.TextOut(aRect.Left + 6, aRect.Top + y, Str);
        y += 16;
      end;
    DrawGrid.Canvas.Brush.Style := bsClear;
    DrawGrid.Canvas.Pen.Style := psDot;
    DrawGrid.Canvas.Pen.Color := clBlack;
    DrawGrid.Canvas.Line(aRect.Left, aRect.Top + y, aRect.Right, aRect.Top + y);
  end;
end;

procedure TSchedule.ComboBoxChange(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(ScheduleTable.ArrOfFields) do
    CheckGroup.CheckEnabled[i] := True;
  CheckGroup.CheckEnabled[HorComboBox.ItemIndex + 1] := False;
  CheckGroup.CheckEnabled[VertComboBox.ItemIndex + 1] := False;
end;

function TSchedule.GetArray(AField: TMyField): TAxisElem;
begin
  SQLQuery.Close;
  SQLQuery.SQL.Text := Format('Select * from %s order by %s asc  ',
    [AField.JoinTable.Name, AField.Order]);
  SQLQuery.Open;

  while not SQLQuery.EOF do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result), 1] := SQLQuery.FieldByName(AField.Name).AsString;
    Result[High(Result), 2] := SQLQuery.FieldByName('ID').AsString;
    SQLQuery.Next;
  end;
end;

procedure TSchedule.ScheduleShowClick(Sender: TObject);
var
  HorField, VertField: TMyField;
  i: integer;
begin
  HorComboBoxIndex := HorComboBox.ItemIndex + 1;
  VertComboBoxIndex := VertComboBox.ItemIndex + 1;
  HorField := ScheduleTable.ArrOfFields[HorComboBoxIndex];
  VertField := ScheduleTable.ArrOfFields[VertComboBoxIndex];

  VisibleFieldNum := 0;
  for i := 0 to High(ScheduleTable.ArrOfFields) do
    if (CheckGroup.Checked[i]) and (CheckGroup.CheckEnabled[i]) then
      Inc(VisibleFieldNum);

  HorFieldsValues := GetArray(HorField);
  VertFieldsValues := GetArray(VertField);

  DrawGrid.ColCount := Length(HorFieldsValues) + 1;
  DrawGrid.RowCount := Length(VertFieldsValues) + 1;
  DrawGrid.ColWidths[0] := VertField.Width;
  DrawGrid.RowHeights[0] := 20;

  SetLength(GridData, 0);
  SetLength(GridData, Length(HorFieldsValues) + 1);
  for i := 0 to High(GridData) do
    SetLength(GridData[i], Length(VertFieldsValues) + 1);

  Order := Format(' order by %s.%s asc, %s.%s asc ;',
    [HorField.JoinTable.Name, HorField.Order, VertField.JoinTable.Name,
    VertField.Order]);

  UpdateGrid;
end;

end.
