unit ScheduleForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, types, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, MetaUnit, TableForm, Connect, Clipbrd, Buttons, EditForm;

const
  TextHeight = 15;
  BtnHeight = 30;

type
  TCoord = record
    Col, Row, Item: integer;
  end;

  TFieldsValues = array of string;

  TMyGridItem = array of TFieldsValues;

  TGridElem = record
    GridElem: TMyGridItem;
    AllUsed: boolean;
  end;

  TMyGrid = array of array of TGridElem;

  TAxisElem = array of array [1..2] of string;
  { TSchedule }

  TSchedule = class(TForm)
    BtnDel: TBitBtn;
    BtnChange: TBitBtn;
    BtnAdd: TBitBtn;
    DrawGrid: TDrawGrid;
    HorzLabel: TLabel;
    VertLabel: TLabel;
    ScheduleShow: TButton;
    CheckGroup: TCheckGroup;
    HorComboBox: TComboBox;
    VertComboBox: TComboBox;
    DataSource: TDataSource;
    SQLQuery: TSQLQuery;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnChangeClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure DrawGridDblClick(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure DrawGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DrawGridLoseFocus(Sender: TObject);
    procedure ScheduleShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateGrid;
    procedure ComboBoxChange(Sender: TObject);
  private
    procedure AddValue(var Vert, Hor: integer);
    procedure DrawTriangle(ARect: TRect; ACanvas: TCanvas);
    function GetArray(AField: TMyField): TAxisElem;
    procedure MoveBtn;
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
  MouseCoord, PrevMouseCord: TCoord;
  MousePos: TPoint;

implementation

{$R *.lfm}

{ TSchedule }

function Cord(aCol, aRow, aItem: integer): TCoord;
begin
  Result.Col := aCol;
  Result.Row := aRow;
  Result.Item := aItem;
end;

procedure TSchedule.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Length(ScheduleTable.ArrOfFields) - 1 do
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
  SetLength(Values, Length(ScheduleTable.ArrOfFields));
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

  SetLength(GridData[Hor + 1][Vert + 1].GridElem,
    Length(GridData[Hor + 1][Vert + 1].GridElem) + 1);
  GridData[Hor + 1][Vert + 1].GridElem[High(GridData[Hor + 1][Vert + 1].GridElem)] := Values;
end;

procedure TSchedule.MoveBtn;
var
  ARect: TRect;
begin
  ARect := DrawGrid.CellRect(MouseCoord.Col, MouseCoord.Row);
  BtnChange.Visible := False;
  BtnAdd.Visible := False;
  BtnDel.Visible := False;

  if (MouseCoord.Row <> 0) then
  begin
    BtnAdd.Top := ARect.Bottom + DrawGrid.Top - BtnChange.Height;
    BtnAdd.Left := ARect.Left + 10;
    BtnAdd.Visible := True;
    if (MouseCoord.Item >= 0) then
    begin
      BtnDel.Top := (MouseCoord.Item + 1) * TextHeight * VisibleFieldNum +
        DrawGrid.Top + ARect.Top - BtnDel.Height * 2;
      BtnChange.Top := (MouseCoord.Item + 1) * TextHeight * VisibleFieldNum +
        DrawGrid.Top + ARect.Top - BtnChange.Height;
      BtnDel.Left := ARect.Right - BtnDel.Width;
      BtnChange.Left := ARect.Right - BtnChange.Width;
      BtnChange.Visible := True;
      BtnDel.Visible := True;
    end;
  end;
end;

procedure TSchedule.DrawGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  ACol, ARow, index: integer;
  ARect: TRect;
begin
  DrawGrid.MouseToCell(X, Y, ACol, ARow);
  if (ACol * ARow = 0) or (Length(GridData) = 0) then
  begin
    MouseCoord := Cord(0, 0, 0);
    MoveBtn();
    Exit;
  end;
  ARect := DrawGrid.CellRect(ACol, ARow);
  index := (Y - ARect.Top) div (TextHeight * VisibleFieldNum);
  if (index < Length(GridData[ACol][ARow].GridElem)) and
    ((index + 1) * TextHeight * VisibleFieldNum < ARect.Bottom - ARect.Top) then
  begin
    if (MouseCoord.Col = ACol) and (MouseCoord.Row = ARow) and
      (MouseCoord.Item = index) then
      Exit;
    MouseCoord := Cord(ACol, ARow, index);
    MoveBtn();
  end
  else
  begin
    MouseCoord := Cord(ACol, ARow, -1);
    MoveBtn();
  end;
end;

procedure TSchedule.DrawGridLoseFocus(Sender: TObject);
begin
  MouseCoord := Cord(0, 0, 0);
  MoveBtn();
end;

procedure TSchedule.UpdateGrid;
var
  i, j, Vert, Hor: integer;
begin
  SQLQuery.Close;
  Clipboard.AsText := Select + Order;
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

procedure TSchedule.DrawTriangle(ARect: TRect; ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 1;
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Polygon([Point(ARect.Right - 10, ARect.Bottom),
      Point(ARect.Right, ARect.Bottom - 10),
      Point(ARect.Right, ARect.Bottom)]);
  end;
end;

procedure TSchedule.DrawGridDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
var
  i, j, y: integer;
  Str: string;
begin
  if (aCol + aRow = 0) or (Length(GridData) = 0) then Exit;
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
    Canvas.Font.Size := TextHeight;
    for j := 0 to Length(ScheduleTable.ArrOfFields) - 1 do
      if (CheckGroup.Checked[j]) and (CheckGroup.CheckEnabled[j]) then
      begin
        Str := Format('%s : %s ', [CheckGroup.Items[j],
                               GridData[aCol][aRow].GridElem[i][j]]);
        TDrawGrid(Sender).Canvas.TextOut(aRect.Left + 6, aRect.Top + y, Str);
        y += TextHeight;
      end;
    with DrawGrid.Canvas do
    begin
      Brush.Style := bsClear;
      Pen.Style := psDot;
      Pen.Color := clBlack;
      Line(aRect.Left, aRect.Top + y, aRect.Right, aRect.Top + y);
    end;
    if VisibleFieldNum * TextHeight + y + BtnHeight > DrawGrid.RowHeights[aRow] then
      Break;
  end;
  if High(GridData[aCol][aRow].GridElem) > i then
    DrawTriangle(aRect, DrawGrid.Canvas);
end;

procedure TSchedule.DrawGridDblClick(Sender: TObject);
var
  Col, Row: integer;
begin
  Col := MouseCoord.Col;
  Row := MouseCoord.Row;
  if (Col * Row <> 0) and (Length(GridData[Col][Row].GridElem) > 0) then
    if TextHeight * Length(GridData[Col][Row].GridElem) * VisibleFieldNum +
       BtnHeight <> DrawGrid.RowHeights[Row] then
      DrawGrid.RowHeights[Row] := TextHeight * Length(GridData[Col][Row].GridElem)
                                  * VisibleFieldNum + BtnHeight
    else
      DrawGrid.RowHeights[Row] := TextHeight * VisibleFieldNum + BtnHeight;
  DrawGrid.Invalidate;
end;

procedure TSchedule.BtnAddClick(Sender: TObject);
begin
  AddCell(-1, 8, @UpdateGrid);
end;

procedure TSchedule.BtnChangeClick(Sender: TObject);
begin
  AddCell(StrToInt(GridData[MouseCoord.Col][MouseCoord.Row].GridElem
    [MouseCoord.Item][0]), 8, @UpdateGrid);
end;

procedure TSchedule.BtnDelClick(Sender: TObject);
begin
  if (MessageDlgPos('Удалить?', mtWarning, [mbOK, mbCancel], 0,
    Self.Left + 100, Self.Top + 100) = mrCancel) then
    Exit;

  SQLQuery.Close;
  SQLQuery.SQL.Text := Format(' DELETE FROM %s WHERE ID = %s ',
    [ScheduleTable.Name, GridData[MouseCoord.Col]
    [MouseCoord.Row].GridElem[MouseCoord.Item][0]]);
  SQLQuery.ExecSQL;

  UpdateGrid;
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

  DrawGrid.DefaultRowHeight := TextHeight * VisibleFieldNum + BtnHeight;
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
