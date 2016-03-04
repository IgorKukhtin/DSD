unit CashCloseDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, CashInterface, AncestorBase, dsdDB, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TCashCloseDialogForm = class(TAncestorDialogForm)
    cxGroupBox1: TcxGroupBox;
    edSalerCash: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    lblTotalSumma: TcxLabel;
    lblSdacha: TcxLabel;
    rgPaidType: TcxRadioGroup;
    procedure edSalerCashPropertiesChange(Sender: TObject);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSummaTotal: Currency;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CashCloseDialogForm: TCashCloseDialogForm;
function CashCloseDialogExecute(ASummaTotal: Currency; Var ASalerCash: Currency; var APaidType: TPaidType):Boolean;

implementation

{$R *.dfm}

uses DataModul;

function CashCloseDialogExecute(ASummaTotal: Currency; Var ASalerCash: Currency; var APaidType: TPaidType):Boolean;
Begin
  if NOT assigned(CashCloseDialogForm) then
    CashCloseDialogForm := TCashCloseDialogForm.Create(Application);
  With CashCloseDialogForm do
  Begin
    try
      FSummaTotal := ASummaTotal;
      lblTotalSumma.Caption := FormatCurr('0.00',ASummaTotal);
      edSalerCash.Value := ASummaTotal;
      rgPaidType.ItemIndex := Integer(APaidType);
      ActiveControl := edSalerCash;
      edSalerCash.SelectAll;
      Result := ShowModal = mrOK;
      if Result then
      Begin
        ASalerCash := edSalerCash.Value;
        APaidType := TPaidType(rgPaidType.ItemIndex);
      End;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  End;
End;

procedure TCashCloseDialogForm.edSalerCashPropertiesChange(Sender: TObject);
var
  tmpVal: Currency;
begin
  tmpVal := edSalerCash.Value;
  bbOk.Enabled := ((tmpVal - FSummaTotal)>=0) or
    (rgPaidType.ItemIndex = 1);
  if FSummaTotal <= tmpVal then
    lblSdacha.Caption := FormatCurr('0.00',tmpVal - FSummaTotal)
  else
    lblSdacha.Caption := 'нет';
end;

procedure TCashCloseDialogForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DIVIDE then
    rgPaidType.ItemIndex := 0
  else
  if Key = VK_MULTIPLY then
    rgPaidType.ItemIndex := 1;
end;

end.
