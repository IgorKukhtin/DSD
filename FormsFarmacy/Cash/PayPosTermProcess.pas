unit PayPosTermProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, CashInterface, AncestorBase, dsdDB, dxSkinsCore,
  dxSkinsDefaultPainters, PosInterface, Vcl.ComCtrls, cxProgressBar;

type

  TPosTermThread  = class(TThread)
  private
    FPosTerm: IPos;
    FSalerCash : currency;
    FPeyResult: Boolean;
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
  end;


  TPayPosTermProcessForm = class(TAncestorDialogForm)
    edMsgDescription: TEdit;
    cxProgressBar1: TcxProgressBar;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPosTermThread : TPosTermThread;
  public
    { Public declarations }
    procedure EndPayPosTerm;
  end;

var PayPosTermProcessForm : TPayPosTermProcessForm;

function PayPosTerminal(PosTerm: IPos;  ASalerCash : currency) : Boolean;

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

  if FSalerCash > 0 then FPosTerm.Payment(FSalerCash);

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

  {TPayPosTermProcessForm}

procedure TPayPosTermProcessForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FPosTermThread) and not FPosTermThread.Finished then
  begin
    Action := caNone;
    ModalResult := 0;
    if MessageDlg('Прервать оплату документа?',mtConfirmation,mbYesNo,0)<>mrYes then FPosTermThread.FPosTerm.Cancel;
  end else
  begin
    if Assigned(FPosTermThread) then FreeAndNil(FPosTermThread);
  end;
end;

procedure TPayPosTermProcessForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FPosTermThread) then FPosTermThread.Free;
end;

procedure TPayPosTermProcessForm.FormShow(Sender: TObject);
begin
  if Assigned(FPosTermThread) then FPosTermThread.Start;
end;

procedure TPayPosTermProcessForm.EndPayPosTerm;
begin
  if Assigned(FPosTermThread) and FPosTermThread.FPeyResult then ModalResult := mrOk
  else ModalResult := mrCancel;
end;


function PayPosTerminal(PosTerm: IPos;  ASalerCash : currency) : Boolean;
Begin
  if NOT assigned(PayPosTermProcessForm) then
    PayPosTermProcessForm := TPayPosTermProcessForm.Create(Application);
  With PayPosTermProcessForm do
  try
    try
      FPosTermThread := TPosTermThread.Create;
      FPosTermThread.FPosTerm := PosTerm;
      FPosTermThread.FSalerCash := ASalerCash;
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
