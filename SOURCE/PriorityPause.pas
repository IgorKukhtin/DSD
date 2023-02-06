unit PriorityPause;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.Imaging.GIFImg, cxImage, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, cxMemo, Vcl.ActnList, cxCurrencyEdit,
  cxProgressBar;

type
  TPriorityPauseForm = class(TForm)
    cxButton: TcxButton;
    cxMemo: TcxMemo;
    ActionList1: TActionList;
    actClose: TAction;
    Timer: TTimer;
    cxCurrencyEdit: TcxCurrencyEdit;
    cxProgressBar: TcxProgressBar;
    procedure FormShow(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FProcName : String;
    FSecond_pause : Integer;
  public
    { Public declarations }
    property Second_pause : Integer read FSecond_pause write FSecond_pause;
    property ProcName : String read FProcName write FProcName;
  end;

implementation

uses Storage, CommonData;

{$R *.dfm}

procedure TPriorityPauseForm.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TPriorityPauseForm.FormShow(Sender: TObject);
begin
//  GIFImageDefaultAnimate := True;
//  Image.Picture.LoadFromFile('c:\Users\Oleg\Downloads\ZZ5H.gif');
  cxProgressBar.Properties.Max := FSecond_pause;
  cxProgressBar.Position := FSecond_pause;
  cxCurrencyEdit.Value := FSecond_pause;
  Timer.Enabled := True;
end;

procedure TPriorityPauseForm.TimerTimer(Sender: TObject);
  var cMessage_pause : string;
begin
  Timer.Enabled := False;
  try
    Dec(FSecond_pause);
    cxProgressBar.Position := FSecond_pause;
    cxCurrencyEdit.Value := FSecond_pause;
    if FSecond_pause <= 0 then
    begin
      TStorageFactory.GetStorage.LoadReportPriorityState(FProcName, FSecond_pause, cMessage_pause, gc_User.Session);
      cxMemo.Text := cMessage_pause;
      cxProgressBar.Properties.Max := FSecond_pause;
      cxProgressBar.Position := FSecond_pause;
      cxCurrencyEdit.Value := FSecond_pause;
      if FSecond_pause <= 0 then ModalResult := mrOk;
    end;
  finally
    Timer.Enabled := ModalResult = mrNone;
  end;
end;

end.
