unit Receipt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, DataModul, ParentForm,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxButtonEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, ChoicePeriod, dsdDB, dsdAction, System.Classes, Vcl.ActnList,
  dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient,
  cxCheckBox, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, Vcl.Controls, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, cxCurrencyEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdGuides, Vcl.ExtCtrls, ExternalLoad, dsdCommon;

type
  TReceiptForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Value: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    IsMain: TcxGridDBColumn;
    PartionCount: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    PartionValue: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    GoodsKindCompleteName: TcxGridDBColumn;
    ReceiptCostName: TcxGridDBColumn;
    ReceiptKindName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridReceiptChild: TcxGrid;
    cxGridDBTableViewReceiptChild: TcxGridDBTableView;
    GoodsKindNameclChild: TcxGridDBColumn;
    ValueChild: TcxGridDBColumn;
    IsErasedChild: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    spInsertUpdateReceiptChild: TdsdStoredProc;
    spSelectReceiptChild: TdsdStoredProc;
    ReceiptChildChoiceForm: TOpenChoiceForm;
    InsertRecordCCK: TInsertRecord;
    bbInsertRecCCK: TdxBarButton;
    actReceiptChild: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    ReceiptCode: TcxGridDBColumn;
    ChildViewAddOn: TdsdDBViewAddOn;
    GoodsNameChild: TcxGridDBColumn;
    Goods_ObjectChoiceForm: TOpenChoiceForm;
    CommentChild: TcxGridDBColumn;
    ValueCost: TcxGridDBColumn;
    TaxExit: TcxGridDBColumn;
    bbStartDate: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    bbEndDate: TdxBarControlContainerItem;
    bbIsEndDate: TdxBarControlContainerItem;
    bbIsPeriod: TdxBarControlContainerItem;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    StartDateChild: TcxGridDBColumn;
    EndDateChild: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    cxBottomSplitter: TcxSplitter;
    TotalWeightMain: TcxGridDBColumn;
    TotalWeight: TcxGridDBColumn;
    GoodsCodeChild: TcxGridDBColumn;
    WeightPackage: TcxGridDBColumn;
    MeasureNameChild: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GroupNumber: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Code_Parent: TcxGridDBColumn;
    Name_Parent: TcxGridDBColumn;
    ReceiptCode_Parent: TcxGridDBColumn;
    isMain_Parent: TcxGridDBColumn;
    GoodsCode_Parent: TcxGridDBColumn;
    GoodsName_Parent: TcxGridDBColumn;
    MeasureName_Parent: TcxGridDBColumn;
    GoodsKindName_Parent: TcxGridDBColumn;
    GoodsKindCompleteName_Parent: TcxGridDBColumn;
    GoodsGroupAnalystName: TcxGridDBColumn;
    GoodsTagName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    isCheck_Parent: TcxGridDBColumn;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    actPrint: TdsdPrintAction;
    actPrintDetail: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintDetail: TdxBarButton;
    spPrintReceiptChildDetail: TdsdStoredProc;
    PrintReceiptChildDetailCDS: TClientDataSet;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyCodeChild: TcxGridDBColumn;
    InfoMoneyGroupNameChild: TcxGridDBColumn;
    InfoMoneyDestinationNameChild: TcxGridDBColumn;
    InfoMoneyNameChild: TcxGridDBColumn;
    ValueWeight_calc: TcxGridDBColumn;
    TaxLoss: TcxGridDBColumn;
    ValueWeight: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    PrintMasterCDS: TClientDataSet;
    spPrintReceipt: TdsdStoredProc;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    UpdateName: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    clInsertName: TcxGridDBColumn;
    clUpdateName: TcxGridDBColumn;
    clInsertDate: TcxGridDBColumn;
    clUpdateDate: TcxGridDBColumn;
    ProtocolOpenFormChild: TdsdOpenForm;
    bbProtocolChild: TdxBarButton;
    spUpdateTaxExit: TdsdStoredProc;
    actUpdateTaxExit: TdsdExecStoredProc;
    actUpdateWeightMain: TdsdExecStoredProc;
    spUpdateWeightMain: TdsdStoredProc;
    bbUpdateTaxExit: TdxBarButton;
    bbUpdateWeightMain: TdxBarButton;
    spErasedUnErasedReceiptChild: TdsdStoredProc;
    dsdSetErasedReceiptChild: TdsdUpdateErased;
    bbSetErasedReceiptChild: TdxBarButton;
    dsdSetUnErasedReceiptChild: TdsdUpdateErased;
    bbSetUnErasedReceiptChild: TdxBarButton;
    spErasedUnErasedReceipt: TdsdStoredProc;
    Check_Weight: TcxGridDBColumn;
    Check_PartionValue: TcxGridDBColumn;
    Check_TaxExit: TcxGridDBColumn;
    TaxExitCheck: TcxGridDBColumn;
    isParentMulti: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    Panel: TPanel;
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesGoodsKind: TdsdGuides;
    bbExecuteDialog: TdxBarButton;
    spUpdateDisabled_yes: TdsdStoredProc;
    spUpdateDisabled_no: TdsdStoredProc;
    actUpdateDisabled_yes: TdsdExecStoredProc;
    actUpdateDisabled_no: TdsdExecStoredProc;
    bbUpdateDisabled_yes: TdxBarButton;
    bbUpdateDisabled_no: TdxBarButton;
    chReceiptLevelName: TcxGridDBColumn;
    actReceiptLevelChoiceForm: TOpenChoiceForm;
    cxLabel2: TcxLabel;
    edReceiptLevel: TcxButtonEdit;
    GuidesReceiptLevel: TdsdGuides;
    spUpdate_isIrna: TdsdStoredProc;
    actUpdate_isIrna: TdsdExecStoredProc;
    macUpdate_isIrna_list: TMultiAction;
    macUpdate_isIrna: TMultiAction;
    bbUpdate_isIrna: TdxBarButton;
    spUpdateReal: TdsdStoredProc;
    actUpdateReal: TdsdExecStoredProc;
    bbUpdateReal: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDoLoad_ReceiptCost: TExecuteImportSettingsAction;
    actGetImportSetting_ReceiptCost: TdsdExecStoredProc;
    macStartLoad_ReceiptCost: TMultiAction;
    bbStartLoad_ReceiptCost: TdxBarButton;
    cbSave: TcxCheckBox;
    cbDel: TcxCheckBox;
    spUpdateisEtiketka: TdsdStoredProc;
    actUpdateEtiketka: TdsdExecStoredProc;
    bbUpdateEtiketka: TdxBarButton;
    ValuePF: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReceiptForm);

