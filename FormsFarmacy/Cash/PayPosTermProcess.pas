unit PayPosTermProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, dsdDB, dxSkinsCore, TypInfo,
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

procedure Add_PosLog(AMessage: String);
  var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_PosJSON.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_PosJSON.log')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F, DateTimeToStr(Now) + ': ' + AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;
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
  Add_PosLog('+++++++++++ Старт потока');

  while not Terminated do
  begin
    Sleep(500);

    if FPosTerm.ProcessType = pptThread then
    begin

      if FPosTerm.ProcessState = ppsWaiting then Continue;
      Add_PosLog('--> ' + GetEnumName(TypeInfo(TPosProcessState), Ord(FPosTerm.ProcessState)));
      if FPosTerm.ProcessState = ppsError then Break;

      if FPosTerm.ProcessState = ppsUndefined then
      begin
        FPosTerm.CheckConnection;
      end else if FPosTerm.ProcessState = ppsOkConnection then
      begin
        if FSalerCash <= 0 then
        begin
          Break;
        end else
        if FRefund then
        begin
          FPosTerm.Refund(FSalerCash);
        end else
        begin
          FPosTerm.Payment(FSalerCash);
        end;
      end else if (FPosTerm.ProcessState = ppsOkPayment) or (FPosTerm.ProcessState = ppsOkRefund) then
      begin
        FPeyResult := True;
        Break;
      end else Break;
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
      Break;
    end;
  end;

  Add_PosLog('-------- Финиш потока');

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
