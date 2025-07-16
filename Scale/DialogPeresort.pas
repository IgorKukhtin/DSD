unit DialogPeresort;

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
  TDialogPeresortForm = class(TAncestorDialogScaleForm)
    infoPanelGoodsName_in: TPanel;
    LabelGoodsName_in: TLabel;
    EditGoodsName_in: TcxButtonEdit;
    infoPanelGoods_in2: TPanel;
    infoPanelGoodsCode_in: TPanel;
    LabelGoodsCode_in: TLabel;
    PanelGoodsCode_in: TPanel;
    infoPanelGoodsKindName_in: TPanel;
    LabelGoodsKindName_in: TLabel;
    PanelGoodsKindName_in: TPanel;
    PanelTare4: TPanel;
    infoPanelAmount_in: TPanel;
    LabelAmount_in: TLabel;
    EditAmount_in: TcxCurrencyEdit;
    infoPanelPartionDate_in: TPanel;
    LabelPartionDate_in: TLabel;
    EditPartionDate_in: TcxDateEdit;
    infoPanel: TPanel;
    Panel1: TPanel;
    infoPanelGoodsCode_out: TPanel;
    Label1: TLabel;
    PanelGoodsCode_out: TPanel;
    infoPanelGoodsKindName_out: TPanel;
    LabelGoodsKindName_out: TLabel;
    PanelGoodsKindName_out: TPanel;
    infoPanelGoodsName_out: TPanel;
    LabelGoodsName_out: TLabel;
    EditGoodsName_out: TcxButtonEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    LabelAmount_out: TLabel;
    EditAmount_out: TcxCurrencyEdit;
    infoPanelPartionDate_out: TPanel;
    LabelPartionDate_out: TLabel;
    EditPartionDate_out: TcxDateEdit;
    BitBtn1: TBitBtn;
    ActionList: TActionList;
    actExec: TAction;
    procedure actExecExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (var execParamsMovement:TParams;var execParamsMI:TParams) : boolean;
  end;

var
   DialogPeresortForm: TDialogPeresortForm;

implementation
uses UtilScale, GuideGoodsPeresort, dmMainScale, DialogStringValue;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogPeresortForm.Execute(var execParamsMovement:TParams;var execParamsMI:TParams): boolean;
begin
     execParamsMI.ParamByName('Amount_in_calc').AsFloat:= execParamsMI.ParamByName('RealWeight').AsFloat
                                                        - execParamsMI.ParamByName('CountTare').AsFloat
                                                        * execParamsMI.ParamByName('WeightTare').AsFloat
                                                         ;
     //
     PanelGoodsCode_in.Caption:= execParamsMI.ParamByName('GoodsCode').AsString;
     EditGoodsName_in.Text:= execParamsMI.ParamByName('GoodsName').AsString;
     PanelGoodsKindName_in.Caption:= execParamsMI.ParamByName('GoodsKindName').AsString;
     EditAmount_in.Text:= FloatToStr(execParamsMI.ParamByName('Amount_in_calc').AsFloat);
     EditAmount_in.Properties.DisplayFormat:= ',0.#### ' + execParamsMI.ParamByName('MeasureName').AsString;
     EditPartionDate_in.Date:= Date;
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
procedure TDialogPeresortForm.FormResize(Sender: TObject);
begin
  exit;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.actExecExecute(Sender: TObject);
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
function TDialogPeresortForm.Checked: boolean; //Проверка корректного ввода в Edit
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
