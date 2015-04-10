unit FilterFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TFilterFrame }

  TFilterFrame = class(TFrame)
    Field: TComboBox;
    Operation: TComboBox;
    Constant: TComboBox;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