end.

{
OperCount_TotalMaterialBasis - Итого~Вес сырья
case when Receipt_byHistory.KindPackageId in (zc_KindPackage_PF(),zc_KindPackage_groupPF())
          then fCalc_OperCount_TotalMaterialBasis_byReceipt(Receipt_byHistory.ReceiptId,Receipt_byHistory.StartDate)
     else isnull(fromReceipt_byHistory.OperCount,isnull(fromReceipt_byHistoryTwo.OperCount,0))
end as OperCount_TotalMaterialBasis

case when Receipt_byHistory.KindPackageId in (zc_KindPackage_PF(),zc_KindPackage_groupPF())
          then fCalc_OperCount_TotalVes_byReceipt(Receipt_byHistory.ReceiptId,Receipt_byHistory.StartDate)
     else isnull(ReceiptItem_byHistory_find.OperCount,0)
end as OperCount_TotalVes

(case when Receipt_byHistory.KindPackageId in (zc_KindPackage_PF(),zc_KindPackage_groupPF())
            then (OperCount_byVes-OperCount_TotalVes)
       when ReceiptItem_byHistory_find.ReceiptId is not null or isnull(fromReceipt_byHistory.ReceiptId,fromReceipt_byHistoryTwo.ReceiptId) is not null
            then OperCount_TotalVes-OperCount_TotalMaterialBasis
       else 0 end)as checkOperCount = Check_Weight



,Receipt_byHistory.OperCount*case when GoodsProperty.MeasureId=zc_measure_Sht(*) then isnull(GoodsProperty_Detail.Ves_onMeasure,0) else 1 end as OperCount_byVes
,isnull(toReceipt_byHistory.OperCount,toReceipt_byHistoryTwo.OperCount)as toOperCount
,case when Receipt_byHistory.KindPackageId=zc_KindPackage_PF()
           then (Receipt_byHistory.TaxExit-toOperCount)

      when ReceiptItem_byHistory_find.ReceiptId is not null and isnull(fromReceipt_byHistory.TaxExit,isnull(fromReceipt_byHistoryTwo.TaxExit,0))<>Receipt_byHistory.TaxExit
           then isnull(fromReceipt_byHistory.TaxExit,isnull(fromReceipt_byHistoryTwo.TaxExit,0))-Receipt_byHistory.TaxExit

      when ReceiptItem_byHistory_find.ReceiptId is not null
           then Receipt_byHistory.TaxExit-OperCount_byVes

      else Receipt_byHistory.TaxExit-100
end as checkTaxExit




(case when Receipt_byHistory.KindPackageId in (zc_KindPackage_PF(),zc_KindPackage_groupPF())
           then (OperCount_byVes-Receipt_byHistory.PartionValue)
      else Receipt_byHistory.PartionValue
end)as checkPartionValue = Check_PartionValue
}
