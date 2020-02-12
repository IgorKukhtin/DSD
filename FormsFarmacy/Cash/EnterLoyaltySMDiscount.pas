unit EnterLoyaltySMDiscount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, System.RegularExpressions, Data.DB, Datasnap.DBClient,
  dsdDB, Vcl.ButtonGroup, cxCurrencyEdit;

type
  TEnterLoyaltySMDiscountForm = class(TForm)
    Label1: TLabel;
    pn1: TPanel;
    BuyerCDS: TClientDataSet;
    spSelectObjectBuyer: TdsdStoredProc;
    edMaskName: TcxMaskEdit;
    ButtonGroup1: TButtonGroup;
    ceDiscount: TcxCurrencyEdit;
    procedure ButtonGroup1ButtonClicked(Sender: TObject; Index: Integer);
    procedure ButtonGroup1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FTotalSum, FSummaRemainder : currency;
  public
    { Public declarations }
  end;

function ShowEnterLoyaltySMDiscount(AName : string; ATotalSum, ASummaRemainder : currency; var ADoscount : Currency) : boolean;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, BuyerList;

function ShowEnterLoyaltySMDiscount(AName : string; ATotalSum, ASummaRemainder : currency; var ADoscount : Currency) : boolean;
  var EnterLoyaltySMDiscountForm : TEnterLoyaltySMDiscountForm;
begin
  EnterLoyaltySMDiscountForm := TEnterLoyaltySMDiscountForm.Create(Screen.ActiveControl);
  try
    EnterLoyaltySMDiscountForm.edMaskName.Text := AName;
    EnterLoyaltySMDiscountForm.FTotalSum := ATotalSum;
    EnterLoyaltySMDiscountForm.FSummaRemainder := ASummaRemainder;
    EnterLoyaltySMDiscountForm.ButtonGroup1.Items.Items[0].Caption :=
      EnterLoyaltySMDiscountForm.ButtonGroup1.Items.Items[0].Caption + ' ' + FormatCurr(',0.00', ASummaRemainder);
    if ASummaRemainder <= 0 then EnterLoyaltySMDiscountForm.ButtonGroup1.ItemIndex := 2
    else EnterLoyaltySMDiscountForm.ButtonGroup1.ItemIndex := 0;
    Result := EnterLoyaltySMDiscountForm.ShowModal = mrOk;
    if Result then ADoscount := EnterLoyaltySMDiscountForm.ceDiscount.Value
    else ADoscount := 0;
  finally
    EnterLoyaltySMDiscountForm.Free;
  end;
end;

procedure TEnterLoyaltySMDiscountForm.ButtonGroup1ButtonClicked(Sender: TObject;
  Index: Integer);
begin
  case Index of
    0 : begin
          if FSummaRemainder > 0 then ceDiscount.Value := FSummaRemainder
          else ceDiscount.Value := 0;
          ModalResult := mrOk;
        end;
    1 : begin
          if FSummaRemainder > 0 then
          begin
            if ceDiscount.Value = 0 then ceDiscount.SetFocus
            else if Currency(ceDiscount.Value) > FSummaRemainder then
            begin
              ceDiscount.Value := FSummaRemainder;
              ShowMessage('Сумма недолжна привешать ' + FormatCurr(',0.00', FSummaRemainder));
              ceDiscount.SetFocus;
            end else ModalResult := mrOk;
          end else
          begin
            ceDiscount.Value := 0;
            ModalResult := mrOk;
          end;
        end;
    2 : begin
          ceDiscount.Value := 0;
          ModalResult := mrOk;
        end;
  end;
end;

procedure TEnterLoyaltySMDiscountForm.ButtonGroup1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_RETURN : if Sender = ceDiscount then
                  begin
                    ButtonGroup1.SetFocus;
                    ButtonGroup1ButtonClicked(Sender, 1);
                  end;
      VK_ESCAPE : ModalResult := mrCancel;
    end;

end;

end.
