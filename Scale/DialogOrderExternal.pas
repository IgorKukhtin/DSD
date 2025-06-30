unit DialogOrderExternal;

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
  TDialogOrderExternalForm = class(TAncestorDialogScaleForm)
    PanelValue: TPanel;
    gbBarCode: TGroupBox;
    EditBarCode: TEdit;
    gbOrderExternal: TGroupBox;
    gbGoodsProperty: TGroupBox;
    gbRetail: TGroupBox;
    gbPartner: TGroupBox;
    PanelOrderExternal: TPanel;
    PanelPartner: TPanel;
    PanelRetail: TPanel;
    PanelGoodsProperty: TPanel;
    procedure EditBarCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
  end;

var
   DialogOrderExternalForm: TDialogOrderExternalForm;

implementation
uses DMMainScale, UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogOrderExternalForm.Checked: boolean; //Проверка корректного ввода в Edit
var AmountPartner, PricePartner : Double;
begin
     Result:= true;
     //
    if (EditBarCode.Text = '') or (EditBarCode.Text = '0') then
    begin
          ParamsMI.ParamByName('MovementId_1001').asInteger      := 0;
          ParamsMI.ParamByName('InvNumber_1001').asString        := '';
          ParamsMI.ParamByName('OrderExternalName_1001').asString:= '';
          ParamsMI.ParamByName('PartnerName_1001').asString      := '';
          ParamsMI.ParamByName('GoodsPropertyName_1001').asString:= '';
          ParamsMI.ParamByName('RetailName_1001').asString       := '';
          //
          EditBarCode.Text          := ParamsMI.ParamByName('InvNumber_1001').asString;
          PanelOrderExternal.Caption:= ParamsMI.ParamByName('OrderExternalName_1001').asString;
          PanelPartner.Caption      := ParamsMI.ParamByName('PartnerName_1001').asString;
          PanelGoodsProperty.Caption:= ParamsMI.ParamByName('GoodsPropertyName_1001').asString;
          PanelRetail.Caption       := ParamsMI.ParamByName('RetailName_1001').asString;
          //
          ActiveControl:=bbOk;
    end;
    //
     //Заказ клиента
     if ParamsMI.ParamByName('MovementId_1001').asInteger = -1 then
     begin
          ShowMessage('Ошибка.Документ не может быть 0.');
          Result:=false;
          exit;
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogOrderExternalForm.EditBarCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    if (EditBarCode.Text = '') or (EditBarCode.Text = '0') then
    begin
          ParamsMI.ParamByName('MovementId_1001').asInteger      := 0;
          ParamsMI.ParamByName('InvNumber_1001').asString        := '';
          ParamsMI.ParamByName('OrderExternalName_1001').asString:= '';
          ParamsMI.ParamByName('PartnerName_1001').asString      := '';
          ParamsMI.ParamByName('GoodsPropertyName_1001').asString:= '';
          ParamsMI.ParamByName('RetailName_1001').asString       := '';
          //
          EditBarCode.Text          := ParamsMI.ParamByName('InvNumber_1001').asString;
          PanelOrderExternal.Caption:= ParamsMI.ParamByName('OrderExternalName_1001').asString;
          PanelPartner.Caption      := ParamsMI.ParamByName('PartnerName_1001').asString;
          PanelGoodsProperty.Caption:= ParamsMI.ParamByName('GoodsPropertyName_1001').asString;
          PanelRetail.Caption       := ParamsMI.ParamByName('RetailName_1001').asString;
          //
          ActiveControl:=bbOk;
    end
    else
    if DMMainScaleForm.gpGet_Scale_OrderExternal_1001(ParamsMI,EditBarCode.Text) then
    begin
          EditBarCode.Text          := ParamsMI.ParamByName('InvNumber_1001').asString;
          PanelOrderExternal.Caption:= ParamsMI.ParamByName('OrderExternalName_1001').asString;
          PanelPartner.Caption      := ParamsMI.ParamByName('PartnerName_1001').asString;
          PanelGoodsProperty.Caption:= ParamsMI.ParamByName('GoodsPropertyName_1001').asString;
          PanelRetail.Caption       := ParamsMI.ParamByName('RetailName_1001').asString;
          //
          ActiveControl:=bbOk;
    end;

end;
{------------------------------------------------------------------------------}
end.
