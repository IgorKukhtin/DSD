unit SimpleGauge;

interface

uses
  {$IFDEF MSWINDOWS}
  VCL.Controls, VCL.Forms, Vcl.ComCtrls,
  {$ELSE}
  FMX.Controls, FMX.Forms, FMX.StdCtrls, System.UITypes,
  {$ENDIF}
  System.Classes;

type

  IGauge = interface(IDispatch)
    procedure IncProgress(IncValue: integer = 1);
    procedure Start;
    procedure Finish;
  end;

  TGaugeFactory = class
    class function GetGauge(in_stCaption: string; AMinValue, AMaxValue: integer): IGauge;
  end;

  TSimpleGaugeForm = class(TForm, IGauge)
    Gauge: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure Start;
    procedure Finish;
    procedure IncProgress(IncValue: integer = 1);
  public
    constructor Create(AOwner: TForm; ACaption: string; AMinValue, AMaxValue: integer); reintroduce; virtual;
  end;

implementation

{$R *.DFM}

constructor TSimpleGaugeForm.Create(AOwner: TForm; ACaption: string; AMinValue, AMaxValue: integer);
begin
  inherited Create(AOwner);
  Caption := ACaption;
  with Gauge do
  begin
    {$IFDEF MSWINDOWS}
    Position := AMinValue;
    {$ELSE}
    Value := AMinValue;
    {$ENDIF}
    Min := AMinValue;
    if AMaxValue < AMinValue then
      Max := AMinValue
    else
      Max := AMaxValue;
  end;
end;

procedure TSimpleGaugeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := TCloseAction.caFree;
end;

procedure TSimpleGaugeForm.Finish;
begin
  Close;
end;

procedure TSimpleGaugeForm.Start;
begin
  Show;
  {$IFDEF MSWINDOWS}
  Gauge.Position := Gauge.Min;
  {$ELSE}
  Gauge.Value := Gauge.Min;
  {$ENDIF}
end;

{ TGaugeFactory }
class function TGaugeFactory.GetGauge(in_stCaption: string; AMinValue, AMaxValue: integer): IGauge;
begin
  result := TSimpleGaugeForm.Create(nil, in_stCaption, AMinValue, AMaxValue);
end;

procedure TSimpleGaugeForm.IncProgress(IncValue: integer);
begin
  {$IFDEF MSWINDOWS}
  Gauge.Position := Gauge.Position + IncValue;
  {$ELSE}
  Gauge.Value := Gauge.Value + IncValue;
  {$ENDIF}
  Application.ProcessMessages;
end;

end.
