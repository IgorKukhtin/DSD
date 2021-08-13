unit OrderInternalPromo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad,
  dsdInternetAction;

type
  TOrderInternalPromoForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MI_PromoChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    chIsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    edStartSale: TcxDateEdit;
    cxLabel3: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    UnitChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc;
    actGetImportSettingId: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spInsertUpdate_MovementItem_Promo_Set_Zero: TdsdStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    cxSplitter2: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clJuridicalCode: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clIsReport: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    PartnerDCS: TClientDataSet;
    PartnerDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoPartner: TdsdStoredProc;
    clComment: TcxGridDBColumn;
    PartnerChoiceForm: TOpenChoiceForm;
    InsertRecordPartner: TInsertRecord;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdatePromoPartner: TdsdStoredProc;
    actUpdatePartnerDS: TdsdUpdateDataSet;
    spSetErasedPromoPartner: TdsdStoredProc;
    spUnCompletePromoPartner: TdsdStoredProc;
    actSetErasedPromoPartner: TdsdUpdateErased;
    actSetUnErasedPromoPartner: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    spInsertPromoPartner: TdsdStoredProc;
    actInsertPromoPartner: TdsdExecStoredProc;
    macInsertPromoPartner: TMultiAction;
    actRefreshPromoPartner: TdsdDataSetRefresh;
    bbInsertPromoPartner: TdxBarButton;
    actOpenReport: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    bbInsertOrderInternal: TdxBarButton;
    actUpdateMovementItemContainer: TdsdExecStoredProc;
    spUpdate_MovementItemContainer: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    actInsertChild: TdsdExecStoredProc;
    actInsertMaster: TdsdExecStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    bbUpdateMaster_calc: TdxBarButton;
    bbInsertChild: TdxBarButton;
    InvNumber_Promo_Full: TcxGridDBColumn;
    spInsert: TdsdStoredProc;
    spInsertChild: TdsdStoredProc;
    isReport: TcxGridDBColumn;
    chKoeff: TcxGridDBColumn;
    chAmountManual: TcxGridDBColumn;
    AmountManual: TcxGridDBColumn;
    spInsertOrderInternal: TdsdStoredProc;
    actInsertOrderInternal: TdsdExecStoredProc;
    AmountTotal: TcxGridDBColumn;
    AmountOut_avg: TcxGridDBColumn;
    RemainsDay: TcxGridDBColumn;
    RemainsDay2: TcxGridDBColumn;
    chRemainsDay: TcxGridDBColumn;
    MakerName_Promo: TcxGridDBColumn;
    actContractChoice: TOpenChoiceForm;
    InsertRecordMaster: TInsertRecord;
    actGoodsChoiceForm: TOpenChoiceForm;
    actGoodsPromoChoiceForm: TOpenChoiceForm;
    InsertRecordPromoMaster: TInsertRecord;
    bbInsertRecordMaster: TdxBarButton;
    bbInsertRecordPromoMaster: TdxBarButton;
    spUpdateMaster_calc: TdsdStoredProc;
    actUpdateMaster_calc: TdsdExecStoredProc;
    ceTotalAmount: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    ceTotalSummPrice: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceTotalSummSIP: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    spUpdateMasterAmount: TdsdStoredProc;
    actUpdateMasterAmount: TdsdExecStoredProc;
    bbUpdateMasterAmount: TdxBarButton;
    bbInsertByPromo: TdxBarButton;
    actPromoJournalChoiceForm: TOpenChoiceForm;
    spInsertByPromo: TdsdStoredProc;
    macInsertByPromo: TMultiAction;
    spUpdate_Price: TdsdStoredProc;
    actUpdate_Price: TdsdExecStoredProc;
    bbUpdate_Price: TdxBarButton;
    actUnitForOrderInternalPromo: TdsdOpenForm;
    bbUnitForOrderInternalPromo: TdxBarButton;
    actUnitTreeForm: TOpenChoiceForm;
    actInsert_Movement_Send: TdsdExecStoredProc;
    spInsert_Movement_Send: TdsdStoredProc;
    bbInsert_Movement_Send: TdxBarButton;
    actDistributionCalculation: TdsdOpenForm;
    dxBarButton2: TdxBarButton;
    isChecked: TcxGridDBColumn;
    actSetChecked: TMultiAction;
    actClearChecked: TMultiAction;
    bbSetChecked: TdxBarButton;
    bbClearChecked: TdxBarButton;
    actExecSetChecked: TdsdExecStoredProc;
    actExecClearChecked: TdsdExecStoredProc;
    spSetChecked: TdsdStoredProc;
    spClearChecked: TdsdStoredProc;
    isComplement: TcxGridDBColumn;
    actSetComplement: TMultiAction;
    actExecSetComplement: TdsdExecStoredProc;
    actClearComplement: TMultiAction;
    actExecClearComplement: TdsdExecStoredProc;
    spClearComplement: TdsdStoredProc;
    spSetComplement: TdsdStoredProc;
    bbSetComplement: TdxBarButton;
    bbClearComplement: TdxBarButton;
    AddToM: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    CorrPrice: TcxGridDBColumn;
    cxGridExport: TcxGrid;
    cxGridExportDBTableView: TcxGridDBTableView;
    cxGridExportLevel1: TcxGridLevel;
    actExportStoredproc: TdsdExecStoredProc;
    actExportToPartner: TExportGrid;
    actGetDocumentDataForEmail: TdsdExecStoredProc;
    SMTPFileAction: TdsdSMTPFileAction;
    mactSMTPSend: TMultiAction;
    spGetExportParam: TdsdStoredProc;
    spSelectExport: TdsdStoredProc;
    dxBarButton4: TdxBarButton;
    spGetDocumentDataForEmail: TdsdStoredProc;
    geGoodsName: TcxGridDBColumn;
    geJuridicalName: TcxGridDBColumn;
    ExportItemsDS: TDataSource;
    ExportItemsCDS: TClientDataSet;
    ExportHeaderCDS: TClientDataSet;
    spSelectExportJuridical: TdsdStoredProc;
    actExecSPSelectExportJuridical: TdsdExecStoredProc;
    ExportJuridicalCDS: TClientDataSet;
    actSMTPSend: TMultiAction;
    ExportJuridicalDS: TDataSource;
    actLoadListUnit: TdsdLoadListValuesFileAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalPromoForm);

end.
