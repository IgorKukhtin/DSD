unit CashCloseDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, CashInterface, AncestorBase, dsdDB;

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
    FSummaTotal: Real;
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  CashCloseDialogForm: TCashCloseDialogForm;
function CashCloseDialogExecute(ASummaTotal: Real; Var ASalerCash: Real; var APaidType: TPaidType):Boolean;

implementation

{$R *.dfm}

uses DataModul;

function CashCloseDialogExecute(ASummaTotal: Real; Var ASalerCash: Real; var APaidType: TPaidType):Boolean;
Begin
  With TCashCloseDialogForm.Create(nil) do
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
    finally
      free;
    end;
  End;
End;

procedure TCashCloseDialogForm.edSalerCashPropertiesChange(Sender: TObject);
begin
  bbOk.Enabled := ((edSalerCash.Value - FSummaTotal)>=0) or
    (rgPaidType.ItemIndex = 1);
  if FSummaTotal <= edSalerCash.Value then
    lblSdacha.Caption := FormatCurr('0.00',edSalerCash.Value - FSummaTotal)
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
