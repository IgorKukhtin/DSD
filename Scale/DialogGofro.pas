unit DialogGofro;

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
  cxMaskEdit, cxDropDownEdit, cxCalendar, Data.DB, Datasnap.DBClient, dsdCommon,
  cxCheckBox;

type
  TDialogGofroForm = class(TAncestorDialogScaleForm)
    infoPanelSpace_2: TPanel;
    infoPanel_1: TPanel;
    infoPanelGoodsCode_1: TPanel;
    LabelGoodsCode_1: TLabel;
    infoPanelGoodsName_1: TPanel;
    LabelGoodsName_1: TLabel;
    ActionList: TActionList;
    actExec: TAction;
    EditGoodsCode_1: TcxCurrencyEdit;
    EditGoodsName_1: TcxButtonEdit;
    infoPanelAmount_1: TPanel;
    LabelAmount_1: TLabel;
    EditAmount_1: TcxCurrencyEdit;
    infoPanelSpace_1: TPanel;
    infoPanel_2: TPanel;
    infoPanelGoodsCode_2: TPanel;
    LabelGoodsCode_2: TLabel;
    EditGoodsCode_2: TcxCurrencyEdit;
    infoPanelGoodsName_2: TPanel;
    LabelGoodsName_2: TLabel;
    EditGoodsName_2: TcxButtonEdit;
    infoPanelAmount_2: TPanel;
    LabelAmount_2: TLabel;
    EditAmount_2: TcxCurrencyEdit;
    infoPanelSpace_last: TPanel;
    infoPanelSpace_8: TPanel;
    infoPanelSpace_7: TPanel;
    infoPanelSpace_6: TPanel;
    infoPanelSpace_5: TPanel;
    infoPanelSpace_4: TPanel;
    infoPanelSpace_3: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    EditGoodsCode_3: TcxCurrencyEdit;
    Panel3: TPanel;
    Label2: TLabel;
    EditGoodsName_3: TcxButtonEdit;
    Panel4: TPanel;
    Label3: TLabel;
    EditAmount_3: TcxCurrencyEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    EditGoodsCode_4: TcxCurrencyEdit;
    Panel7: TPanel;
    Label5: TLabel;
    EditGoodsName_4: TcxButtonEdit;
    Panel8: TPanel;
    Label6: TLabel;
    EditAmount_4: TcxCurrencyEdit;
    Panel9: TPanel;
    Panel10: TPanel;
    Label7: TLabel;
    EditGoodsCode_8: TcxCurrencyEdit;
    Panel11: TPanel;
    Label8: TLabel;
    EditGoodsName_8: TcxButtonEdit;
    Panel12: TPanel;
    Label9: TLabel;
    EditAmount_8: TcxCurrencyEdit;
    Panel13: TPanel;
    Panel14: TPanel;
    Label10: TLabel;
    EditGoodsCode_7: TcxCurrencyEdit;
    Panel15: TPanel;
    Label11: TLabel;
    EditGoodsName_7: TcxButtonEdit;
    Panel16: TPanel;
    Label12: TLabel;
    EditAmount_7: TcxCurrencyEdit;
    Panel17: TPanel;
    Panel18: TPanel;
    Label13: TLabel;
    EditGoodsCode_6: TcxCurrencyEdit;
    Panel19: TPanel;
    Label14: TLabel;
    EditGoodsName_6: TcxButtonEdit;
    Panel20: TPanel;
    Label15: TLabel;
    EditAmount_6: TcxCurrencyEdit;
    Panel21: TPanel;
    Panel22: TPanel;
    Label16: TLabel;
    EditGoodsCode_5: TcxCurrencyEdit;
    Panel23: TPanel;
    Label17: TLabel;
    EditGoodsName_5: TcxButtonEdit;
    Panel24: TPanel;
    Label18: TLabel;
    EditAmount_5: TcxCurrencyEdit;
    infoPanel_box: TPanel;
    Panel26: TPanel;
    Label19: TLabel;
    EditGoodsCode_box: TcxCurrencyEdit;
    Panel27: TPanel;
    Label20: TLabel;
    EditGoodsName_box: TcxButtonEdit;
    Panel28: TPanel;
    Label21: TLabel;
    EditAmount_box: TcxCurrencyEdit;
    infoPanel_pd: TPanel;
    Panel30: TPanel;
    Label22: TLabel;
    EditGoodsCode_pd: TcxCurrencyEdit;
    Panel31: TPanel;
    Label23: TLabel;
    EditGoodsName_pd: TcxButtonEdit;
    Panel32: TPanel;
    Label24: TLabel;
    EditAmount_pd: TcxCurrencyEdit;
    infoPanel_ugol: TPanel;
    Panel34: TPanel;
    Label25: TLabel;
    EditGoodsCode_ugol: TcxCurrencyEdit;
    Panel35: TPanel;
    Label26: TLabel;
    EditGoodsName_ugol: TcxButtonEdit;
    Panel36: TPanel;
    Label27: TLabel;
    EditAmount_ugol: TcxCurrencyEdit;
    infoPanelSpace_poddon: TPanel;
    procedure EditGoodsCode_pdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsName_pdPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (var execParamsMovement:TParams;var execParamsMI:TParams) : boolean;
  end;

