unit FMX.SimpleGauge;

interface

uses
  FMX.Controls, FMX.Forms, FMX.StdCtrls, System.UITypes,
  System.Classes, FMX.Types, FMX.Controls.Presentation;

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

{$R *.fmx}

constructor TSimpleGaugeForm.Create(AOwner: TForm; ACaption: string; AMinValue, AMaxValue: integer);
begin
  inherited Create(AOwner);
  Caption := ACaption;
  with Gauge do
  begin
    Value := AMinValue;
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
  Gauge.Value := Gauge.Min;
end;

{ TGaugeFactory }
class function TGaugeFactory.GetGauge(in_stCaption: string; AMinValue, AMaxValue: integer): IGauge;
begin
  result := TSimpleGaugeForm.Create(nil, in_stCaption, AMinValue, AMaxValue);
end;

procedure TSimpleGaugeForm.IncProgress(IncValue: integer);
begin
  Gauge.Value := Gauge.Value + IncValue;
  Application.ProcessMessages;
end;

end.
