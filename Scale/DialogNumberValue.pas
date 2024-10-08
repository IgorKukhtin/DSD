unit DialogNumberValue;

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
  dxSkinXmas2008Blue;

type
  TDialogNumberValueForm = class(TAncestorDialogScaleForm)
    PanelNumberValue: TPanel;
    NumberValueEdit: TcxCurrencyEdit;
    LabelNumberValue: TLabel;
  private
    function Checked: boolean; override;//Ïğîâåğêà êîğğåêòíîãî ââîäà â Edit
  public
   NumberValue:Integer;
  end;

var
   DialogNumberValueForm: TDialogNumberValueForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogNumberValueForm.Checked: boolean; //Ïğîâåğêà êîğğåêòíîãî ââîäà â Edit
begin
     try NumberValue:=StrToInt(NumberValueEdit.Text);except NumberValue:=0;end;
     Result:=NumberValue>=0;
end;
{------------------------------------------------------------------------------}
end.
