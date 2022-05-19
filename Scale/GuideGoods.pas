unit GuideGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit,cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, dsdAddOn, Vcl.ActnList, dsdAction
 ,UtilScale,DataModul, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
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
  TGuideGoodsForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    infoPanelTare: TPanel;
    rgTareWeight: TRadioGroup;
    infoPanelPriceList: TPanel;
    rgPriceList: TRadioGroup;
    PanelTare: TPanel;
    gbTareCount: TGroupBox;
    EditTareCount: TEdit;
    gbTareWeightCode: TGroupBox;
    EditTareWeightCode: TEdit;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    DS: TDataSource;
    infoPanelGoods: TPanel;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsWieghtValue: TGroupBox;
    PanelGoodsWieghtValue: TPanel;
    infoPanelChangePercentAmount: TPanel;
    rgChangePercentAmount: TRadioGroup;
    gbChangePercentAmountCode: TGroupBox;
    EditChangePercentAmountCode: TEdit;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbSave: TSpeedButton;
    infoPanelGoodsKind: TPanel;
    rgGoodsKind: TRadioGroup;
    gbGoodsKindCode: TGroupBox;
    EditGoodsKindCode: TEdit;
    gbTareWeightEnter: TGroupBox;
    EditTareWeightEnter: TEdit;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbWeightValue: TGroupBox;
    EditWeightValue: TcxCurrencyEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Price_Return: TcxGridDBColumn;
    Amount_OrderWeight: TcxGridDBColumn;
    Amount_WeighingWeight: TcxGridDBColumn;
    Amount_diffWeight: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    Color_calc: TcxGridDBColumn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    actSave: TAction;
    Amount_Order: TcxGridDBColumn;
    Amount_Weighing: TcxGridDBColumn;
    Amount_diff: TcxGridDBColumn;
    isPromo: TcxGridDBColumn;
    GoodsKindName_max: TcxGridDBColumn;
    GoodsKindId_list: TcxGridDBColumn;
    gbPrice: TGroupBox;
    EditPrice: TcxCurrencyEdit;
    Weight: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    CountForWeight: TcxGridDBColumn;
    bbSaveDialog: TSpeedButton;
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
    Amount_Remains: TcxGridDBColumn;
    bbGoodsRemains: TSpeedButton;
    isPartionGoods_20103: TcxGridDBColumn;
    gbPartionGoods_20103: TGroupBox;
    EditPartionGoods_20103: TcxCurrencyEdit;
    Price_Income: TcxGridDBColumn;
    gbPriceIncome: TGroupBox;
    EditPriceIncome: TcxCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure EditGoodsNameExit(Sender: TObject);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditTareCountKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareCountExit(Sender: TObject);
    procedure EditTareWeightCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightCodeExit(Sender: TObject);
    procedure EditChangePercentAmountCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditChangePercentAmountCodeExit(Sender: TObject);
    procedure EditTareWeightCodeChange(Sender: TObject);
    procedure EditChangePercentAmountCodeChange(Sender: TObject);
    procedure EditPriceListCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure EditPriceListCodeChange(Sender: TObject);
    procedure rgTareWeightClick(Sender: TObject);
    procedure rgChangePercentAmountClick(Sender: TObject);
    procedure rgPriceListClick(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure EditTareCountEnter(Sender: TObject);
    procedure rgGoodsKindClick(Sender: TObject);
    procedure EditGoodsKindCodeChange(Sender: TObject);
    procedure EditGoodsKindCodeExit(Sender: TObject);
    procedure EditGoodsKindCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightEnterExit(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure EditWeightValueExit(Sender: TObject);
    procedure EditWeightValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure EditPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bbSaveDialogClick(Sender: TObject);
    procedure EditTare1PropertiesChange(Sender: TObject);
    procedure EditTare1Exit(Sender: TObject);
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
    procedure EditTare0KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bbGoodsRemainsClick(Sender: TObject);
  private
    oldParam1, oldParam2:Integer;
    fCloseOK : Boolean;
    fModeSave : Boolean;
    fStartWrite : Boolean;
    fChoicePartionGoods_20103: Boolean;
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;
    fEnterGoodsKindCode:Boolean;

    GoodsCode_FilterValue:String;
    GoodsName_FilterValue:String;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
    procedure InitializePriceList(execParams:TParams);
  public
    //GoodsWeight:Double;
    function Execute (execParamsMovement : TParams; isModeSave, isDialog : Boolean) : Boolean;
  end;

var
  GuideGoodsForm: TGuideGoodsForm;

implementation
{$R *.dfm}
uses dmMainScale, Main, DialogWeight, DialogStringValue, GuideGoodsRemains;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Execute (execParamsMovement : TParams; isModeSave, isDialog : Boolean) : Boolean;
begin
     fModeSave:= isModeSave;
     fCloseOK:=false;
     fChoicePartionGoods_20103:= false;
     //
     bbGoodsRemains.Visible:= (SettingMain.isPartionGoods_20103 = TRUE) AND (execParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Income);
     gbPartionGoods_20103.Visible:= (SettingMain.isPartionGoods_20103 = TRUE);
     EditPartionGoods_20103.Text:= ParamsMI.ParamByName('PartionGoods').AsString;
     //
     bbSaveDialog.Visible:= isModeSave
                        and (ParamsMovement.ParamByName('OrderExternalId').asInteger > 0)
                        and (SettingMain.BranchCode >= 301)
                        and (SettingMain.BranchCode <= 310)
                           ;
     //
     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     fEnterGoodsKindCode:=false;

     gbPrice.Visible:=(GetArrayList_Value_byName(Default_Array,'isEnterPrice') = AnsiUpperCase('TRUE'))
                  and (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income);
     if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then EditWeightValue.Properties.DecimalPlaces:= 4;
     //
     gbPriceIncome.Visible:= gbPrice.Visible;
     EditPriceIncome.Text:='0';

     CancelCxFilter;
     fStartWrite:=true;

     if execParamsMovement.ParamByName('OrderExternalId').AsInteger<>0 then
     with spSelect do
     begin
       oldParam1:=-1;
       oldParam2:=-1;
       //
       Self.Caption:='Параметры продукции на основании '+execParamsMovement.ParamByName('OrderExternalName_master').asString;
       if isModeSave = FALSE then Self.Caption:= 'БЕЗ СОХРАНЕНИЯ: ' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= execParamsMovement.ParamByName('OrderExternalId').AsInteger;
       Params.ParamByName('inMovementId').Value     := execParamsMovement.ParamByName('MovementId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else
     if execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn then
     with spSelect do
     begin
       oldParam1:=-1;
       oldParam2:=-1;
       //
       Self.Caption:='Параметры продукции для покупателя <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
       if isModeSave = FALSE then Self.Caption:= 'БЕЗ СОХРАНЕНИЯ' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= -1 * execParamsMovement.ParamByName('ContractId').AsInteger;
       Params.ParamByName('inMovementId').Value     := -1 * execParamsMovement.ParamByName('FromId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else
     if (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
     and(((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 301))
      or (execParamsMovement.ParamByName('isContractGoods').AsBoolean = TRUE)
        )
   //and (1=0)
     then
     with spSelect do
     begin
       if ((oldParam1 <> execParamsMovement.ParamByName('ContractId').AsInteger)
       or (oldParam2 <> execParamsMovement.ParamByName('FromId').AsInteger))
       then begin
             oldParam1:= execParamsMovement.ParamByName('ContractId').AsInteger;
             oldParam2:= execParamsMovement.ParamByName('FromId').AsInteger;
             //
             Self.Caption:='Параметры продукции для поставщика <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
             if isModeSave = FALSE then Self.Caption:= 'БЕЗ СОХРАНЕНИЯ' + Self.Caption;
             Params.ParamByName('inOrderExternalId').Value:= -1 * execParamsMovement.ParamByName('ContractId').AsInteger;
             Params.ParamByName('inMovementId').Value     := -1 * execParamsMovement.ParamByName('FromId').AsInteger;
             Params.ParamByName('inGoodsCode').Value      := 0;
             Params.ParamByName('inGoodsName').Value      := '';
             Execute;
       end;
     end
     else
     if (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
     and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
     and (1=0)
     then
     with spSelect do
     begin
       oldParam1:=-1;
       oldParam2:=-1;
       //
       Self.Caption:='Параметры продукции по заявке на <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
       if isModeSave = FALSE then Self.Caption:= 'БЕЗ СОХРАНЕНИЯ' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= 0;
       Params.ParamByName('inMovementId').Value     := 0;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else begin
           oldParam1:=-1;
           oldParam2:=-1;
           //
           if isModeSave = FALSE then Self.Caption:= 'БЕЗ СОХРАНЕНИЯ - Параметры продукции'
           else Self.Caption:= 'Параметры продукции';
     end;
     ;

  // Показали вес с весов - получили его перед открытием
  PanelGoodsWieghtValue.Caption:=FloatToStr(ParamsMI.ParamByName('RealWeight_Get').AsFloat);

  InitializeGoodsKind(execParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
  InitializePriceList(execParamsMovement);
  //
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Visible:= rgGoodsKind.Items.Count > 1; // (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)or(execParamsMovement.ParamByName('OrderExternalId').AsInteger<>0);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName_max').Index].VisibleForCustomization:= (rgGoodsKind.Items.Count > 1) and (execParamsMovement.ParamByName('OrderExternalId').AsInteger = 0);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindId_list').Index].VisibleForCustomization:= (rgGoodsKind.Items.Count > 1) and (execParamsMovement.ParamByName('OrderExternalId').AsInteger = 0);
  //
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Weight').Index].Visible                        := ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare').Index].VisibleForCustomization    := ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountForWeight').Index].VisibleForCustomization:= ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  //
  if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then
  begin
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isPromo').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price_Return').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_OrderWeight').Index].Caption:= 'Заявка (кол-во)';
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_diffWeight').Index].Caption:= 'Разница (кол-во)';
       if execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income then
       begin
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_Weighing').Index].Caption:= 'Приход';
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_WeighingWeight').Index].Caption:= 'Приход (кол-во)';
       end
       else begin
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_Weighing').Index].Caption:= 'Расход';
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_WeighingWeight').Index].Caption:= 'Расход (кол-во)';
       end;
  end;
  //
  EditTare1.Text:='';PanelWeightTare1.Caption:='';
  EditTare2.Text:='';PanelWeightTare2.Caption:='';
  EditTare3.Text:='';PanelWeightTare3.Caption:='';
  EditTare4.Text:='';PanelWeightTare4.Caption:='';
  EditTare5.Text:='';PanelWeightTare5.Caption:='';
  EditTare6.Text:='';PanelWeightTare6.Caption:='';
  EditTare0.Text:='';PanelWeightTare0.Caption:='';
  //
  if ParamsMI.ParamByName('GoodsId').AsInteger<>0
  then begin
            CDS.Filter:='GoodsId = '+ParamsMI.ParamByName('GoodsId').AsString;
            if (execParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
               and (rgGoodsKind.Items.Count>1)
            then CDS.Filter:= CDS.Filter +' and GoodsKindId = '+IntToStr(ParamsMI.ParamByName('GoodsKindId').AsInteger)
                                         //+'   or GoodsKindId = 0)'
                                         ;

            CDS.Filtered:=false;
            CDS.Filtered:=true;

            EditGoodsCode.Text:=ParamsMI.ParamByName('GoodsCode').AsString;
            EditGoodsName.Text:='';
            EditTareWeightEnter.Text:='';

            EditWeightValue.Text:=FloatToStr(ParamsMI.ParamByName('Amount_Goods').asFloat);
            EditPrice.Text:='0';

            if (CDS.RecordCount=1)
             and((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
              or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                )
            then EditTareCount.Text:= '0'
            else EditTareCount.Text:= GetArrayList_Value_byName(Default_Array,'TareCount');

            EditTareWeightCode.Text:= IntToStr(TareWeight_Array[GetArrayList_Index_byNumber(TareWeight_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'TareWeightNumber')))].Code);
            EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,execParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);
            EditPriceListCode.Text:=  IntToStr(PriceList_Array[GetArrayList_Index_byNumber(PriceList_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'PriceListNumber')))].Code);

            if rgGoodsKind.Items.Count>1
            then begin EditGoodsKindCode.Text:=ParamsMI.ParamByName('GoodsKindCode').AsString;
                       rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,execParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,ParamsMI.ParamByName('GoodsKindCode').AsInteger);
                 end;

            {if (CDS.RecordCount=1)
            then begin
                      EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
                      ActiveControl:=EditTareCount;
            end;}

            if (CDS.RecordCount<>1) then ActiveControl:=EditGoodsCode
            else if  (ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
                  and(CDS.FieldByName('Weight').AsFloat > 0)
                  and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                 then
                      if infoPanelTareFix.Visible
                      then ActiveControl:=EditTare1
                      else ActiveControl:=EditTareCount
                 else
                      if ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                     //or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                       or (SettingMain.isCalc_sht = FALSE)
                       or (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh)
                         )
                      then ActiveControl:=EditWeightValue
                      else if infoPanelTareFix.Visible
                           then ActiveControl:=EditTare1
                           else ActiveControl:=EditTareCount
  end
  else begin
            EditGoodsCode.Text:='';
            EditGoodsName.Text:='';
            EditGoodsKindCode.Text:='';
            EditTareWeightEnter.Text:='';

            EditWeightValue.Text:='0';
            EditPrice.Text:='0';

            EditTareCount.Text:=         GetArrayList_Value_byName(Default_Array,'TareCount');
            EditTareWeightCode.Text:=    IntToStr(TareWeight_Array[GetArrayList_Index_byNumber(TareWeight_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'TareWeightNumber')))].Code);
            EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,execParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code); //IntToStr(ChangePercent_Array[GetArrayList_Index_byNumber(ChangePercent_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'ChangePercentNumber')))].Code);
            EditPriceListCode.Text:=     IntToStr(PriceList_Array[GetArrayList_Index_byNumber(PriceList_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'PriceListNumber')))].Code);

            //InitializeGoodsKind(execParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
            //InitializePriceList(execParamsMovement);

            CDS.Filter:='';
            CDS.Filtered:=false;
            if execParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
            ActiveControl:=EditGoodsCode;
  end;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;
     fStartWrite:=false;

     if isDialog = false then result:=ShowModal=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
