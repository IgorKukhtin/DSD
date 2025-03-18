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
  cxMaskEdit, cxDropDownEdit, cxCalendar, Data.DB, Datasnap.DBClient, dsdCommon;

type
  TDialogTareForm = class(TAncestorDialogScaleForm)
    infoPanelTareFix: TPanel;
    infoPanelTare1: TPanel;
    PanelTare1: TPanel;
    LabelTare1: TLabel;
    EditTare1: TcxCurrencyEdit;
    infoPanelWeightTare1: TPanel;
    LabelWeightTare1: TLabel;
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
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    Panel2: TPanel;
    Label3: TLabel;
    PanelCounttTare_total: TPanel;
    EditWeightTare1: TcxCurrencyEdit;
    EditWeightTare2: TcxCurrencyEdit;
    Panel4: TPanel;
    Label4: TLabel;
    PanelShGoods_total: TPanel;
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
   DialogTareForm: TDialogTareForm;

implementation
uses UtilScale, GuidePartionCell, dmMainScaleCeh;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogTareForm.Execute(var execParamsMovement:TParams;var execParamsMI:TParams): boolean;
begin
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
     //
     result:=(ShowModal=mrOk);
     //
     if Result then
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
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditPartionCellPropertiesButtonClick(Sender: TObject;  AButtonIndex: Integer);
var lParams:TParams;
begin
           Create_ParamsPartionCell(lParams);
           lParams.ParamByName('PartionCellId').asInteger:=0;
           lParams.ParamByName('PartionCellName').asString:='';
           lParams.ParamByName('InvNumber').asString:='';
            //
            if GuidePartionCellForm.Execute(lParams) then
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
procedure TDialogTareForm.EditTare1Enter(Sender: TObject);
begin
     TEdit(Sender).SelectAll;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare1Exit(Sender: TObject);
begin
     if (CountTare_0 < 0)
     then ActiveControl:=EditTare0;

     if (CountTare1 < 0)
     then ActiveControl:=EditTare1;
     if (WeightTare1 < 0)
     then ActiveControl:=EditWeightTare1;

     if (CountTare2 < 0)
     then ActiveControl:=EditTare2;
     if (WeightTare2 < 0)
     then ActiveControl:=EditWeightTare2;

     if (CountTare3 < 0)
     then ActiveControl:=EditTare3;
     if (CountTare4 < 0)
     then ActiveControl:=EditTare4;
     if (CountTare5 < 0)
     then ActiveControl:=EditTare5;
     if (CountTare6 < 0)
     then ActiveControl:=EditTare6;
     if (CountTare7 < 0)
     then ActiveControl:=EditTare7;
     if (CountTare8 < 0)
     then ActiveControl:=EditTare8;
     if (CountTare9 < 0)
     then ActiveControl:=EditTare9;
     if (CountTare10 < 0)
     then ActiveControl:=EditTare10;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare1PropertiesChange(Sender: TObject);
