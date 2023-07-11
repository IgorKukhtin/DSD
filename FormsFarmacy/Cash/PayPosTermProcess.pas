unit PayPosTermProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, dsdDB, dxSkinsCore,
  dxSkinsDefaultPainters, PosInterface, Vcl.ComCtrls, cxProgressBar;

type

  TPosTermThread  = class(TThread)
  private
    FPosTerm: IPos;
    FSalerCash : currency;
    FPeyResult: Boolean;
    FRefund : boolean;
    FShowInfo : TThreadProcedure;
    FEndPayPosTerm : TThreadProcedure;
    FMsgDescription : string;
    FStepThread: Integer;

    procedure Execute; override;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure MsgDescriptionProc(AMsgDescription : string);
    procedure UpdateMsgDescription;
    function GetLastPosError : string;
  end;


  TPayPosTermProcessForm = class(TForm)
    edMsgDescription: TEdit;
    cxProgressBar1: TcxProgressBar;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPosTermThread : TPosTermThread;
  public
    { Public declarations }
    procedure EndPayPosTerm;
  end;

var PayPosTermProcessForm : TPayPosTermProcessForm;

function PayPosTerminal(PosTerm: IPos;  ASalerCash : currency; ARefund : boolean = False) : Boolean;

implementation

{$R *.dfm}

  {TPosTermThread}

constructor TPosTermThread.Create;
begin
  inherited Create(True);
  FPosTerm := Nil;
  FSalerCash := 0;
  FPeyResult := False;
  FMsgDescription := '';
end;

destructor TPosTermThread.Destroy;
begin
  inherited Destroy;
end;

procedure TPosTermThread.Execute;
begin
  if Terminated then Exit;
  if not Assigned(FPosTerm) then Exit;
  FStepThread := 0;

  while not Terminated do
  begin
    Sleep(500);

    if FPosTerm.ProcessType = pptThread then
    begin

      if FPosTerm.ProcessState = ppsWaiting then Continue;
      if FPosTerm.ProcessState = ppsError then Break;

      if FStepThread = 0 then
      begin
        FPosTerm.CheckConnection;
        Inc(FStepThread);
      end else if FStepThread = 1 then
      begin
        FPosTerm.CheckConnection;
        Inc(FStepThread);
      end else if FStepThread = 2 then Break;

    end else
    begin
      if FPosTerm.CheckConnection then
      begin
        if (FSalerCash > 0) then
        begin
          if FRefund then FPosTerm.Refund(FSalerCash)
          else FPosTerm.Payment(FSalerCash);
        end;
      end;
    end;
  end;

  if Assigned(FEndPayPosTerm) then FEndPayPosTerm;
end;

procedure TPosTermThread.MsgDescriptionProc(AMsgDescription : string);
begin
  if FMsgDescription <> AMsgDescription then
  begin
    FMsgDescription := AMsgDescription;
    Synchronize(UpdateMsgDescription);
  end;
end;

procedure TPosTermThread.UpdateMsgDescription;
begin
  PayPosTermProcessForm.edMsgDescription.Text := FMsgDescription;
end;

function TPosTermThread.GetLastPosError : string;
begin
  if Assigned(FPosTerm) then Result := FPosTerm.LastPosError;
end;


  {TPayPosTermProcessForm}

procedure TPayPosTermProcessForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FPosTermThread) and not FPosTermThread.Finished then
  begin
    if MessageDlg('Прервать оплату документа?',mtConfirmation,mbYesNo,0) <> mrYes then
    begin
      Action := caNone;
      ModalResult := 0;
      Exit;
    end else FPosTermThread.FPosTerm.Cancel;
  end;

  if Assigned(FPosTermThread) then
  begin
    if FPosTermThread.GetLastPosError <> '' then ShowMessage(FPosTermThread.GetLastPosError);
    if not FPosTermThread.Finished then FPosTermThread.Terminate;
    FreeAndNil(FPosTermThread);
  end;
  Timer.Enabled := False;
end;

procedure TPayPosTermProcessForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FPosTermThread) then FPosTermThread.Free;
end;

procedure TPayPosTermProcessForm.FormShow(Sender: TObject);
begin
  if Assigned(FPosTermThread) then FPosTermThread.Start;
  Timer.Enabled := True;
end;

procedure TPayPosTermProcessForm.TimerTimer(Sender: TObject);
begin
  if Assigned(FPosTermThread) then
  begin
    if FPosTermThread.Finished then Close;
  end else Close;
end;

procedure TPayPosTermProcessForm.EndPayPosTerm;
begin
  if Assigned(FPosTermThread) and FPosTermThread.FPeyResult then ModalResult := mrOk
  else ModalResult := mrCancel;
end;

function PayPosTerminal(PosTerm: IPos;  ASalerCash : currency; ARefund : boolean = False) : Boolean;
Begin
  if NOT assigned(PayPosTermProcessForm) then
    PayPosTermProcessForm := TPayPosTermProcessForm.Create(Application);
  With PayPosTermProcessForm do
  try
    edMsgDescription.Text := 'Подключение к терминалу';
    try
      FPosTermThread := TPosTermThread.Create;
      FPosTermThread.FPosTerm := PosTerm;
      FPosTermThread.FSalerCash := ASalerCash;
      FPosTermThread.FRefund := ARefund;
      FPosTermThread.FEndPayPosTerm := EndPayPosTerm;
      PosTerm.OnMsgDescriptionProc := FPosTermThread.MsgDescriptionProc;

      Result := ShowModal = mrOK;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  finally
    PosTerm.OnMsgDescriptionProc := Nil;
  end;
End;

end.