var i:Integer;
begin
     EditGoodsKindCode.Text:='';
     with rgGoodsKind do
     begin
          Items.Clear;
          i:=0;
          if GoodsKindWeighingGroupId = 0
          then begin Items.Add('(1) нет'); ItemIndex:=0;EditGoodsKindCode.Text:='1';end
          else
              for i:=0 to Length(GoodsKind_Array)-1 do
                 if GoodsKind_Array[i].Number = GoodsKindWeighingGroupId
                 then Items.Add('('+IntToStr(GoodsKind_Array[i].Code)+') '+ GoodsKind_Array[i].Name);

          if i<10 then Columns:=1 else Columns:=2;

     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializePriceList(execParams:TParams);
var i:Integer;
begin
     with rgPriceList do
     begin
          Items.Clear;
          if execParams.ParamByName('PriceListId').AsInteger=0
          then Items.Add('нет значения')
          else Items.Add('('+IntToStr(execParams.ParamByName('PriceListCode').AsInteger)+') '+ execParams.ParamByName('PriceListName').AsString);
          EditPriceListCode.Text:=IntToStr(execParams.ParamByName('PriceListCode').AsInteger);
          rgPriceList.ItemIndex:=0;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var findTareCode:Integer;
begin
    if (Key=VK_F2)and bbSaveDialog.Visible then
    begin
         bbSaveDialogClick(Self);
         exit;
    end;
    //
    if Key=13 then
    begin
      if (ActiveControl=EditGoodsCode) then EditGoodsCodeExit(EditGoodsCode);
      if (ActiveControl=EditGoodsName)and(trim (EditGoodsName.Text) <> '')
      and((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
      and (CDS.RecordCount=0)
      then begin
                spSelect.Params.ParamByName('inGoodsCode').Value:= 0;
                spSelect.Params.ParamByName('inGoodsName').Value:= trim(EditGoodsName.Text);
                spSelect.Params.ParamByName('inOrderExternalId').Value:= 0;
                spSelect.Params.ParamByName('inMovementId').Value     := 0;
                actRefreshExecute(Self);
      end;

      if (ActiveControl=EditGoodsCode)and(CDS.RecordCount=1)
      then if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
           and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
           and(CDS.FieldByName('Weight').AsFloat > 0)
           and(SettingMain.isCalc_sht = TRUE)
           then if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
                then ActiveControl:=EditPrice
                else
                if rgGoodsKind.Items.Count > 1
                then ActiveControl:=EditGoodsKindCode
                else
                     if infoPanelTareFix.Visible
                     then ActiveControl:=EditTare1
                     else ActiveControl:=EditTareCount
           else
                if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                 and(SettingMain.isCalc_sht = FALSE))
                then ActiveControl:=EditWeightValue
                else if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
                     then ActiveControl:=EditPrice
                     else if rgGoodsKind.Items.Count > 1
                          then ActiveControl:=EditGoodsKindCode
                          else
                              if infoPanelTareFix.Visible
                              then ActiveControl:=EditTare1
                              else ActiveControl:=EditTareCount
      else
      if (ActiveControl=EditWeightValue)or(ActiveControl=EditPrice)
      then if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
           then ActiveControl:=EditPrice
           else if rgGoodsKind.Items.Count > 1
                then ActiveControl:=EditGoodsKindCode
                else
                     if infoPanelTareFix.Visible
                     then ActiveControl:=EditTare1
                     else ActiveControl:=EditTareCount

      else if (ActiveControl=EditGoodsCode)
           then if (Length(trim(EditGoodsCode.Text))>0)and(CDS.RecordCount>=1)
                then if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                     and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
                     and(CDS.FieldByName('Weight').AsFloat > 0)
                     then if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
                          then ActiveControl:=EditPrice
                          else
                          if rgGoodsKind.Items.Count > 1
                          then ActiveControl:=EditGoodsKindCode
                          else
                               if infoPanelTareFix.Visible
                               then ActiveControl:=EditTare1
                               else ActiveControl:=EditTareCount
                     else
                          if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                          or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                          then ActiveControl:=EditWeightValue
                          else if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
                               then ActiveControl:=EditPrice
                               else
                               if rgGoodsKind.Items.Count > 1
                               then ActiveControl:=EditGoodsKindCode
                               else
                                    if infoPanelTareFix.Visible
                                    then ActiveControl:=EditTare1
                                    else ActiveControl:=EditTareCount
                else ActiveControl:=EditGoodsName

           else if (ActiveControl=EditGoodsName)and(CDS.RecordCount=1)
                then if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                     and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
                     and(CDS.FieldByName('Weight').AsFloat > 0)
                     then if rgGoodsKind.Items.Count > 1
                          then ActiveControl:=EditGoodsKindCode
                          else
                               if infoPanelTareFix.Visible
                               then ActiveControl:=EditTare1
                               else ActiveControl:=EditTareCount
                     else
                          if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                          or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                           and(SettingMain.isCalc_sht = FALSE))
                          then ActiveControl:=EditWeightValue
                          else if rgGoodsKind.Items.Count > 1
                               then ActiveControl:=EditGoodsKindCode
                               else
                                    if infoPanelTareFix.Visible
                                    then ActiveControl:=EditTare1
                                    else ActiveControl:=EditTareCount

                else if (ActiveControl=EditGoodsName)
                     then if CDS.RecordCount>1 then ActiveControl:=cxDBGrid else ActiveControl:=EditGoodsCode
                     else if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
                          then actChoiceExecute(cxDBGrid)

      else if ActiveControl=EditGoodsKindCode then if infoPanelTareFix.Visible
                                                   then ActiveControl:=EditTare1
                                                   else ActiveControl:=EditTareCount
           else if ActiveControl=EditTareCount then ActiveControl:=EditTareWeightCode
                else
                     if ActiveControl=EditTare1 then
                     if infoPanelTare2.Visible then ActiveControl:=EditTare2
                     else if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare2 then
                          if infoPanelTare3.Visible then ActiveControl:=EditTare3
                          else if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare3 then
                          if infoPanelTare4.Visible then ActiveControl:=EditTare4
                          else if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare4 then
                          if infoPanelTare5.Visible then ActiveControl:=EditTare5
                          else if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare5 then
                          if infoPanelTare6.Visible then ActiveControl:=EditTare6
                          else if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare6 then
                          if infoPanelTare0.Visible then ActiveControl:=EditTare0 else ActiveControl:=EditChangePercentAmountCode

                     else if ActiveControl=EditTare0
                          then ActiveControl:=EditChangePercentAmountCode

                else if ActiveControl=EditTareWeightCode then if (rgTareWeight.ItemIndex=rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
                                                        then ActiveControl:=EditTareWeightEnter
                                                        else ActiveControl:=EditChangePercentAmountCode
                     else if ActiveControl=EditTareWeightEnter then ActiveControl:=EditChangePercentAmountCode
                          else if ActiveControl=EditChangePercentAmountCode then actSaveExecute(Self) //ActiveControl:=EditPriceListCode
                               else if ActiveControl=EditPriceListCode then actSaveExecute(Self);
    end;
    //
    {if Key=32 then
      if ActiveControl=EditGoodsCode then ActiveControl:=EditGoodsName
      else if ActiveControl=EditGoodsName then ActiveControl:=EditGoodsCode;}
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
           then actExitExecute(Self)
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('Для отмены взвешивания необходимо ввести пароль.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('Пароль неверный.Отменить взвешивание нельзя.');exit;end
                     else begin fCloseOK:= true; actExitExecute(Self); end;
                end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
var
   GoodsKindCode:Integer;
begin
     if rgGoodsKind.Items.Count=1
     then GoodsKindCode:=0
     else if (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)and(trim(EditGoodsKindCode.Text)<>'')
          then try GoodsKindCode:=StrToInt(EditGoodsKindCode.Text) except GoodsKindCode:=0;end
          else GoodsKindCode:=0;
     //
     //
     if fEnterGoodsCode
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     else
         if (fEnterGoodsKindCode)and(trim(GoodsCode_FilterValue)<>'')
         then
             if  (GoodsCode_FilterValue=DataSet.FieldByName('GoodsCode').AsString)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         //else if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         ;
     //
     //if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     //
     if fEnterGoodsName
     then

       //if (AnsiUpperCase(EditGoodsName.Text) = AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))
       // and (fGoodsName_equal)

       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     else
         if (fEnterGoodsKindCode)and(trim(GoodsName_FilterValue)<>'')
         then
             if  (pos(AnsiUpperCase(GoodsName_FilterValue),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         //else if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         ;

     if (trim(EditGoodsCode.Text) = '') and (trim(EditGoodsName.Text) = '') and (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
     then if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false

end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Checked: boolean; //Проверка корректного ввода в Edit
var WeightReal_check:Double;
begin
     Result:=(CDS.RecordCount=1)
          and(rgGoodsKind.ItemIndex>=0)
          and(rgTareWeight.ItemIndex>=0)
          and(rgChangePercentAmount.ItemIndex>=0)
          and(rgPriceList.ItemIndex>=0)
          and(ParamsMI.ParamByName('RealWeight').AsFloat>0.0001)
          ;
     //
     if fModeSave = FALSE then
     begin
          Result:= false;
          ShowMessage ('Ошибка.Окно открыто в режиме <Только просмотр>.');
          exit;
     end;
     //
     if not Result
     then ActiveControl:=EditGoodsCode
     else
     with ParamsMI do begin
        ParamByName('GoodsId').AsInteger:=CDS.FieldByName('GoodsId').AsInteger;
        if rgGoodsKind.Items.Count > 1
        then ParamByName('GoodsKindId').AsInteger:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id
        else ParamByName('GoodsKindId').AsInteger:= 0;

        ParamByName('MovementId_Promo').AsInteger:=CDS.FieldByName('MovementId_Promo').AsInteger;

        ParamByName('Price').AsFloat:=CDS.FieldByName('Price').AsFloat;
        ParamByName('Price_Return').AsFloat:=CDS.FieldByName('Price_Return').AsFloat;
        ParamByName('CountForPrice').AsFloat:= CDS.FieldByName('CountForPrice').AsFloat;
        ParamByName('CountForPrice_Return').AsFloat:= CDS.FieldByName('CountForPrice_Return').AsFloat;

        // Количество тары
        try ParamByName('CountTare').AsFloat:=StrToFloat(EditTareCount.Text);
        except ParamByName('CountTare').AsFloat:=0;
        end;
        // Вес 1-ой тары - Fix
        if infoPanelTare0.Visible then
        begin
               try ParamsMI.ParamByName('WeightTare').AsFloat:=StrToFloat(EditTare0.Text);
               except ParamsMI.ParamByName('WeightTare').AsFloat:=0;
               end;
               //change Количество тары
               ParamsMI.ParamByName('CountTare').AsFloat:=1;
        end
        // Вес 1-ой тары
        else
        if  (GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE'))
         and(gbTareWeightEnter.Visible)
         and(rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)
        then begin
            try ParamByName('WeightTare').AsFloat:=StrToFloat(EditTareWeightEnter.Text);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
            //change Количество тары
            if (ParamByName('WeightTare').AsFloat<>0) and (ParamByName('CountTare').AsFloat=0)
            then ParamByName('CountTare').AsFloat:=1;
        end
        else
            try ParamByName('WeightTare').AsFloat:=myStrToFloat(TareWeight_Array[rgTareWeight.ItemIndex].Value);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
       // % скидки для кол-ва
       if (CDS.FieldByName('ChangePercentAmount').AsFloat <> 0) and (SettingMain.isGoodsComplete = FALSE) and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Sale)
       then if GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat)) < 0
            then begin
                 ShowMessage('Ошибка.У вас нет в настройках такого % скидки вес = <'+FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat)+'>');
                 Result:=false;
                 exit;
            end
            else
                  EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
       else if (SettingMain.isGoodsComplete = FALSE) and (ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
            then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,'0')].Code)
            else if (CDS.FieldByName('ChangePercentAmount').AsFloat = 0) and (SettingMain.isGoodsComplete = TRUE)
                 then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
                 else EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);

       try ParamByName('ChangePercentAmount').AsFloat:=myStrToFloat(ChangePercentAmount_Array[rgChangePercentAmount.ItemIndex].Value);
       except ParamByName('ChangePercentAmount').AsFloat:=0;
       end;

       //ПРОВЕРКА - Количество (склад) с учетом тары
       Result:=(ParamByName('RealWeight').AsFloat-ParamByName('CountTare').AsFloat*ParamByName('WeightTare').AsFloat)>0;
       if not Result then
       begin
            ShowMessage('Ошибка.Количество за минусом тары не может быть меньше 0.');
            exit;
       end;

       //ПРОВЕРКА - Ввод ЦЕНА
       if gbPrice.Visible then
       begin
            //
            if ((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
              or(ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut))
              and (CDS.FieldByName('Price_Income').AsFloat > 0)
            then begin
                  //EditPrice.Text:= FloatToStr(CDS.FieldByName('Price_Income').AsFloat);
            end;
            //!!!Криво - передаем цену через этот параметр!!!
            try ParamsMI.ParamByName('BoxCount').AsFloat:= StrToFloat(EditPrice.Text);
            except
                  ParamsMI.ParamByName('BoxCount').AsFloat:= 0;
            end;
            if (ParamsMI.ParamByName('BoxCount').AsFloat <=0) and (CDS.FieldByName('isNotPriceIncome').AsBoolean = FALSE)
            then begin
                     ShowMessage('Ошибка.ЦЕНА не может быть <= 0.');
                     exit;
            end;
            //
            if ((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
              or(ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut))
              and (CDS.FieldByName('Price_Income').AsFloat > 0)
              and (CDS.FieldByName('Price_Income').AsFloat <> ParamsMI.ParamByName('BoxCount').AsFloat)
            then begin
                     Result:= false;
                     ShowMessage('Ошибка.ЦЕНА не соответствует цене в спецификации = <'+FloatToStr(CDS.FieldByName('Price_Income').AsFloat)+'>.');
                     exit;
            end;
       end;
     end;
     //
     //Save MI
     if Result = TRUE then
     begin
          //если не ШТ, проверка стабильности - т.е. вес такой же как и был
          if (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
         and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
          then begin
                    //получили еще раз
                    WeightReal_check:=MainForm.fGetScale_CurrentWeight;
                    //если вдруг погрешность больше 0.002
                    if abs(WeightReal_check-ParamsMI.ParamByName('RealWeight').AsFloat)> SettingMain.Exception_WeightDiff
                    then
                        with DialogWeightForm do
                        begin
                             rgWeight.Items.Add(FloatToStr(ParamsMI.ParamByName('RealWeight').AsFloat)+' кг');
                             rgWeight.Items.Add(FloatToStr(WeightReal_check)+' кг');
                             rgWeight.ItemIndex:=1;
                             if Execute then
                               if rgWeight.ItemIndex=1
                               then begin
                                         //ПРОВЕРКА WeightReal_check - Количество (склад) с учетом тары
                                         Result:=(WeightReal_check-ParamsMI.ParamByName('CountTare').AsFloat*ParamsMI.ParamByName('WeightTare').AsFloat)>0;
                                         if not Result then
                                         begin
                                              ShowMessage('Ошибка.Количество за минусом тары не может быть меньше 0.');
                                              exit;
                                         end;
                                         //!!!меняется на новый "стабильный" вес!!!
                                         ParamsMI.ParamByName('RealWeight').AsFloat:=WeightReal_check;
                                    end
                                else // ничего не делаем, остался 1-ый выриант
                             else begin Result:=FALSE; exit;end; // из двух вариантов ничего не выбрали, остаемся в форме
                        end;
          end;
          //сохранение MovementItem
          Result:=DMMainScaleForm.gpInsert_Scale_MI(ParamsMovement,ParamsMI);
          if not Result then ShowMessage('Error.not Result');
          if ParamsMovement.ParamByName('MessageText').AsString <> ''
          then begin
                   Result:= false;
                   if MessageDlg(ParamsMovement.ParamByName('MessageText').AsString
                               + #10 + #13
                               + 'Выполнить подбор остатка?'
                                ,mtConfirmation,mbYesNoCancel,0) <> 6
                   then exit
                   else bbGoodsRemainsClick(Self);
               end
          else Result:= true;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeChange(Sender: TObject);
begin
     fChoicePartionGoods_20103:= false;
     //
     if fEnterGoodsCode then
       with CDS do begin
           Filtered:=false;
           if trim(EditGoodsCode.Text)<>'' then Filtered:=true
           else if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;//!!!
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeEnter(Sender: TObject);
begin
      fChoicePartionGoods_20103:= false;
      //
      TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      CDS.Filtered:=false;
      if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeExit(Sender: TObject);
var Code_begin:Integer;
begin
      if fStartWrite=true then exit;

      try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;

     {try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
         if (ActiveControl<>EditGoodsName)and((Code_begin<=0)or(Code_begin<>CDS.FieldByName('GoodsCode').AsInteger))
         then ActiveControl:=EditGoodsCode;}
     //
     if (CDS.Filtered=false)and(Length(trim(EditGoodsCode.Text))>0)
     then begin fEnterGoodsCode:=true;CDS.Filtered:=true;end;

     if  (SettingMain.isGoodsComplete = FALSE){(CDS.RecordCount=0}
      and((ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
       or ((CDS.RecordCount=0)and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
         )
      and(Code_begin>0)
     then begin spSelect.Params.ParamByName('inGoodsCode').Value:=Code_begin;
                spSelect.Params.ParamByName('inGoodsName').Value:='';
                spSelect.Params.ParamByName('inOrderExternalId').Value:= 0;
                spSelect.Params.ParamByName('inMovementId').Value     := 0;
                actRefreshExecute(Self);
                fEnterGoodsCode:=true;CDS.Filtered:=False;CDS.Filtered:=True;
     end;


     if (CDS.RecordCount=0)and(trim(EditGoodsCode.Text)<>'')
     then if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
          then begin fEnterGoodsCode:=false;
                     GoodsCode_FilterValue:=EditGoodsCode.Text;
                     GoodsName_FilterValue:='';
               end
          else ActiveControl:=EditGoodsCode
     else begin fEnterGoodsCode:=false;
                GoodsCode_FilterValue:=EditGoodsCode.Text;
                GoodsName_FilterValue:='';
          end;

     if  (CDS.RecordCount>0)and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
      and(Code_begin>0)and (CDS.FieldByName('isPartionGoods_20103').AsBoolean = TRUE)
     then begin bbGoodsRemainsClick(self);
                fChoicePartionGoods_20103:= true;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';

          GoodsCode_FilterValue:=EditGoodsCode.Text;
          GoodsName_FilterValue:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameChange(Sender: TObject);
var Code_begin:String;
begin
     fChoicePartionGoods_20103:= false;
     //
     if fEnterGoodsName then
       with CDS do begin
           Code_begin:= FieldByName('GoodsCode').AsString;
           Filtered:=false;
           if trim(EditGoodsName.Text)<>'' then Filtered:=true
           else if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;//!!!
           if Code_begin <> '' then Locate('GoodsCode',Code_begin,[loCaseInsensitive,loPartialKey]);
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameEnter(Sender: TObject);
var Code_begin:String;
begin
  fChoicePartionGoods_20103:= false;
  //
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  CDS.Filtered:=false;
  if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameExit(Sender: TObject);
var Code_begin:Integer;
begin
     if fStartWrite=true then exit;

     {Code_begin:=CDS.FieldByName('GoodsCode').AsInteger;
     //
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
        if (Code_begin<=0)and(CDS.RecordCount<=1) then ActiveControl:=EditGoodsName
        else if (Code_begin>0)and(CDS.RecordCount=1) then EditGoodsCode.Text:=IntToStr(Code_begin);}

     if (CDS.Filtered=false)and(Length(trim(EditGoodsName.Text))>0)
     then begin fEnterGoodsName:=true;CDS.Filtered:=true;end;

     if CDS.RecordCount=0
     then if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
          then begin fEnterGoodsName:=false;
                     GoodsCode_FilterValue:='';
                     GoodsName_FilterValue:=EditGoodsName.Text;
               end
          else ActiveControl:=EditGoodsName
     else begin fEnterGoodsName:=false;
                GoodsCode_FilterValue:='';
                GoodsName_FilterValue:=EditGoodsName.Text;
          end;
     //
     if  (CDS.RecordCount>0)and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
      and (Length(trim(EditGoodsName.Text))>0)and(CDS.FieldByName('isPartionGoods_20103').AsBoolean = TRUE)
     then begin bbGoodsRemainsClick(self);
                fChoicePartionGoods_20103:= true;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';

          GoodsCode_FilterValue:='';
          GoodsName_FilterValue:=EditGoodsName.Text;
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueExit(Sender: TObject);
begin
     //
     if ((ActiveControl=EditPrice)and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
       or(ActiveControl=EditPrice)and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut)
        )
       and (CDS.FieldByName('Price_Income').AsFloat > 0)
     then begin
           //EditPrice.Text:= FloatToStr(CDS.FieldByName('Price_Income').AsFloat);
     end;
     //
     if ((CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
     and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
        )
      or((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
      and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
      and(CDS.FieldByName('Weight').AsFloat > 0)
      and(CDS.RecordCount = 1)
      and(ActiveControl<>EditWeightValue)
        )
     then exit;
     //
     if (trim(EditGoodsCode.Text) = '')
     and(trim(EditGoodsName.Text) = '')
     then begin ActiveControl:=EditGoodsCode; exit;end;
     //
     try StrToFloat(EditWeightValue.Text)
     except ActiveControl:=EditWeightValue;
            exit;
     end;
     if StrToFloat(EditWeightValue.Text)<=0
     then ActiveControl:=EditWeightValue
     else if CDS.RecordCount=1
          then try ParamsMI.ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text);
          except ParamsMI.ParamByName('RealWeight').AsFloat:=0;end;

     if gbPrice.Visible = TRUE
     then begin
               try StrToFloat(EditPrice.Text)
               except ActiveControl:=EditPrice;
                      exit;
               end;
               //
               if (StrToFloat(EditPrice.Text) <= 0) and (CDS.FieldByName('isNotPriceIncome').AsBoolean = FALSE)
               then ActiveControl:=EditPrice
     end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then if (gbPrice.Visible = TRUE)
         then ActiveControl:=EditPrice
         else if rgGoodsKind.Items.Count>1
              then ActiveControl:=EditGoodsKindCode
              else if infoPanelTareFix.Visible
                   then ActiveControl:=EditTare1
                   else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key=13
    then if rgGoodsKind.Items.Count>1
    then ActiveControl:=EditGoodsKindCode
    else if infoPanelTareFix.Visible
         then ActiveControl:=EditTare1
         else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare2.Visible then ActiveControl:=EditTare2
     else if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare3.Visible then ActiveControl:=EditTare3
     else if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare4.Visible then ActiveControl:=EditTare4
     else if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare5.Visible then ActiveControl:=EditTare5
     else if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare6.Visible then ActiveControl:=EditTare6
     else if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     if infoPanelTare0.Visible then ActiveControl:=EditTare0
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare0KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13
    then
     ActiveControl:=EditChangePercentAmountCode
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     if (fStartWrite=true) then exit;

     if rgGoodsKind.Items.Count>1
     then begin
         if trim(EditGoodsKindCode.Text)<>''
         then try Code_begin:=StrToInt(EditGoodsKindCode.Text) except Code_begin:=-1;end else Code_begin:=-1;

         if (Code_begin<=0)
         then rgGoodsKind.ItemIndex:=-1
         else rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,Code_begin);
     end
     else EditGoodsKindCode.Text:='1';

    if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
    then begin CDS.Filtered:=false;CDS.Filtered:=true;end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeExit(Sender: TObject);
var GoodsKindId_check:Integer;
begin
      if (fStartWrite=true)or(ActiveControl=EditGoodsCode)or(ActiveControl=EditGoodsName)
       or(ActiveControl=cxDBGrid)or(ActiveControl=rgGoodsKind)or(ActiveControl.Name='')
      then exit;
//Focused
      if (rgGoodsKind.ItemIndex=-1)and (rgGoodsKind.Items.Count>1)
      then begin ShowMessage('Ошибка.Не определено значение <Код вида упаковки>.');
                 ActiveControl:=EditGoodsKindCode;
           end
      else
        if CDS.RecordCount<>1
        then if (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0) and (rgGoodsKind.Items.Count>1)
             then begin
                       ShowMessage('Ошибка.Не определено значение <Код вида упаковки>.');
                       ActiveControl:=EditGoodsKindCode;
                  end
             else begin
                       ShowMessage('Ошибка.Не выбран <Код товара>.');
                       ActiveControl:=EditGoodsCode;
                  end
        else if ParamsMI.ParamByName('RealWeight').AsFloat<=0.0001
             then
                  if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                  and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
                  and(CDS.FieldByName('Weight').AsFloat > 0)
                  then begin ShowMessage('Ошибка.Не определено значение <Вес на Табло>.');ActiveControl:=EditGoodsCode;end
                  else
                       if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                         or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                       then begin ShowMessage('Ошибка.Не определено значение <Ввод КОЛИЧЕСТВО>.');ActiveControl:=EditWeightValue;end
                       else begin ShowMessage('Ошибка.Не определено значение <Вес на Табло>.');ActiveControl:=EditGoodsCode;end;

      //
      if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
       // and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
       and (CDS.FieldByName('GoodsKindName').AsString <> '')
       and (rgGoodsKind.Items.Count > 1)
      then begin
                GoodsKindId_check:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id;
                if System.Pos(',' + IntToStr(GoodsKindId_check) + ',', ',' + CDS.FieldByName('GoodsKindId_list').AsString + ',') = 0
                then
                begin
                     ShowMessage('Ошибка.Значение <Вид упаковки> может быть только таким: <' + CDS.FieldByName('GoodsKindName').AsString + '>.');
                     ActiveControl:=EditGoodsKindCode;
                end;
      end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if rgGoodsKind.Items.Count=1 then exit;
     //
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;

          if (rgGoodsKind.ItemIndex = rgGoodsKind.Items.Count-1)or(rgGoodsKind.ItemIndex = -1)
          then findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,-1)
          else findIndex:=1+GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
          //
          EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;

     fEnterGoodsKindCode:=ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgGoodsKindClick(Sender: TObject);
var findIndex:Integer;
    fStartWrite_old:Boolean;
begin
    if rgGoodsKind.Items.Count=1 then exit;
    //
    findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
    fStartWrite_old:= fStartWrite;
    fStartWrite:=true;
    EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
    if ActiveControl <> cxDBGrid then ActiveControl:=EditGoodsKindCode;
    fStartWrite:=fStartWrite_old;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare1PropertiesChange(Sender: TObject);
begin
     //1
     try ParamsMI.ParamByName('CountTare1').AsFloat:=StrToFloat(EditTare1.Text);
     except
           ParamsMI.ParamByName('CountTare1').AsFloat:=0;
     end;
     PanelWeightTare1.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare1').AsFloat * SettingMain.WeightTare1);
     //2
     try ParamsMI.ParamByName('CountTare2').AsFloat:=StrToFloat(EditTare2.Text);
     except
           ParamsMI.ParamByName('CountTare2').AsFloat:=0;
     end;
     PanelWeightTare2.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare2').AsFloat * SettingMain.WeightTare2);
     //3
     try ParamsMI.ParamByName('CountTare3').AsFloat:=StrToFloat(EditTare3.Text);
     except
           ParamsMI.ParamByName('CountTare3').AsFloat:=0;
     end;
     PanelWeightTare3.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare3').AsFloat * SettingMain.WeightTare3);
     //4
     try ParamsMI.ParamByName('CountTare4').AsFloat:=StrToFloat(EditTare4.Text);
     except
           ParamsMI.ParamByName('CountTare4').AsFloat:=0;
     end;
     PanelWeightTare4.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare4').AsFloat * SettingMain.WeightTare4);
     //5
     try ParamsMI.ParamByName('CountTare5').AsFloat:=StrToFloat(EditTare5.Text);
     except
           ParamsMI.ParamByName('CountTare5').AsFloat:=0;
     end;
     PanelWeightTare5.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare5').AsFloat * SettingMain.WeightTare5);
     //6
     try ParamsMI.ParamByName('CountTare6').AsFloat:=StrToFloat(EditTare6.Text);
     except
           ParamsMI.ParamByName('CountTare6').AsFloat:=0;
     end;
     PanelWeightTare6.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare6').AsFloat * SettingMain.WeightTare6);
     //
     //0
     if infoPanelTare0.Visible then
     begin
            try ParamsMI.ParamByName('WeightTare').AsFloat:=StrToFloat(EditTare0.Text);
            except ParamsMI.ParamByName('WeightTare').AsFloat:=0;
            end;
            //change Количество тары
            ParamsMI.ParamByName('CountTare').AsFloat:=1;
            //
            PanelWeightTare0.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountTare').AsFloat * ParamsMI.ParamByName('WeightTare').AsFloat);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountEnter(Sender: TObject);
var Key:Word;
begin
      TEdit(Sender).SelectAll;
      Key:=13;
      //
      //if (ActiveControl=EditTareCount)and(GBUpak.Visible)
      //then begin
      //          PanelUpak.Caption:=GetStringValue('select zf_MyRound0(zf_CalcDivisionNoRound('+FormatToFloatServer(GoodsWeight)+',GoodsProperty_Detail.Ves_onUpakovka))as RetV from dba.GoodsProperty join dba.KindPackage on KindPackage.KindPackageCode = '+trim(EditKindPackageCode.Text)+' join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId=GoodsProperty.Id and GoodsProperty_Detail.KindPackageID=KindPackage.Id where GoodsProperty.GoodsCode = '+trim(EditGoodsCode.Text));
      //end;
      //
      if (ActiveControl=EditPrice)and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
        and (CDS.FieldByName('Price_Income').AsFloat > 0)
      then begin
            //EditPrice.Text:= FloatToStr(CDS.FieldByName('Price_Income').AsFloat);
      end;
      //
      if (ActiveControl=EditGoodsKindCode)or(ActiveControl=EditTareCount)
      then begin
           if CDS.FieldByName('ChangePercentAmount').AsFloat=0
           then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
           else EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);
      end;
      if (ActiveControl=EditGoodsKindCode)
      then begin
           if rgGoodsKind.Items.Count=1 then
           begin
                if infoPanelTareFix.Visible
                then ActiveControl:=EditTare1
                else ActiveControl:=EditTareCount;
                //
                exit;
           end;
           //
           ActiveControl:=EditGoodsKindCode;
           //
           if (ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0)and(CDS.RecordCount=1)
           then begin
                     fEnterGoodsKindCode:=true;
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
                     //ActiveControl:=EditTareCount;
           end;
           //
           if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
            //and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
            and (CDS.FieldByName('GoodsKindCode_max').AsInteger <> 0)
            and (fStartWrite = false)
            and (rgGoodsKind.ItemIndex = -1)
           then begin
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode_max').AsString;
                     TEdit(Sender).SelectAll;
           end;
            //
           exit;
      end;

      if (ActiveControl=EditGoodsKindCode)and(rgGoodsKind.ItemIndex>=0)and(rgGoodsKind.Items.Count=1)then begin rgGoodsKind.ItemIndex:=0;FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareCount) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin EditTareCount.Text:='0';FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareWeightCode) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareWeightEnter) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditChangePercentAmountCode)then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditPriceListCode){and(rgPriceList.ItemIndex>=0)and(rgPriceList.Items.Count=1)}then begin FormKeyDown(Sender,Key,[]);exit;end;
      //
      if (ActiveControl=EditTareWeightEnter)and(rgTareWeight.ItemIndex<>rgTareWeight.Items.Count-1)
      then begin FormKeyDown(Sender,Key,[]);exit;end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountExit(Sender: TObject);
