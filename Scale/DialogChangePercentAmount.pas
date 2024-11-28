unit DialogChangePercentAmount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar, dsdCommon;

type
  TDialogChangePercentAmountForm = class(TAncestorDialogScaleForm)
    PanelNumberValue: TPanel;
    rgDiscountAmountPartner: TRadioGroup;
    Label2: TLabel;
    DiscountAmountPartnerEdit: TcxCurrencyEdit;
    btnSaveAll: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    PartnertEdit: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
    InvNumberEdit: TEdit;
    InvNumberPartnerEdit: TEdit;
    Label4: TLabel;
    DateValueEdit: TcxDateEdit;
    LabelDateValue: TLabel;
    ActionList: TActionList;
    actWeighingPartner_ActDiffF: TdsdInsertUpdateAction;
    FormParams: TdsdFormParams;
    procedure btnSaveAllClick(Sender: TObject);
    procedure DiscountAmountPartnerEditExit(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
   MovementId_wp, MovementId_DocPartner : Integer;
  end;

var
   DialogChangePercentAmountForm: TDialogChangePercentAmountForm;

implementation
uses UtilScale, DMMainScale
   , Data.DB
    ;
{$R *.dfm}
{------------------------------------------------------------------------------}
procedure TDialogChangePercentAmountForm.btnSaveAllClick(Sender: TObject);
begin
     if MovementId_DocPartner = 0
     then begin
              ShowMessage('Ошибка.Документ Поставщика не установлен.');
              exit;
     end;
     //
     if not Checked then exit;
     //
     FormParams.ParamByName('MovementId_DocPartner').Value:=MovementId_DocPartner;
     actWeighingPartner_ActDiffF.Execute;
     //
     ModalResult:= mrOK;
end;
{------------------------------------------------------------------------------}
function TDialogChangePercentAmountForm.Checked: boolean; //Проверка корректного ввода в Edit
var DiscountAmountPartner : Double;
     isDiscount_q:Boolean;
     isDiscount_t:Boolean;
     execParams : TParams;
     OperDatePartner:TDateTime;
begin
     try OperDatePartner:= StrToDate(DateValueEdit.Text)
     except
            ShowMessage('Ошибка.Заполните значение Дата у поставщика.');
            Result:=false;
            exit;
     end;
     //
     try DiscountAmountPartner:= StrToFloat(DiscountAmountPartnerEdit.Text)
     except DiscountAmountPartner:= 0;
     end;
     if (rgDiscountAmountPartner.ItemIndex = -1) and (DiscountAmountPartner > 0)
     then begin
               ShowMessage('Ошибка.Для скидки по весу '+DiscountAmountPartnerEdit.Text+'% необходимо выбрать вид скидки.');
               ActiveControl:= rgDiscountAmountPartner;
               exit;
     end;
     if (rgDiscountAmountPartner.ItemIndex >= 0) and (DiscountAmountPartner = 0)
     then begin
               ShowMessage('Ошибка.Для скидки '+rgDiscountAmountPartner.Items[rgDiscountAmountPartner.ItemIndex]+' необходимо заполнить % скидки по весу.');
               ActiveControl:= DiscountAmountPartnerEdit;
               exit;
     end;
     //
     if (MovementId_DocPartner = MovementId_wp) and ((rgDiscountAmountPartner.ItemIndex >= 0) or (DiscountAmountPartner > 0))
     then begin
               ShowMessage('Ошибка.Для накладной поставщика нельзя заполнить % скидки по весу.');
               ActiveControl:= DiscountAmountPartnerEdit;
               exit;
     end;

     //
     isDiscount_q:= rgDiscountAmountPartner.ItemIndex = 0;
     isDiscount_t:= rgDiscountAmountPartner.ItemIndex = 1;
     //
     if ((DiscountAmountPartner > 0) or(rgDiscountAmountPartner.ItemIndex >=0))
        and (MovementId_DocPartner <> MovementId_wp)
     then begin
         execParams:=nil;
         ParamAddValue(execParams,'MovementId', ftInteger, MovementId_wp);   //
         ParamAddValue(execParams,'DiscountAmountPartner', ftFloat, DiscountAmountPartner); //
         ParamAddValue(execParams,'isDiscount_q', ftBoolean, isDiscount_q);  //
         ParamAddValue(execParams,'isDiscount_t', ftBoolean, isDiscount_t);  //
         //
          Result:= DMMainScaleForm.gpUpdate_Scale_Movement_ChangePercentAmount(execParams);
          execParams.Free;
          if not Result then exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementId',ftInteger,MovementId_DocPartner);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MovementDate_OperDatePartner');
     ParamAddValue(execParams,'inValueData',ftDateTime,OperDatePartner);
     //
     Result:= DMMainScaleForm.gpUpdate_Scale_MovementDate(execParams);
     execParams.Free;
     if not Result then exit;
end;
{------------------------------------------------------------------------------}
procedure TDialogChangePercentAmountForm.DiscountAmountPartnerEditExit(
  Sender: TObject);
begin
  if (trim(DiscountAmountPartnerEdit.Text) = '') OR (trim(DiscountAmountPartnerEdit.Text) = '0')
  then rgDiscountAmountPartner.ItemIndex:= -1;
end;
{------------------------------------------------------------------------------}
end.
