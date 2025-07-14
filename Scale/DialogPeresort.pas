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
    cbRePack: TcxCheckBox;
    procedure EditPartionCellKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actExecExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    PartionCellId : Integer;
    MeasureId : Integer;
    CountTare1: Integer;
    CountTare2: Integer;
    CountTare3: Integer;
    CountTare4: Integer;
    CountTare5: Integer;
    CountTare6: Integer;
    CountTare7: Integer;
    CountTare8: Integer;
    CountTare9: Integer;
    CountTare10: Integer;
    CountTare_0: Integer;

    // Вес Товара
    Weight_gd  : Double;
    // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
    WeightPack  : Double;
    // ШТ
    Sh_calc: Double;

    // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
    WeightTare_0: Double;
    //
    WeightTare1 : Double;
    WeightTare2 : Double;

    RealWeight  : Double;
    RealWeight_Get : Double;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (var execParamsMovement:TParams;var execParamsMI:TParams) : boolean;
  end;

var
   DialogPeresortForm: TDialogPeresortForm;

implementation
uses UtilScale, GuideGoodsPeresort, dmMainScale;
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
     //подставляется приход
     EditAmount_out.Text:= FloatToStr(execParamsMI.ParamByName('Amount_in_calc').AsFloat);
     //
     EditAmount_out.Properties.DisplayFormat:= ',0.#### ' + execParamsMI.ParamByName('MeasureName_out').AsString;
     EditPartionDate_out.Date:= Date;

     //
     result:=(ShowModal=mrOk);
     //
     {if Result then
     begin
          execParamsMI.ParamByName('PartionCellId').AsInteger:= PartionCellId;
          execParamsMI.ParamByName('PartionCellName').AsString:= EditPartionCell.Text;
          //
          if CountTare1 > 0 then SettingMain.WeightTare1:= WeightTare1 else SettingMain.WeightTare1:= 0;
          if CountTare2 > 0 then SettingMain.WeightTare2:= WeightTare2 else SettingMain.WeightTare2:= 0;

          execParamsMI.ParamByName('CountPack').AsFloat:=CountTare_0;

          execParamsMI.ParamByName('CountTare1').AsFloat:=CountTare1;
          execParamsMI.ParamByName('CountTare2').AsFloat:=CountTare2;
          execParamsMI.ParamByName('CountTare3').AsFloat:=CountTare3;
          execParamsMI.ParamByName('CountTare4').AsFloat:=CountTare4;
          execParamsMI.ParamByName('CountTare5').AsFloat:=CountTare5;
          execParamsMI.ParamByName('CountTare6').AsFloat:=CountTare6;
          execParamsMI.ParamByName('CountTare7').AsFloat:=CountTare7;
          execParamsMI.ParamByName('CountTare8').AsFloat:=CountTare8;
          execParamsMI.ParamByName('CountTare9').AsFloat:=CountTare9;
          execParamsMI.ParamByName('CountTare10').AsFloat:=CountTare10;

          if (Sh_calc > 0) and (execParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Sh) and (RealWeight_Get > 0)
          then execParamsMI.ParamByName('RealWeight').AsFloat:= Sh_calc;

     end;
     }
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.FormResize(Sender: TObject);
begin
  exit;
  inherited;

end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditPartionCellKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=bbOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.actExecExecute(Sender: TObject);
begin
  if GuideGoodsPeresortForm.Execute(ParamsMI)
  then begin
     PanelGoodsCode_out.Caption:= ParamsMI.ParamByName('GoodsCode_out').AsString;
     EditGoodsName_out.Text:= ParamsMI.ParamByName('GoodsName_out').AsString;
     PanelGoodsKindName_out.Caption:= ParamsMI.ParamByName('GoodsKindName_out').AsString;
     //
     if ParamsMI.ParamByName('MeasureId').AsInteger = ParamsMI.ParamByName('MeasureId_out').AsInteger
     then //не меняется
          ParamsMI.ParamByName('Amount_out_calc').AsFloat:= ParamsMI.ParamByName('Amount_in_calc').AsFloat

     else if (ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_sh)
         and (ParamsMI.ParamByName('MeasureId_out').AsInteger = zc_Measure_kg)
          then //переводится в вес
               ParamsMI.ParamByName('Amount_out_calc').AsFloat:= _myTrunct_3(ParamsMI.ParamByName('Amount_in_calc').AsFloat * ParamsMI.ParamByName('Weight_gd_out').AsFloat)

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
     if True then

     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
