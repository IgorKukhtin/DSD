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
  cxMaskEdit, cxDropDownEdit, cxCalendar, Data.DB, Datasnap.DBClient, dsdCommon;

type
  TDialogPeresortForm = class(TAncestorDialogScaleForm)
    infoPanelGoodsName_in: TPanel;
    LabelGoodsName_in: TLabel;
    cxButtonEdit1: TcxButtonEdit;
    infoPanelGoods_in2: TPanel;
    infoPanelGoodsCode_in: TPanel;
    LabelGoodsCode_in: TLabel;
    PanelGoodsCode_in: TPanel;
    infoPanelGoodsKindName_in: TPanel;
    Label5: TLabel;
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
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    Panel7: TPanel;
    Label3: TLabel;
    cxButtonEdit2: TcxButtonEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    Label4: TLabel;
    cxCurrencyEdit1: TcxCurrencyEdit;
    Panel10: TPanel;
    Label6: TLabel;
    cxDateEdit1: TcxDateEdit;
    BitBtn1: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure EditTare1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare9KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare10KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPartionCellKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare1Enter(Sender: TObject);
    procedure EditTare1Exit(Sender: TObject);
    procedure EditTare1PropertiesChange(Sender: TObject);
    procedure EditPartionCellPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditWeightTare2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditWeightTare1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTare0KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure infoPanelGoods_inClick(Sender: TObject);
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
{
     //
     if not DMMainScaleCehForm.gpGet_Scale_Goods_gk(execParamsMI) then exit;

     //Количество упаковок - Флоупак +  Нар.180 + Нар. 200
     EditTare0.Text:=FloatToStr(execParamsMI.ParamByName('CountPack').AsFloat);
     // Вес 1-ой упаковки
     WeightPack:= execParamsMI.ParamByName('WeightPack').AsFloat;
     // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
     if execParamsMI.ParamByName('NamePack').AsString <> ''
     then WeightTare_0:= execParamsMI.ParamByName('WeightPack').AsFloat
     else WeightTare_0:= 0;

     // Вес товара для шт.
     Weight_gd:= execParamsMI.ParamByName('Weight_gd').AsFloat;

     // Название 1-ой упаковки - Флоупак +  Нар.180 + Нар
     if execParamsMI.ParamByName('NamePack').AsString <> ''
     then if execParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Sh
          then LabelTare0.Caption:= 'Кол-во ' + execParamsMI.ParamByName('NamePack').AsString + ' ('+FloatToStr(execParamsMI.ParamByName('Weight_gd').AsFloat)+' кг.) + ('+FloatToStr(execParamsMI.ParamByName('WeightPack').AsFloat)+' кг.)'
          else LabelTare0.Caption:= 'Кол-во ' + execParamsMI.ParamByName('NamePack').AsString + ' ('+FloatToStr(execParamsMI.ParamByName('WeightPack').AsFloat)+' кг.)'
     else if execParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Sh
          then LabelTare0.Caption:= 'Нет Кол-во Флоупак ('+FloatToStr(execParamsMI.ParamByName('Weight_gd').AsFloat)+' кг.) + ('+FloatToStr(execParamsMI.ParamByName('WeightPack').AsFloat)+' кг.)'
          else LabelTare0.Caption:= 'Нет Кол-во Флоупак';


     // на старте этот поддон
     if (execParamsMI.ParamByName('CountTare1').AsFloat = 0)
    and (execParamsMI.ParamByName('CountTare1').AsFloat = 0)
     then begin execParamsMI.ParamByName('CountTare1').AsFloat:= 1; ActiveControl:= EditWeightTare1; end
     else ActiveControl:= EditTare1;


     EditTare1.Text:=FloatToStr(execParamsMI.ParamByName('CountTare1').AsFloat);
     EditWeightTare1.Text:=FloatToStr(SettingMain.WeightTare1);
     EditTare2.Text:=FloatToStr(execParamsMI.ParamByName('CountTare2').AsFloat);
     EditWeightTare2.Text:=FloatToStr(SettingMain.WeightTare2);

     EditTare3.Text:=FloatToStr(execParamsMI.ParamByName('CountTare3').AsFloat);
     EditTare4.Text:=FloatToStr(execParamsMI.ParamByName('CountTare4').AsFloat);
     EditTare5.Text:=FloatToStr(execParamsMI.ParamByName('CountTare5').AsFloat);
     EditTare6.Text:=FloatToStr(execParamsMI.ParamByName('CountTare6').AsFloat);
     EditTare7.Text:=FloatToStr(execParamsMI.ParamByName('CountTare7').AsFloat);
     EditTare8.Text:=FloatToStr(execParamsMI.ParamByName('CountTare8').AsFloat);
     EditTare9.Text:=FloatToStr(execParamsMI.ParamByName('CountTare9').AsFloat);
     EditTare10.Text:=FloatToStr(execParamsMI.ParamByName('CountTare10').AsFloat);
     //
     PartionCellId:=execParamsMI.ParamByName('PartionCellId').AsInteger;
     EditPartionCell.Text:= execParamsMI.ParamByName('PartionCellName').AsString;
     //
     PartionDateEdit.Text:= DateToStr(execParamsMovement.ParamByName('OperDate').AsDateTime);
     //
     RealWeight:= execParamsMI.ParamByName('RealWeight').AsFloat;
     RealWeight_Get:= execParamsMI.ParamByName('RealWeight_Get').AsFloat;
     MeasureId:= execParamsMI.ParamByName('MeasureId').AsInteger;
     //
     EditTare1PropertiesChange(EditTare1);
     }
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
procedure TDialogPeresortForm.EditPartionCellPropertiesButtonClick(Sender: TObject;  AButtonIndex: Integer);
var lParams:TParams;
begin
         Create_ParamsGoodsLine(lParams);

           Create_ParamsPartionCell(lParams);
           lParams.ParamByName('PartionCellId').asInteger:=0;
           lParams.ParamByName('PartionCellName').asString:='';
           lParams.ParamByName('InvNumber').asString:='';
            //
            if 1=1 //GuidePartionCellForm.Execute(lParams)
            then
            begin
                 PartionCellId:=lParams.ParamByName('PartionCellId').AsInteger;
                 //
                 //EditPartionCell.Text:= lParams.ParamByName('PartionCellName').AsString;
                 EditPartionCell.Text:= lParams.ParamByName('InvNumber').AsString;
            end
            else
            begin
                 PartionCellId:=0;
                 //
                 EditPartionCell.Text:= '';
            end;
            lParams.Free;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare1Enter(Sender: TObject);
begin
     TEdit(Sender).SelectAll;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare1Exit(Sender: TObject);
begin
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare1PropertiesChange(Sender: TObject);
begin
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditWeightTare1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare2;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditWeightTare2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare3;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditWeightTare1;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditWeightTare2;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare4;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare5;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare6;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare7;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare8;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare9;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare9KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare10;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare10KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditTare0KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditPartionCell;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.EditPartionCellKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    //if Key=13
    //then ActiveControl:=bbOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  CanClose:= true;
end;
{------------------------------------------------------------------------------}
procedure TDialogPeresortForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
  with spSelect do
  begin
  end;
end;

procedure TDialogPeresortForm.infoPanelGoods_inClick(Sender: TObject);
begin
  inherited;

end;

{------------------------------------------------------------------------------}
function TDialogPeresortForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
