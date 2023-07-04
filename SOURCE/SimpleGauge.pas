unit SimpleGauge;

interface

uses
  Gauges, System.Classes, Vcl.Controls, Forms;

type

  IGauge = interface(IDispatch)
    {$IFDEF VER100}
    procedure IncProgress(IncValue: integer);
    {$ELSE}
    procedure IncProgress(IncValue: integer = 1);
    {$ENDIF}
    procedure Start;
    procedure Finish;
  end;

  TGaugeFactory = class
    class function GetGauge(in_stCaption: TCaption; AMinValue, AMaxValue: integer; ACreate : Boolean = True): IGauge;
  end;

  TSimpleGaugeForm = class(TForm, IGauge)
    Gauge: TGauge;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure Start;
    procedure Finish;
    {$IFDEF VER100}
    procedure IncProgress(IncValue: integer);
    {$ELSE}
    procedure IncProgress(IncValue: integer = 1);
    {$ENDIF}
  public
    constructor Create(AOwner: TForm; ACaption: TCaption; AMinValue, AMaxValue: integer); reintroduce; virtual;
  end;

implementation

{$R *.DFM}
{------------------------------------------------------------------------------}
constructor TSimpleGaugeForm.Create(AOwner: TForm;ACaption: TCaption;AMinValue,AMaxValue: integer);
begin
  inherited Create(AOwner);
  Caption:=ACaption;
  with Gauge do begin
    Progress := AMinValue;
    MinValue := AMinValue;
    if AMaxValue < AMinValue then
       MaxValue := AMinValue
    else
       MaxValue := AMaxValue;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSimpleGaugeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action:=caFree;
end;
{------------------------------------------------------------------------------}
procedure TSimpleGaugeForm.Finish;
begin
  Close;
end;

procedure TSimpleGaugeForm.Start;
begin
  Show;
  Gauge.Progress := Gauge.MinValue;
end;

{ TGaugeFactory }
class function TGaugeFactory.GetGauge(in_stCaption: TCaption; AMinValue, AMaxValue: integer; ACreate : Boolean = True): IGauge;
begin
   if ACreate then
     result := TSimpleGaugeForm.Create(nil, in_stCaption, AMinValue, AMaxValue)
   else result := Nil;
end;

procedure TSimpleGaugeForm.IncProgress(IncValue: integer);
begin
  Gauge.Progress := Gauge.Progress + IncValue;
  Application.ProcessMessages;
end;

end.
