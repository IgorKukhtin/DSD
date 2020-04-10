unit SignInternal;

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
  dxSkinXmas2008Blue;

type
  TSignInternalForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
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
    dsdChoiceGuides: TdsdChoiceGuides;
    Name: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridReceiptChild: TcxGrid;
    cxGridDBTableViewReceiptChild: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    spInsertUpdateSignInternalItem: TdsdStoredProc;
    spSelectSignInternalItem: TdsdStoredProc;
    UserChoiceForm: TOpenChoiceForm;
    InsertRecordCCK: TInsertRecord;
    bbInsertRecCCK: TdxBarButton;
    actUpdateSignInternalItem: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    ChildViewAddOn: TdsdDBViewAddOn;
    Unit_ObjectChoiceForm: TOpenChoiceForm;
    bbStartDate: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    bbEndDate: TdxBarControlContainerItem;
    bbIsEndDate: TdxBarControlContainerItem;
    bbIsPeriod: TdxBarControlContainerItem;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    Code: TcxGridDBColumn;
    cxBottomSplitter: TcxSplitter;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrintDetail: TdxBarButton;
    PrintMasterCDS: TClientDataSet;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    ProtocolOpenFormChild: TdsdOpenForm;
    bbProtocolChild: TdxBarButton;
    bbUpdateTaxExit: TdxBarButton;
    bbUpdateWeightMain: TdxBarButton;
    spErasedUnErasedSignInternalItem: TdsdStoredProc;
    dsdSetErasedSignInternalItem: TdsdUpdateErased;
    bbSetErasedReceiptChild: TdxBarButton;
    dsdSetUnErasedSignInternalItem: TdsdUpdateErased;
    bb: TdxBarButton;
    spErasedUnErasedSignInternal: TdsdStoredProc;
    BranchName: TcxGridDBColumn;
    cxUnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    MovementDescChoiceForm: TOpenChoiceForm;
    ObjectDescChoiceForm: TOpenChoiceForm;
    UserId: TcxGridDBColumn;
    isMain: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSignInternalForm);

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