var
   DialogGofroForm: TDialogGofroForm;

implementation
uses UtilScale, GuideGofro, dmMainScale, DialogStringValue;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogGofroForm.Execute(var execParamsMovement:TParams;var execParamsMI:TParams): boolean;
begin
     EditGoodsCode_pd.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_pd').AsString;
     EditGoodsName_pd.Text:= execParamsMI.ParamByName('GoodsName_gofro_pd').AsString;
     EditAmount_pd.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_pd').AsFloat);
     //
     EditGoodsCode_box.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_box').AsString;
     EditGoodsName_box.Text:= execParamsMI.ParamByName('GoodsName_gofro_box').AsString;
     EditAmount_box.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_box').AsFloat);
     //
     EditGoodsCode_ugol.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_ugol').AsString;
     EditGoodsName_ugol.Text:= execParamsMI.ParamByName('GoodsName_gofro_ugol').AsString;
     EditAmount_ugol.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_ugol').AsFloat);
     //
     EditGoodsCode_1.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_1').AsString;
     EditGoodsName_1.Text:= execParamsMI.ParamByName('GoodsName_gofro_1').AsString;
     EditAmount_1.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_1').AsFloat);
     //
     EditGoodsCode_2.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_2').AsString;
     EditGoodsName_2.Text:= execParamsMI.ParamByName('GoodsName_gofro_2').AsString;
     EditAmount_2.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_2').AsFloat);
     //
     EditGoodsCode_3.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_3').AsString;
     EditGoodsName_3.Text:= execParamsMI.ParamByName('GoodsName_gofro_3').AsString;
     EditAmount_3.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_3').AsFloat);
     //
     EditGoodsCode_4.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_4').AsString;
     EditGoodsName_4.Text:= execParamsMI.ParamByName('GoodsName_gofro_4').AsString;
     EditAmount_4.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_4').AsFloat);
     //
     EditGoodsCode_5.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_5').AsString;
     EditGoodsName_5.Text:= execParamsMI.ParamByName('GoodsName_gofro_5').AsString;
     EditAmount_5.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_5').AsFloat);
     //
     EditGoodsCode_6.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_6').AsString;
     EditGoodsName_6.Text:= execParamsMI.ParamByName('GoodsName_gofro_6').AsString;
     EditAmount_6.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_6').AsFloat);
     //
     EditGoodsCode_7.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_7').AsString;
     EditGoodsName_7.Text:= execParamsMI.ParamByName('GoodsName_gofro_7').AsString;
     EditAmount_7.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_7').AsFloat);
     //
     EditGoodsCode_8.Caption:= execParamsMI.ParamByName('GoodsCode_gofro_8').AsString;
     EditGoodsName_8.Text:= execParamsMI.ParamByName('GoodsName_gofro_8').AsString;
     EditAmount_8.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_8').AsFloat);
     //
     ActiveControl:= EditGoodsCode_pd;
     result:=(ShowModal=mrOk);
     //
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_pdKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_box;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsName_pdPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var ParamsGuide_local :TParams;
begin
  Create_ParamsGuide(ParamsGuide_local);
  //
  ParamsGuide_local.ParamByName('GuideId').AsInteger:= ParamsMI.ParamByName('GoodsId_gofro_pd').AsString;
  ParamsGuide_local.ParamByName('GuideCode').AsInteger:= ParamsMI.ParamByName('GoodsCode_gofro_pd').AsString;
  ParamsGuide_local.ParamByName('GuideName').asString:= ParamsMI.ParamByName('GoodsName_gofro_pd').AsString;
  //
  if GuideGofroForm.Execute(ParamsGuide_local)
  then begin
     EditGoodsCode_pd.Caption:= ParamsGuide_local.ParamByName('GuideCode').AsString;
     EditGoodsName_pd.Text:= ParamsGuide_local.ParamByName('GuideName').AsString;
     //
     ParamsMI.ParamByName('GoodsId_gofro_pd').AsString:=   ParamsGuide_local.ParamByName('GuideId').AsInteger;
     ParamsMI.ParamByName('GoodsCode_gofro_pd').AsString:= ParamsGuide_local.ParamByName('GuideCode').AsInteger;
     ParamsMI.ParamByName('GoodsName_gofro_pd').AsString:= ParamsGuide_local.ParamByName('GuideName').asString;
     //
     ActiveControl:=EditGoodsCode_box;
  end;
  //
  ParamsGuide_local.Free;
end;
{------------------------------------------------------------------------------}
function TDialogGofroForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= false;
     //
     try ParamsMI.ParamByName('Amount_gofro_pd').AsFloat := StrToFloat(EditAmount_pd.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_pd').AsFloat := 0;
     end;
     Result:= ParamsMI.ParamByName('Amount_gofro_pd').AsFloat >= 0;
     //
     if not Result then
     begin
          ShowMessage ('Введите значение <Кол-во Поддоны>.');
          exit;
     end;
     //
     //
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
