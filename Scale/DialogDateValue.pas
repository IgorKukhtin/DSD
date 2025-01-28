unit DialogDateValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TDialogDateValueForm = class(TAncestorDialogScaleForm)
    PanelDateValue: TPanel;
    LabelDateValue: TLabel;
    DateValueEdit: TcxDateEdit;
    cbPartionDate_save: TCheckBox;
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    isPartionGoodsDate:Boolean;
  end;

var
   DialogDateValueForm: TDialogDateValueForm;

implementation
uses UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogDateValueForm.Checked: boolean; //Проверка корректного ввода в Edit
var tmpValue:TDateTime;
     tmpPeriod:Integer;
begin
     try
        tmpValue := StrToDate(DateValueEdit.Text)
     except
        Result:=false;
        exit;
     end;
     //
     if isPartionGoodsDate = true
     then begin
          if (tmpValue>ParamsMovement.ParamByName('OperDate').AsDateTime) then
          begin
               ShowMessage('Неверно установлена дата. Не может быть позже <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               Result:=false;
               exit;
          end;
          try tmpPeriod:= StrToInt(GetArrayList_Value_byName(Default_Array,'PeriodPartionGoodsDate'))
          except tmpPeriod:= 1;
          end;
          if (tmpValue<ParamsMovement.ParamByName('OperDate').AsDateTime - tmpPeriod) then
          begin
               ShowMessage('Неверно установлена дата. Не может быть раньше <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               Result:=false;
               exit;
          end;
     end;
     //
     Result:=true;
end;
{------------------------------------------------------------------------------}
end.
