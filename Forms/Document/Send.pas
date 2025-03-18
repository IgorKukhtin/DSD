unit Send;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  ExternalLoad, dsdCommon;

type
  TSendForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    Count: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    StorageName: TcxGridDBColumn;
    actUnitChoiceForm: TOpenChoiceForm;
    actStorageChoiceForm: TOpenChoiceForm;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    Price: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actAssetGoodsChoiceForm: TOpenChoiceForm;
    AmountRemains: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    edIsAuto: TcxCheckBox;
    actGoodsKindCompleteChoice: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    spSelectPrintNoGroup: TdsdStoredProc;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    cxLabel8: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    edInsertName: TcxButtonEdit;
    cxLabel27: TcxLabel;
    edInvNumberSend: TcxButtonEdit;
    GuidesSendDoc: TdsdGuides;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    GuidesInvNumberOrder: TdsdGuides;
    cxLabel9: TcxLabel;
    edSubjectDoc: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    bbPrintSaleOrderTax: TdxBarButton;
    spInsertUpdateMovement_order: TdsdStoredProc;
    HeaderSaver1: THeaderSaver;
    cxLabel10: TcxLabel;
    edPersonalGroup: TcxButtonEdit;
    GuidesPersonalGroup: TdsdGuides;
    actPersonalGroupChoiceForm: TOpenChoiceForm;
    spUpdatePersonalGroup: TdsdStoredProc;
    bbPersonalGroupChoiceForm: TdxBarButton;
    actUpdatePersonalGroup: TdsdExecStoredProc;
    macUpdatePersonalGroup: TMultiAction;
    actPartionGoods20202ChoiceForm: TOpenChoiceForm;
    InsertRecord20202: TInsertRecord;
    bbInsertRecord20202: TdxBarButton;
    macInsertRecord20202: TMultiAction;
    cxTabSheetDetail: TcxTabSheet;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    DBViewAddOnDetail: TdsdDBViewAddOn;
    spSelectDetail: TdsdStoredProc;
    cxGridDetail: TcxGrid;
    cxGridDBTableViewDetail: TcxGridDBTableView;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    GoodsKindName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    ReturnKindName_ch2: TcxGridDBColumn;
    SubjectDocName_ch2: TcxGridDBColumn;
    cxGridLevelDetail: TcxGridLevel;
    cxLabel11: TcxLabel;
    edReturnKind: TcxButtonEdit;
    GuidesReturnKind: TdsdGuides;
    actReturnKindOpenForm: TOpenChoiceForm;
    actSubjectDocOpenForm: TOpenChoiceForm;
    spInsertMaskMIDetail: TdsdStoredProc;
    spInsertUpdateMIDetail: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    actAddMaskDetail: TdsdExecStoredProc;
    bbAddMaskDetail: TdxBarButton;
    actShowAllDetail: TBooleanStoredProcAction;
    bbShowAllDetail: TdxBarButton;
    actMISetErasedDetail: TdsdUpdateErased;
    actMISetUnErasedDetail: TdsdUpdateErased;
    spUnErasedMIDetail: TdsdStoredProc;
    spErasedMIDetail: TdsdStoredProc;
    bbMISetErasedDetail: TdxBarButton;
    bbMISetUnErasedDetail: TdxBarButton;
    actShowErasedDetail: TBooleanStoredProcAction;
    bbShowErasedDetail: TdxBarButton;
    PartionGoodsId: TcxGridDBColumn;
    ord: TcxGridDBColumn;
    actSaleJournalChoice: TOpenChoiceForm;
    actUpdateMask: TdsdExecStoredProc;
    spUpdateMask: TdsdStoredProc;
    mactUpdateMaskSale: TMultiAction;
    bbUpdateMaskSale: TdxBarButton;
    actReturnInJournalChoice: TOpenChoiceForm;
    mactUpdateMaskReturn: TMultiAction;
    bbUpdateMaskReturn: TdxBarButton;
    actReturnOutJournalChoice: TOpenChoiceForm;
    actIncomeJournalChoice: TOpenChoiceForm;
    mactUpdateMaskIncome: TMultiAction;
    mactUpdateMaskReturnOut: TMultiAction;
    bbUpdateMaskIncome: TdxBarButton;
    bbUpdateMaskReturnOut: TdxBarButton;
    actOpenFormOrderExternalChildSend: TdsdInsertUpdateAction;
    bbOpenFormOrderExtChildSend: TdxBarButton;
    AssetName: TcxGridDBColumn;
    AssetCode: TcxGridDBColumn;
    actAssetChoiceForm: TOpenChoiceForm;
    edInvNumberProduction: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesProductionDoc: TdsdGuides;
    actOpenProductionForm: TdsdOpenForm;
    bbOpenProductionForm: TdxBarButton;
    cxTabSheetChild: TcxTabSheet;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    spGetImportSetting: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macLoadExcel: TMultiAction;
    bbLoadExcel: TdxBarButton;
    spGetImportSetting2: TdsdStoredProc;
    actGetImportSetting2: TdsdExecStoredProc;
    macLoadExcel2: TMultiAction;
    bbLoadExcel2: TdxBarButton;
    actPartionGoodsAssetChoiceForm: TOpenChoiceForm;
    actInsertRecordAsset: TInsertRecord;
    macInsertRecordAsset: TMultiAction;
    bbInsertRecordAsset: TdxBarButton;
    bbPartionGoodsAssetChoiceForm: TdxBarButton;
    PartionModelName: TcxGridDBColumn;
    actAssetGoodsChoiceFormPC: TOpenChoiceForm;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxTabSheet_PartionCell: TcxTabSheet;
    cxGrid_PartionCell: TcxGrid;
    cxGridDBTableView_PartionCell: TcxGridDBTableView;
    GoodsGroupNameFull_ch4: TcxGridDBColumn;
    GoodsCode_ch4: TcxGridDBColumn;
    GoodsName_ch4: TcxGridDBColumn;
    GoodsKindName_ch4GoodsKindName: TcxGridDBColumn;
    MeasureName_ch4: TcxGridDBColumn;
    Amount_ch4: TcxGridDBColumn;
    PartionCellName_1_ch4: TcxGridDBColumn;
    PartionCellName_2_ch4: TcxGridDBColumn;
    isPartionCell_Close_1_ch4: TcxGridDBColumn;
    cxGridLevel_PartionCell: TcxGridLevel;
    PartionCellDS: TDataSource;
    PartionCellCDS: TClientDataSet;
    PartionCell_Amount_1_ch4: TcxGridDBColumn;
    PartionCell_Last_ch4: TcxGridDBColumn;
    spSelect_MI_PartionCell: TdsdStoredProc;
    DBViewAddOn_PartionCell: TdsdDBViewAddOn;
    actOpenPartionCellForm1: TOpenChoiceForm;
    actOpenPartionCellForm2: TOpenChoiceForm;
    actOpenPartionCellForm3: TOpenChoiceForm;
    actOpenPartionCellForm4: TOpenChoiceForm;
    actOpenPartionCellForm5: TOpenChoiceForm;
    spInsertUpdateMIPartionCell: TdsdStoredProc;
    actUpdatePartionCellDS: TdsdUpdateDataSet;
    actUpdateMIPertionCell_edit: TdsdInsertUpdateAction;
    bbUpdateMIPertionCell_edit: TdxBarButton;
    actUpdate_PartionGoodsDate: TdsdExecStoredProc;
    ExecuteDialogUpdatePartionGoodsDate: TExecuteDialog;
    actUpdatePartionGoodsDate: TdsdDataSetRefresh;
    macUpdatePartionGoodsDate: TMultiAction;
    spUpdateMI_PartionGoodsDate: TdsdStoredProc;
    bbUpdatePartionGoodsDate: TdxBarButton;
    actRefreshPartionCell: TdsdDataSetRefresh;
    GoodsName_old: TcxGridDBColumn;
    actGoodsKindChoicePC: TOpenChoiceForm;
    OpenChoiceForm1: TOpenChoiceForm;
    spUnErasedMIPC: TdsdStoredProc;
    spErasedMIPC: TdsdStoredProc;
    actMISetErasedPC: TdsdUpdateErased;
    actMISetUnErasedPC: TdsdUpdateErased;
    bbMISetErasedPC: TdxBarButton;
    bbMISetUnErasedPC: TdxBarButton;
    actShowErasedPC: TBooleanStoredProcAction;
    bbShowErasedPC: TdxBarButton;
    isErased_ch4: TcxGridDBColumn;
    actGridDetailToExcel: TdsdGridToExcel;
    actGridChildlToExcel: TdsdGridToExcel;
    actGrid_PartionCelllToExcel: TdsdGridToExcel;
    bbGridDetailToExcel: TdxBarButton;
    bbGridChildlToExcel: TdxBarButton;
    bbGrid_PartionCelllToExcel: TdxBarButton;
    cbisRePack: TcxCheckBox;
    bbsPrint: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    actMICellProtocolOpenForm: TdsdOpenForm;
    bbMICellProtocol: TdxBarButton;
    spUpdate_isRePack: TdsdStoredProc;
    actUpdate_isRePack: TdsdExecStoredProc;
    bbUpdate_isRePack: TdxBarButton;
    spSelectPrint_Pack: TdsdStoredProc;
    actPrintPackGross: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendForm);

end.
