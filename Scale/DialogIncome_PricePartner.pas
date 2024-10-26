unit DialogIncome_PricePartner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxCheckBox,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TDialogIncome_PricePartnerForm = class(TAncestorDialogScaleForm)
    PanelValue: TPanel;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbAmountPartner: TGroupBox;
    EditAmountPartner: TcxCurrencyEdit;
    cbAmountPartnerSecond: TCheckBox;
    gbPrice: TGroupBox;
    EditPrice: TcxCurrencyEdit;
    cbPriceWithVAT: TCheckBox;
    gbOperDate: TGroupBox;
    OperDateEdit: TcxDateEdit;
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
  end;

var
   DialogIncome_PricePartnerForm: TDialogIncome_PricePartnerForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogIncome_PricePartnerForm.Checked: boolean; //Проверка корректного ввода в Edit
var AmountPartner, PricePartner : Double;
begin
     Result:= true;

     //Количество у контрагента
     if gbAmountPartner.Visible = TRUE then
     begin
         try AmountPartner:= StrToFloat(EditAmountPartner.Text);
         except
               AmountPartner:= 0;
         end;
         if AmountPartner <=0
         then begin
              ShowMessage('Ошибка.Количество не может быть 0.');
              Result:=false;
              exit;
         end;
     end;
     //Цена у контрагента
     if gbPrice.Visible = TRUE then
     begin
         try PricePartner:= StrToFloat(EditPrice.Text);
         except
               PricePartner:= 0;
         end;
         if PricePartner <=0
         then begin
              ShowMessage('Ошибка.Цена не может быть 0.');
              Result:=false;
              exit;
         end;
     end;
     //
     try StrToDate (OperDateEdit.Text);
     except
           OperDateEdit.Text:= DateToStr(Date);
     end;


end;
{------------------------------------------------------------------------------}
end.