var TareCount:Integer;
begin
     if fStartWrite=true then exit;

     try TareCount:=StrToInt(trim(EditTareCount.Text));except TareCount:=0;end;
     //
     if (TareCount>Length(TareCount_Array))
     then if infoPanelTareFix.Visible
          then ActiveControl:=EditTare1
          else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountKeyPress(Sender: TObject;var Key: Char);
var Code_begin:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          try Code_begin:=StrToInt(trim(EditTareCount.Text));except Code_begin:=0;end;
          //
          if Code_begin>=Length(TareCount_Array) then EditTareCount.Text:= '0' else EditTareCount.Text:= IntToStr(Code_begin+1);
          //
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditTareWeightCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgTareWeight.ItemIndex:=-1
     else rgTareWeight.ItemIndex:=GetArrayList_Index_byCode(TareWeight_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;

     if rgTareWeight.ItemIndex=-1 then ActiveControl:=EditTareWeightCode;
     if (rgTareWeight.ItemIndex <> rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
     then EditTareWeightEnter.Text:='';
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)or(rgTareWeight.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgTareWeight.ItemIndex;
          //
          EditTareWeightCode.Text:=IntToStr(TareWeight_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgTareWeightClick(Sender: TObject);
begin
    EditTareWeightCode.Text:=IntToStr(TareWeight_Array[rgTareWeight.ItemIndex].Code);
    if PanelTare.Visible
    then ActiveControl:=EditTareWeightCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.bbGoodsRemainsClick(Sender: TObject);
var execParams:TParams;
    GoodsCode_int:Integer;
begin
     if (fChoicePartionGoods_20103 = true) and (CDS.FieldByName('isPartionGoods_20103').AsBoolean = true)
     then exit;
     //
     Create_ParamsGoodsLine(execParams);
     execParams.ParamByName('GoodsId').AsInteger:=0;
     try execParams.ParamByName('GoodsCode').AsInteger:=StrToInt(EditGoodsCode.Text); except execParams.ParamByName('GoodsCode').AsInteger:=0; end;
     execParams.ParamByName('GoodsName').AsString:=EditGoodsName.Text;
     if rgGoodsKind.Items.Count > 1
     then begin
             execParams.ParamByName('GoodsKindId').AsInteger:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id;
             execParams.ParamByName('GoodsKindName').AsString:=GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Name;
     end
     else begin
             execParams.ParamByName('GoodsKindId').AsInteger:= 0;
             execParams.ParamByName('GoodsKindName').AsString:='';
     end;
     //
     if GuideGoodsRemainsForm.Execute(execParams)
     then begin
               EditGoodsCode.Text:= execParams.ParamByName('GoodsCode').AsString;
               //if (ActiveControl <> EditGoodsCode) and (ActiveControl <> EditGoodsName)
               //then ActiveControl:= EditWeightValue;
               //
               if rgGoodsKind.Items.Count > 1
               then begin
                   rgGoodsKind.ItemIndex:= GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,execParams.ParamByName('GoodsKindCode').AsInteger);
                   ActiveControl:= EditGoodsKindCode;
               end;
               //
               if ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Income
               then begin
                          EditPartionGoods_20103.Text:= execParams.ParamByName('PartionGoodsName').AsString;
                          //
                          ParamsMI.ParamByName('PartionGoods').AsString:=execParams.ParamByName('PartionGoodsName').AsString;
               end;
     end;
     //
     execParams.Free;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightEnterExit(Sender: TObject);
var TareWeight:Double;
begin
     if fStartWrite=true then exit;

     if trim (EditTareWeightEnter.Text)='' then EditTareWeightEnter.Text:='0';
     //
     try TareWeight:=StrToFloat(trim(EditTareWeightEnter.Text));except TareWeight:=-1;end;
     //
     if (TareWeight<0)and(gbTareWeightEnter.Visible)
     then ActiveControl:=EditTareWeightEnter;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTare1Exit(Sender: TObject);
begin
     if (ParamsMI.ParamByName('CountTare1').AsFloat < 0)//and(infoPanelTare1.Visible)
     then ActiveControl:=EditTare1;
     if (ParamsMI.ParamByName('CountTare2').AsFloat < 0)//and(infoPanelTare2.Visible)
     then ActiveControl:=EditTare2;
     if (ParamsMI.ParamByName('CountTare3').AsFloat < 0)//and(infoPanelTare3.Visible)
     then ActiveControl:=EditTare3;
     if (ParamsMI.ParamByName('CountTare4').AsFloat < 0)//and(infoPanelTare4.Visible)
     then ActiveControl:=EditTare4;
     if (ParamsMI.ParamByName('CountTare5').AsFloat < 0)//and(infoPanelTare5.Visible)
     then ActiveControl:=EditTare5;
     if (ParamsMI.ParamByName('CountTare6').AsFloat < 0)//and(infoPanelTare6.Visible)
     then ActiveControl:=EditTare6;
     if (ParamsMI.ParamByName('WeightTare').AsFloat < 0)//and(infoPanelTare0.Visible)
     then ActiveControl:=EditTare0;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditChangePercentAmountCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgChangePercentAmount.ItemIndex:=-1
     else rgChangePercentAmount.ItemIndex:=GetArrayList_Index_byCode(ChangePercentAmount_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;

     if rgChangePercentAmount.ItemIndex=-1 then ActiveControl:=EditChangePercentAmountCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgChangePercentAmount.ItemIndex = rgChangePercentAmount.Items.Count-1)or(rgChangePercentAmount.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgChangePercentAmount.ItemIndex;
          //
          EditChangePercentAmountCode.Text:=IntToStr(ChangePercentAmount_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgChangePercentAmountClick(Sender: TObject);
var newValue:String;
begin
    EditChangePercentAmountCodeChange(EditChangePercentAmountCode);
    // ActiveControl:=EditGoodsCode;
    {newValue:=IntToStr(ChangePercent_Array[rgChangePercent.ItemIndex].Code);
    if newValue<>EditChangePercentCode.Text
    then begin
              EditChangePercentCode.Text:=newValue;
              ActiveControl:=EditChangePercentCode;
    end;}

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
{     try Code_begin:=StrToInt(EditPriceListCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgPriceList.ItemIndex:=-1
     else rgPriceList.ItemIndex:=1;//GetArrayList_Index_byCode(PriceList_Array,Code_begin);
     }
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;
     {if rgPriceList.ItemIndex=-1 then ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     {if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgPriceList.ItemIndex = rgPriceList.Items.Count-1)or(rgPriceList.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgPriceList.ItemIndex;
          //
          EditPriceListCode.Text:=IntToStr(PriceList_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgPriceListClick(Sender: TObject);
begin
    {EditPriceListCodeChange(EditPriceListCode);}
    if ActiveControl=rgPriceList then ActiveControl:=EditGoodsCode;
    {EditPriceListCode.Text:=IntToStr(PriceList_Array[rgPriceList.ItemIndex].Code);
    ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DSDataChange(Sender: TObject; Field: TField);
begin
     with ParamsMI do begin
        if CDS.RecordCount=1
        then
            if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
            and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
            and(CDS.FieldByName('Weight').AsFloat > 0)
            and(SettingMain.isCalc_sht = TRUE)
            then ParamByName('RealWeight').AsFloat:=ParamByName('RealWeight_Get').AsFloat
            else
                 if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                 then try ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text); except ParamByName('RealWeight').AsFloat:=0;end
                 else ParamByName('RealWeight').AsFloat:=ParamByName('RealWeight_Get').AsFloat
        else
            ParamByName('RealWeight').AsFloat:=0;
     end;
     //
            if ((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
              or(ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut))
              and (CDS.FieldByName('Price_Income').AsFloat > 0)
            then begin
                  EditPriceIncome.Text:= FloatToStr(CDS.FieldByName('Price_Income').AsFloat);
            end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DBGridDrawColumnCell(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
{     if (AnsiUpperCase(Column.Field.FieldName)=AnsiUpperCase('Amount_diff'))
       and((CDS.FieldByName('Amount_diff').AsFloat>0)or(CDS.FieldByName('isTax_diff').AsBoolean = true))
     then
     with (Sender as TDBGrid).Canvas do
     begin
          if CDS.FieldByName('isTax_diff').AsBoolean = true then Font.Color:=clBlue;
          if CDS.FieldByName('Amount_diff').AsFloat > 0 then Font.Color:=clRed;

          FillRect(Rect);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actRefreshExecute(Sender: TObject);
var GoodsCode:String;
begin
    with spSelect do begin
        GoodsCode:= DataSet.FieldByName('GoodsCode').AsString;
        Execute;
        if GoodsCode <> '' then
          DataSet.Locate('GoodsCode',GoodsCode,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actChoiceExecute(Sender: TObject);
begin
     if CDS.FieldByName('GoodsCode').AsString <> '0'
     then begin EditGoodsCode.Text:=CDS.FieldByName('GoodsCode').AsString;
                fEnterGoodsCode:= true;
                fEnterGoodsName:= false;
                if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                then EditGoodsCodeChange(EditGoodsCode); // EditGoodsCodeExit(EditGoodsCode);

                if CDS.FieldByName('isPartionGoods_20103').AsBoolean = TRUE
                then
                    bbGoodsRemainsClick(self);
                    fChoicePartionGoods_20103:= true;
          end
     else if ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
          then begin
                {spSelect.Params.ParamByName('inGoodsCode').Value:= 0;
                spSelect.Params.ParamByName('inGoodsName').Value:= CDS.FieldByName('GoodsName').AsString;
                actRefreshExecute(Self);}

                EditGoodsName.Text:=CDS.FieldByName('GoodsName').AsString;
                fEnterGoodsCode:= false;
                fEnterGoodsName:= true;
                EditGoodsNameChange(EditGoodsName); // EditGoodsNameExit(EditGoodsName);
                //
                if CDS.FieldByName('isPartionGoods_20103').AsBoolean = TRUE
                then
                    bbGoodsRemainsClick(self);
                    fChoicePartionGoods_20103:= true;
          end;

     if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)
     then if ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
          then EditGoodsCodeChange(EditGoodsCode)
          else
     else begin
               fEnterGoodsKindCode:=true;
               if rgGoodsKind.Items.Count>1
               then EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
               EditGoodsKindCodeChange(EditGoodsKindCode);
          end;
     //
     if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
     and(ParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
     and(CDS.FieldByName('Weight').AsFloat > 0)
     then if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)and(rgGoodsKind.Items.Count>1)
          then ActiveControl:=EditGoodsKindCode
          else if infoPanelTareFix.Visible
               then ActiveControl:=EditTare1
               else ActiveControl:=EditTareCount
     else
          if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
          then ActiveControl:=EditWeightValue
          else if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)and(rgGoodsKind.Items.Count>1)
               then ActiveControl:=EditGoodsKindCode
               else if infoPanelTareFix.Visible
                    then ActiveControl:=EditTare1
                    else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actSaveExecute(Sender: TObject);
begin
     if Checked then begin fCloseOK:=true; Close; ModalResult:= mrOK; end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.bbSaveDialogClick(Sender: TObject);
begin
     if ParamsMovement.ParamByName('OrderExternalId').asInteger = 0
     then begin
       ShowMessage ('Ошибка.Операция разрешена после выбора заявки с производства.');
       exit;
     end;
     //
     if not((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
     then begin
       ShowMessage ('Ошибка.Операция разрешена только для Склада специй.');
       exit;
     end;
     //
     if MessageDlg('Действительно Сохранить?'
      + #10 + #13
      + ' ('+CDS.FieldByName('GoodsCode').AsString+') ' + CDS.FieldByName('GoodsName').AsString
       + #10 + #13
      + 'кол-во = ' + CDS.FieldByName('Amount_Order').AsString
        ,mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;

     //
     ActiveControl:=EditGoodsCode;
     actChoiceExecute(self);
     if CDS.FieldByName('Amount_Order').AsFloat > 0 then
     begin EditWeightValue.Text:= FloatToStr(CDS.FieldByName('Amount_Order').AsFloat);
           ParamsMI.ParamByName('RealWeight').AsFloat:=CDS.FieldByName('Amount_Order').AsFloat
     end;
     //ActiveControl:=EditWeightValue;
     //
     if Checked then
     begin
          MainForm.RefreshDataSet;
          MainForm.WriteParamsMovement;
          //
          MainForm.EditCountPack.Text:='';
          MainForm.EditHeadCount.Text:='';
          MainForm.EditBarCode.Text:='';
          MainForm.EditBoxCount.Text:=GetArrayList_Value_byName(Default_Array,'BoxCount');
          //
          //очистили предыдущие и откроем диалог для ввода всех параметров товара
          EmptyValuesParams(ParamsMI);
          //
          Execute (ParamsMovement , TRUE, TRUE);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
     CanClose:=false;
           if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
             or (fCloseOK = true)
           then CanClose:=true
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('Для отмены взвешивания необходимо ввести пароль.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('Пароль неверный.Отменить взвешивание нельзя.');exit;end
                     else CanClose:=true;
                end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCreate(Sender: TObject);
var i:Integer;
begin
  fStartWrite:=true;
  //
  oldParam1:=-1;
  oldParam2:=-1;
  // tare-main
  PanelTare.Visible:= SettingMain.WeightTare1 = 0;
  rgTareWeight.Visible:= SettingMain.WeightTare1 = 0;
  //вес тары (ручной режим)
  gbTareWeightEnter.Visible:=(SettingMain.WeightTare1 = 0)and(GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE'));
  // tare-fix
  infoPanelTareFix.Visible:= SettingMain.WeightTare1 > 0;
  infoPanelTare1.Visible:= SettingMain.WeightTare1 > 0;infoPanelTare1.Height:=35;
  infoPanelTare2.Visible:= SettingMain.WeightTare2 > 0;infoPanelTare2.Height:=35;
  infoPanelTare3.Visible:= SettingMain.WeightTare3 > 0;infoPanelTare3.Height:=35;
  infoPanelTare4.Visible:= SettingMain.WeightTare4 > 0;infoPanelTare4.Height:=35;
  infoPanelTare5.Visible:= SettingMain.WeightTare5 > 0;infoPanelTare5.Height:=35;
  infoPanelTare6.Visible:= SettingMain.WeightTare6 > 0;infoPanelTare6.Height:=35;
  //вес тары (ручной режим)
  infoPanelTare0.Visible:=(SettingMain.WeightTare1 > 0)and(GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE'));
  infoPanelTare0.Height:=35;
  //
       if infoPanelTare6.Visible then infoPanelTareFix.Height:=35*6
  else if infoPanelTare5.Visible then infoPanelTareFix.Height:=35*5
  else if infoPanelTare4.Visible then infoPanelTareFix.Height:=35*4
  else if infoPanelTare3.Visible then infoPanelTareFix.Height:=35*3
  else if infoPanelTare2.Visible then infoPanelTareFix.Height:=35*2
  else if infoPanelTare1.Visible then infoPanelTareFix.Height:=35*1;
  if infoPanelTare0.Visible then infoPanelTareFix.Height:=infoPanelTareFix.Height + 35;
  infoPanelTareFix.Height:=infoPanelTareFix.Height + 4;
  //
  LabelTare1.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare1)+' кг';
  LabelTare2.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare2)+' кг';
  LabelTare3.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare3)+' кг';
  LabelTare4.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare4)+' кг';
  LabelTare5.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare5)+' кг';
  LabelTare6.Caption:= 'Тара по '+FloatToStr(SettingMain.WeightTare6)+' кг';
  LabelTare0.Caption:= 'Ручной Вес тары, кг';
  //
  //
  //вес тары
  for i := 0 to Length(TareWeight_Array)-1 do
    if TareWeight_Array[i].Number>=1000
    then rgTareWeight.Items.Add('('+IntToStr(0)+') '+ TareWeight_Array[i].Name)
    else rgTareWeight.Items.Add('('+IntToStr(TareWeight_Array[i].Code)+') '+ TareWeight_Array[i].Name);
  //Скидка по весу
  for i := 0 to Length(ChangePercentAmount_Array)-1 do
    rgChangePercentAmount.Items.Add('('+IntToStr(ChangePercentAmount_Array[i].Code)+') '+ ChangePercentAmount_Array[i].Name);
  rgChangePercentAmount.Columns:=Length(ChangePercentAmount_Array);
  //прайс-лист
  {for i := 0 to Length(PriceList_Array)-1 do
    rgPriceList.Items.Add('('+IntToStr(PriceList_Array[i].Code)+') '+ PriceList_Array[i].Name);}

  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_Remains').Index].Visible:=(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Goods';
       OutputType:=otDataSet;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       if Self.Tag < 0
       then Params.AddParam('inMovementId', ftInteger, ptInput, Self.Tag)
       else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, 0);
       Params.AddParam('inPriceListId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsName', ftString, ptInput, '');
       Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput,GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn'));
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Execute;
  end;
  //
{
     // PriceList
     if _isCalcPriceList=zc_rvYes
     then begin
            rgKindPackage.Columns:=2;
            rgPriceList.Columns:=1;
            PriceListPanel.Width:=PriceListPanel.Width-100;
            EditPriceListCode.Width:=EditPriceListCode.Width-100;
            KindPackagePanel.Width:=KindPackagePanel.Width+100;
            rgPriceList.Items.Add('(1) '+_PriceListName_byCalc_new);
            rgPriceList.Items.Add('(2) '+_PriceListName_byCalc_old);
          end
     else
         for i:=0 to ParamsPriceList.Count-1 do
            rgPriceList.Items.Add('('+IntToStr(i+1)+') '+GetStringValue('select PriceListName AS RetV from dba.PriceList_byHistory where Id = '+ParamsPriceList.Items[i].AsString));
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormDestroy(Sender: TObject);
begin
  if Assigned (ParamsMI) then begin ParamsMI.Free;ParamsMI:=nil;end;
  if Assigned (ParamsMovement) then begin ParamsMovement.Free;ParamsMovement:=nil;end;
end;
{------------------------------------------------------------------------------}
end.
