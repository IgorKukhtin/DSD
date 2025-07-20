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
    BitBtn1: TBitBtn;
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
    procedure actExecExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EditGoodsCode_pdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (var execParamsMovement:TParams;var execParamsMI:TParams) : boolean;
  end;

var
   DialogGofroForm: TDialogGofroForm;

implementation
uses UtilScale, GuideGoodsPeresort, dmMainScale, DialogStringValue;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogGofroForm.Execute(var execParamsMovement:TParams;var execParamsMI:TParams): boolean;
begin
     EditGoodsCode_pd.Caption:= execParamsMI.ParamByName('GoodsCode_pd').AsString;
     EditGoodsName_pd.Text:= execParamsMI.ParamByName('GoodsName_pd').AsString;
     EditAmount_pd.Text:= FloatToStr(execParamsMI.ParamByName('Amount_pd').AsFloat);
     //
     PanelGoodsCode_out.Caption:= execParamsMI.ParamByName('GoodsCode_out').AsString;
     EditGoodsName_out.Text:= execParamsMI.ParamByName('GoodsName_out').AsString;
     PanelGoodsKindName_out.Caption:= execParamsMI.ParamByName('GoodsKindName_out').AsString;
     if execParamsMI.ParamByName('GoodsId_out').AsInteger > 0
     then EditAmount_out.Text:= FloatToStr(execParamsMI.ParamByName('Amount_out_calc').AsFloat)
     else //подставляется приход
          EditAmount_out.Text:= FloatToStr(execParamsMI.ParamByName('Amount_in_calc').AsFloat);
     //
     EditAmount_out.Properties.DisplayFormat:= ',0.#### ' + execParamsMI.ParamByName('MeasureName_out').AsString;
     EditPartionDate_out.Date:= Date;

     //
     result:=(ShowModal=mrOk);
     //
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_pdKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then ActiveControl:= EditGoodsCode_box;

end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.FormResize(Sender: TObject);
begin
  exit;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.actExecExecute(Sender: TObject);
begin
  if GuideGoodsPeresortForm.Execute(ParamsMI)
  then begin
     PanelGoodsCode_out.Caption:= ParamsMI.ParamByName('GoodsCode_out').AsString;
     EditGoodsName_out.Text:= ParamsMI.ParamByName('GoodsName_out').AsString;
     PanelGoodsKindName_out.Caption:= '('+ParamsMI.ParamByName('GoodsKindCode_out').AsString+')'+ParamsMI.ParamByName('GoodsKindName_out').AsString;
     //
     if ParamsMI.ParamByName('MeasureId').AsInteger = ParamsMI.ParamByName('MeasureId_out').AsInteger
     then //не меняется
          ParamsMI.ParamByName('Amount_out_calc').AsFloat:= ParamsMI.ParamByName('Amount_in_calc').AsFloat

     else if (ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_sh)
         and (ParamsMI.ParamByName('MeasureId_out').AsInteger = zc_Measure_kg)
          then //переводится в вес
               ParamsMI.ParamByName('Amount_out_calc').AsFloat:= _myTrunct_3(ParamsMI.ParamByName('Amount_in_calc').AsFloat * ParamsMI.ParamByName('Weight_gd').AsFloat)

          else if (ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_kg)
              and (ParamsMI.ParamByName('MeasureId_out').AsInteger = zc_Measure_sh)
              and (ParamsMI.ParamByName('Weight_gd_out').AsFloat > 0)
          then //переводится в шт
               ParamsMI.ParamByName('Amount_out_calc').AsFloat:= ROUND(ParamsMI.ParamByName('Amount_in_calc').AsFloat / ParamsMI.ParamByName('Weight_gd_out').AsFloat)
          else
              ParamsMI.ParamByName('Amount_out_calc').AsFloat:= 0;
     //
     EditAmount_out.Text:= FloatToStr(ParamsMI.ParamByName('Amount_out_calc').AsFloat);
     EditAmount_out.Properties.DisplayFormat:= ',0.#### ' + ParamsMI.ParamByName('MeasureName_out').AsString;
     //
     ActiveControl:=bbOk;
  end;

end;
{------------------------------------------------------------------------------}
function TDialogGofroForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= false;
     //
     try
         ParamsMI.ParamByName('PartionDate_in').AsDateTime:= StrToDate (EditPartionDate_in.Text)
     except
           ShowMessage ('Ошибка.Партия дата приход.');
           exit;
     end;
     //
     try
         ParamsMI.ParamByName('PartionDate_out').AsDateTime:= StrToDate (EditPartionDate_out.Text)
     except
           ShowMessage ('Ошибка.Партия дата расход.');
           exit;
     end;
     //
     Result:= DMMainScaleForm.gpGet_Scale_GoodsByGoodsKindPeresort_check(ParamsMI);
     //
     if not  Result then
     begin
          if not DialogStringValueForm.Execute(false, true, true)
          then begin ShowMessage ('Не разрешено проводить данный вид пересортицы.Для подтверждения необходимо ввести пароль СБ.'); exit; end;
          //
          //
          if DMMainScaleForm.gpGet_Scale_PSW_delete (DialogStringValueForm.StringValueEdit.Text) <> ''
          then begin ShowMessage ('Пароль неверный.Провести данный вид пересортицы нельзя.');exit;end;
     end;

     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
