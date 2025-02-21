unit DialogTare;

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
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar;

type
  TDialogTareForm = class(TAncestorDialogScaleForm)
    infoPanelTareFix: TPanel;
    infoPanelTare1: TPanel;
    PanelTare1: TPanel;
    LabelTare1: TLabel;
    EditTare1: TcxCurrencyEdit;
    infoPanelWeightTare1: TPanel;
    LabelWeightTare1: TLabel;
    PanelWeightTare1: TPanel;
    infoPanelTare0: TPanel;
    PanelTare0: TPanel;
    LabelTare0: TLabel;
    EditTare0: TcxCurrencyEdit;
    infoPanelWeightTare0: TPanel;
    LabelWeightTare0: TLabel;
    PanelWeightTare0: TPanel;
    infoPanelTare2: TPanel;
    PanelTare2: TPanel;
    LabelTare2: TLabel;
    EditTare2: TcxCurrencyEdit;
    infoPanelWeightTare2: TPanel;
    LabelWeightTare2: TLabel;
    PanelWeightTare2: TPanel;
    infoPanelTare5: TPanel;
    PanelTare5: TPanel;
    LabelTare5: TLabel;
    EditTare5: TcxCurrencyEdit;
    infoPanelWeightTare5: TPanel;
    LabelWeightTare5: TLabel;
    PanelWeightTare5: TPanel;
    infoPanelTare4: TPanel;
    PanelTare4: TPanel;
    LabelTare4: TLabel;
    EditTare4: TcxCurrencyEdit;
    infoPanelWeightTare4: TPanel;
    LabelWeightTare4: TLabel;
    PanelWeightTare4: TPanel;
    infoPanelTare3: TPanel;
    PanelTare3: TPanel;
    LabelTare3: TLabel;
    EditTare3: TcxCurrencyEdit;
    infoPanelWeightTare3: TPanel;
    LabelWeightTare3: TLabel;
    PanelWeightTare3: TPanel;
    infoPanelTare6: TPanel;
    PanelTare6: TPanel;
    LabelTare6: TLabel;
    EditTare6: TcxCurrencyEdit;
    infoPanelWeightTare6: TPanel;
    LabelWeightTare6: TLabel;
    PanelWeightTare6: TPanel;
    infoPanelTare10: TPanel;
    PanelTare10: TPanel;
    LabelTare10: TLabel;
    EditTare10: TcxCurrencyEdit;
    infoPanelWeightTare10: TPanel;
    LabelWeightTare10: TLabel;
    PanelWeightTare10: TPanel;
    infoPanelTare9: TPanel;
    PanelTare9: TPanel;
    LabelTare9: TLabel;
    EditTare9: TcxCurrencyEdit;
    infoPanelWeightTare9: TPanel;
    LabelWeightTare9: TLabel;
    PanelWeightTare9: TPanel;
    infoPanelTare8: TPanel;
    PanelTare8: TPanel;
    LabelTare8: TLabel;
    EditTare8: TcxCurrencyEdit;
    infoPanelWeightTare8: TPanel;
    LabelWeightTare8: TLabel;
    PanelWeightTare8: TPanel;
    infoPanelTare7: TPanel;
    PanelTare7: TPanel;
    LabelTare7: TLabel;
    EditTare7: TcxCurrencyEdit;
    infoPanelWeightTare7: TPanel;
    LabelWeightTare7: TLabel;
    PanelWeightTare7: TPanel;
    infoPanelPartion: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    PanelWeightGoods_total: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    PanelWeightTare_total: TPanel;
    PanelPartionDate: TPanel;
    LabelPartionDate: TLabel;
    PartionDateEdit: TcxDateEdit;
    AssetPanel: TPanel;
    AssetLabel: TLabel;
    EditPartionCell: TcxButtonEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (inMsg1, inMsg2, inMsg3 :String): boolean;
  end;

var
   DialogTareForm: TDialogTareForm;

implementation
uses UtilScale, DMMainScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogTareForm.Execute(inMsg1, inMsg2, inMsg3 :String): boolean;
begin
     MemoMsg.Lines.Clear;
     if inMsg1 <> '' then MemoMsg.Lines.Add(inMsg1);
     if inMsg2 <> '' then MemoMsg.Lines.Add(inMsg2);
     if inMsg3 <> '' then MemoMsg.Lines.Add(inMsg3);
     //
     ActiveControl:= bbCancel;
     result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  CanClose:= true;
end;
{------------------------------------------------------------------------------}
function TDialogTareForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