begin
     //0
     try CountTare_0:=StrToInt(EditTare0.Text);
     except
           CountTare_0:=0;
     end;
     PanelWeightTare0.Caption:=FormatFloat(fmtWeight, CountTare_0 * WeightTare_0);
     //1
     try CountTare1:=StrToInt(EditTare1.Text);
     except
           CountTare1:=0;
     end;
     try WeightTare1:=StrToFloat(EditWeightTare1.Text);
     except
           WeightTare1:=0;
     end;
     //2
     try CountTare2:=StrToInt(EditTare2.Text);
     except
           CountTare2:=0;
     end;
     try WeightTare2:=StrToFloat(EditWeightTare2.Text);
     except
           WeightTare2:=0;
     end;
     //3
     try CountTare3:=StrToInt(EditTare3.Text);
     except
           CountTare3:=0;
     end;
     PanelWeightTare3.Caption:=FormatFloat(fmtWeight, CountTare3 * SettingMain.WeightTare3);
     //4
     try CountTare4:=StrToInt(EditTare4.Text);
     except
           CountTare4:=0;
     end;
     PanelWeightTare4.Caption:=FormatFloat(fmtWeight, CountTare4 * SettingMain.WeightTare4);
     //5
     try CountTare5:=StrToInt(EditTare5.Text);
     except
           CountTare5:=0;
     end;
     PanelWeightTare5.Caption:=FormatFloat(fmtWeight, CountTare5 * SettingMain.WeightTare5);
     //6
     try CountTare6:=StrToInt(EditTare6.Text);
     except
           CountTare6:=0;
     end;
     PanelWeightTare6.Caption:=FormatFloat(fmtWeight, CountTare6 * SettingMain.WeightTare6);
     //7
     try CountTare7:=StrToInt(EditTare7.Text);
     except
           CountTare7:=0;
     end;
     PanelWeightTare7.Caption:=FormatFloat(fmtWeight, CountTare7 * SettingMain.WeightTare7);
     //8
     try CountTare8:=StrToInt(EditTare8.Text);
     except
           CountTare8:=0;
     end;
     PanelWeightTare8.Caption:=FormatFloat(fmtWeight, CountTare8 * SettingMain.WeightTare8);
     //9
     try CountTare9:=StrToInt(EditTare9.Text);
     except
           CountTare9:=0;
     end;
     PanelWeightTare9.Caption:=FormatFloat(fmtWeight, CountTare9 * SettingMain.WeightTare9);
     //10
     try CountTare10:=StrToInt(EditTare10.Text);
     except
           CountTare10:=0;
     end;
     PanelWeightTare10.Caption:=FormatFloat(fmtWeight, CountTare10 * SettingMain.WeightTare10);

     //
     PanelCounttTare_total.Caption:= FloatToStr(CountTare3 + CountTare4 + CountTare5 + CountTare6 + CountTare7 + CountTare8 + CountTare9 + CountTare10);
     //Total Tare
     PanelWeightTare_total.Caption:= FormatFloat(fmtWeight, CountTare_0 * WeightTare_0
                                                          + CountTare1 * WeightTare1
                                                          + CountTare2 * WeightTare2
                                                          + CountTare3 * SettingMain.WeightTare3
                                                          + CountTare4 * SettingMain.WeightTare4
                                                          + CountTare5 * SettingMain.WeightTare5
                                                          + CountTare6 * SettingMain.WeightTare6
                                                          + CountTare7 * SettingMain.WeightTare7
                                                          + CountTare8 * SettingMain.WeightTare8
                                                          + CountTare9 * SettingMain.WeightTare9
                                                          + CountTare10 * SettingMain.WeightTare10
                                                          );
     //Total Netto
     if MeasureId = zc_Measure_Sh
     then begin
           if RealWeight_get > 0
           then
           PanelWeightGoods_total.Caption:= FormatFloat(fmtWeight, RealWeight_get
                                                                 - CountTare_0 * WeightTare_0
                                                                 - CountTare1 * WeightTare1
                                                                 - CountTare2 * WeightTare2
                                                                 - CountTare3 * SettingMain.WeightTare3
                                                                 - CountTare4 * SettingMain.WeightTare4
                                                                 - CountTare5 * SettingMain.WeightTare5
                                                                 - CountTare6 * SettingMain.WeightTare6
                                                                 - CountTare7 * SettingMain.WeightTare7
                                                                 - CountTare8 * SettingMain.WeightTare8
                                                                 - CountTare9 * SettingMain.WeightTare9
                                                                 - CountTare10 * SettingMain.WeightTare10
                                                                  )
           else PanelWeightGoods_total.Caption:= '';
     end
     else begin
           PanelWeightGoods_total.Caption:= FormatFloat(fmtWeight, RealWeight
                                                                 - CountTare_0 * WeightTare_0
                                                                 - CountTare1 * WeightTare1
                                                                 - CountTare2 * WeightTare2
                                                                 - CountTare3 * SettingMain.WeightTare3
                                                                 - CountTare4 * SettingMain.WeightTare4
                                                                 - CountTare5 * SettingMain.WeightTare5
                                                                 - CountTare6 * SettingMain.WeightTare6
                                                                 - CountTare7 * SettingMain.WeightTare7
                                                                 - CountTare8 * SettingMain.WeightTare8
                                                                 - CountTare9 * SettingMain.WeightTare9
                                                                 - CountTare10 * SettingMain.WeightTare10
                                                                  );
     end;

     //Расчет шт.
     if (MeasureId = zc_Measure_Sh) and (RealWeight_get > 0) and ((Weight_gd + WeightPack) > 0)
     then
         Sh_calc:= ROUND ((RealWeight_get
                         - CountTare1 * WeightTare1
                         - CountTare2 * WeightTare2
                         - CountTare3 * SettingMain.WeightTare3
                         - CountTare4 * SettingMain.WeightTare4
                         - CountTare5 * SettingMain.WeightTare5
                         - CountTare6 * SettingMain.WeightTare6
                         - CountTare7 * SettingMain.WeightTare7
                         - CountTare8 * SettingMain.WeightTare8
                         - CountTare9 * SettingMain.WeightTare9
                         - CountTare10 * SettingMain.WeightTare10
                           )
                         / (Weight_gd + WeightPack)
                          )
      else if (MeasureId = zc_Measure_Sh) and (RealWeight_get = 0)
           then Sh_calc:= RealWeight
           else Sh_calc:= 0;
      PanelShGoods_total.Caption:= FormatFloat(fmtFloat, Sh_calc);
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditWeightTare1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare2;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditWeightTare2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare3;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditWeightTare1;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditWeightTare2;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare4;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare5;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare6;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare7;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare8;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare9;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare9KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare10;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare10KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditTare0;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditTare0KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=EditPartionCell;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.EditPartionCellKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then ActiveControl:=bbOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  CanClose:= true;
end;
{------------------------------------------------------------------------------}
procedure TDialogTareForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Tare_115';
       OutputType:=otDataSet;
       Execute;
       //
       DataSet.First;
       //
       while not DataSet.EOF do
       begin
            if DataSet.FieldByName('NPP').asInteger = 1 then
            begin
                SettingMain.WeightTare1:=DataSet.FieldByName('Weight').asFloat;
                LabelTare1.Caption:=DataSet.FieldByName('GuideName').asString;
                SettingMain.TareId_1:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 2 then
            begin
                SettingMain.WeightTare2:=DataSet.FieldByName('Weight').asFloat;
                LabelTare2.Caption:=DataSet.FieldByName('GuideName').asString;
                SettingMain.TareId_2:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 3 then
            begin
                SettingMain.WeightTare3:=DataSet.FieldByName('Weight').asFloat;
                LabelTare3.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare3)+' кг';
                SettingMain.TareId_3:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 4 then
            begin
                SettingMain.WeightTare4:=DataSet.FieldByName('Weight').asFloat;
                LabelTare4.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare4)+' кг';
                SettingMain.TareId_4:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 5 then
            begin
                SettingMain.WeightTare5:=DataSet.FieldByName('Weight').asFloat;
                LabelTare5.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare5)+' кг';
                SettingMain.TareId_5:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 6 then
            begin
                SettingMain.WeightTare6:=DataSet.FieldByName('Weight').asFloat;
                LabelTare6.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare6)+' кг';
                SettingMain.TareId_6:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 7 then
            begin
                SettingMain.WeightTare7:=DataSet.FieldByName('Weight').asFloat;
                LabelTare7.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare7)+' кг';
                SettingMain.TareId_7:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 8 then
            begin
                SettingMain.WeightTare8:=DataSet.FieldByName('Weight').asFloat;
                LabelTare8.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare8)+' кг';
                SettingMain.TareId_8:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 9 then
            begin
                SettingMain.WeightTare9:=DataSet.FieldByName('Weight').asFloat;
                LabelTare9.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare9)+' кг';
                SettingMain.TareId_9:=DataSet.FieldByName('GuideId').asInteger;
            end;
            if DataSet.FieldByName('NPP').asInteger = 10 then
            begin
                SettingMain.WeightTare10:=DataSet.FieldByName('Weight').asFloat;
                LabelTare10.Caption:=DataSet.FieldByName('GuideName').asString + ' '+FloatToStr(SettingMain.WeightTare10)+' кг';
                SettingMain.TareId_10:=DataSet.FieldByName('GuideId').asInteger;
            end;
            //
            DataSet.Next;
       end;
  end;
end;

{------------------------------------------------------------------------------}
function TDialogTareForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
